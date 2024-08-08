//
//  AuthenticationManager.swift
//
//
//  Created by Krish Mittal on 01/08/24.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices
import CryptoKit
import FirebaseStorage

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationError: Error {
    case tokenError(message: String)
}

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    let firestore = FirestoreDatabaseManager.shared
    
    private init() {
        setupAuthStateListener()
    }
    
    var name = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    var authenticationState: AuthenticationState = .unauthenticated
    var isValid: Bool  = false
    var errorMessage: String = ""
    var currentUserId: String = ""
    var user: AAUser?
    var displayName = ""
    var inputImage: UIImage?
    var zodiac = ""
    
    private var handler: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?
    private var userListener: ListenerRegistration?
    
    // MARK: - Public Methods
    
    func signInAnonymously(completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signInAnonymously { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false, error)
                return
            }
            
            if let user = authResult?.user {
                self.name = "Anonymous User"
                self.email = ""
                self.insertUserRecord(id: user.uid) { result in
                    switch result {
                    case .success:
                        completion(true, nil)
                    case .failure(let error):
                        completion(false, error)
                    }
                }
                completion(true, nil)
            } else {
                completion(false, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create anonymous user"]))
            }
        }
    }
    
    func signInWithEmailPassword(completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: self.email, password: self.password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false, error)
                return
            }
            self.name = authResult?.user.displayName ?? ""
            self.email = authResult?.user.email ?? ""
            completion(true, nil)
        }
    }
    
    func signUpWithEmailPassword(completion: @escaping (Bool, Error?) -> Void) {
        guard validate() else {
            completion(false, nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false, error)
                return
            }
            
            if let user = authResult?.user {
                user.sendEmailVerification { error in
                    if let error = error {
                        print("Error sending verification email: \(error.localizedDescription)")
                    } else {
                        print("Verification email sent successfully!")
                    }
                }
                self.insertUserRecord(id: user.uid) { result in
                    switch result {
                    case .success:
                        completion(true, nil)
                    case .failure(let error):
                        completion(false, error)
                    }
                }
                completion(true, nil)
            }
        }
    }
    
    func resetPassword(completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        userListener = firestore.addListener(collectionPath: AAUserModelName.userFirestore, documentId: userId, as: AAUser.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                print("Error fetching user: \(error.localizedDescription)")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func delete() {
        Auth.auth().currentUser?.delete()
    }
    
    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Bool, Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase Config")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false, error)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self.errorMessage = "Failed to get ID token."
                completion(false, nil)
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(false, error)
                    return
                }
                
                self.name = authResult?.user.displayName ?? ""
                self.email = authResult?.user.email ?? ""
                self.insertUserRecord(id: authResult?.user.uid ?? "") { result in
                    switch result {
                    case .success:
                        completion(true, nil)
                    case .failure(let error):
                        completion(false, error)
                    }
                }
                completion(true, nil)
            }
        }
    }
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>, completion: @escaping (Bool, Error?) -> Void) {
        switch result {
        case .failure(let error):
            errorMessage = error.localizedDescription
            completion(false, error)
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    completion(false, AuthenticationError.tokenError(message: "Invalid state: A login callback was received, but no login request was sent."))
                    return
                }
                guard let appleIDToken = appleIDCredential.identityToken,
                      let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to fetch identity token")
                    completion(false, AuthenticationError.tokenError(message: "Unable to fetch identity token"))
                    return
                }
                
                let credential = OAuthProvider.credential(providerID:  AuthProviderID(rawValue: "apple.com")!, idToken: idTokenString, rawNonce: nonce)
                
                Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                    guard let self = self else { return }
                    if let error = error {
                        print("Error authenticating: \(error.localizedDescription)")
                        completion(false, error)
                        return
                    }
                    
                    if let user = authResult?.user {
                        // Capture user's name from Apple ID credential
                        if let fullName = appleIDCredential.fullName {
                            let givenName = fullName.givenName ?? ""
                            let familyName = fullName.familyName ?? ""
                            self.name = "\(givenName) \(familyName)".trimmingCharacters(in: .whitespaces)
                        }
                        
                        // If name is still empty, use email or a default name
                        if self.name.isEmpty {
                            self.name = user.email ?? "Apple User"
                        }
                        
                        self.email = user.email ?? ""
                        
                        // Update user's display name if it's not set
                        if user.displayName == nil || user.displayName!.isEmpty {
                            let changeRequest = user.createProfileChangeRequest()
                            changeRequest.displayName = self.name
                            changeRequest.commitChanges { error in
                                if let error = error {
                                    print("Couldn't update display name: \(error.localizedDescription)")
                                }
                            }
                        }
                        
                        self.insertUserRecord(id: user.uid) { result in
                            switch result {
                            case .success:
                                completion(true, nil)
                            case .failure(let error):
                                completion(false, error)
                            }
                        }
                        completion(true, nil)
                    } else {
                        completion(false, AuthenticationError.tokenError(message: "Unable to create user"))
                    }
                    
                }
            }
        }
    }
    
    func verifySignInWithAppleAuthenticationState() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        if let appleProviderData = Auth.auth().currentUser?.providerData.first(where: { $0.providerID == "apple.com" }) {
            appleIDProvider.getCredentialState(forUserID: appleProviderData.uid) { credentialState, error in
                if let error = error {
                    print("Error verifying Apple Sign In state: \(error)")
                    return
                }
                
                switch credentialState {
                case .authorized:
                    break // The Apple ID credential is valid.
                case .revoked, .notFound:
                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                    self.signOut()
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupAuthStateListener() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUserId = user?.uid ?? ""
        }
    }
    
    private func insertUserRecord(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let now = Date().timeIntervalSince1970
        
        let newUser = AAUser(
            id: id,
            role: "user", // Default role
            email: email,
            name: name,
            avatarURL: nil, // Set to nil initially
            joined: now,
            zodiac: zodiac
        )
        
        firestore.create(collectionPath: AAUserModelName.userFirestore, data: newUser) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@(gmail|yahoo|outlook|icloud)\.(com|net|org|edu)$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
            errorMessage = "Please enter a valid email address from Google, Yahoo, Outlook, or iCloud."
            return false
        }
        
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*?[0-9])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        guard passwordPredicate.evaluate(with: password) else {
            errorMessage = "Password must be at least 8 characters long and contain at least one letter and one number."
            return false
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords Don't Match"
            return false
        }
        
        return true
    }
    
    private func updateDisplayName(for user: User, with appleIDCredential: ASAuthorizationAppleIDCredential) {
        if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
            // User already has a display name
        } else {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = appleIDCredential.fullName?.givenName
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Unable to update the user's display name: \(error.localizedDescription)")
                } else {
                    self.displayName = Auth.auth().currentUser?.displayName ?? ""
                }
            }
        }
    }
}

extension AuthenticationManager {
    func uploadProfilePhoto() {
        guard let inputImage = inputImage else { return }
        
        guard let imageData = inputImage.jpegData(compressionQuality: 0.8) else { return }
        
        let storageRef = Storage.storage().reference().child("profile_photos/\(currentUserId).jpg")
        
        let uploadTask = storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.updateUserAvatarURL(url: downloadURL.absoluteString)
            }
        }
    }

    func updateUserAvatarURL(url: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let userRef = db.collection(AAUserModelName.userFirestore).document(userId)
        
        userRef.updateData([
            AAUserModelName.avatarURL: url,
        ]) { error in
            if let error = error {
                print("Error updating user avatar URL: \(error.localizedDescription)")
            } else {
                print("User avatar URL successfully updated")
                self.user?.avatarURL = url
            }
        }
    }
}

//extension AuthenticationManager {
//    func updateUser(firstName: String, lastName: String, phone: String) async -> Bool {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            errorMessage = "No authenticated user found"
//            return false
//        }
//        
//        let db = Firestore.firestore()
//        let userRef = db.collection(AAUserModelName.userFirestore).document(userId)
//        
//        do {
//            try await userRef.updateData([
//                AAUserModelName.phone: phone,
//            ])
//            
//            if var updatedUser = self.user {
//                updatedUser.name = name
//                self.user = updatedUser
//            }
//            
//            return true
//        } catch {
//            print("Error updating user: \(error.localizedDescription)")
//            errorMessage = error.localizedDescription
//            return false
//        }
//    }
//}

// MARK: - Helper Functions

private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}
