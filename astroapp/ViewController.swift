//
//  ViewController.swift
//  astroapp
//
//  Created by Krish Mittal on 08/08/24.
//

import UIKit
import GoogleSignIn
import AuthenticationServices

class ViewController: BaseViewController {

    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(googleSignInButton)
        Utilities.styleFilledButton(appleSignInButton)
        Utilities.styleFilledButton(signInButton)
        Utilities.styleHollowButton(signupButton)
    }

    @IBAction func googleButtonTapped(_ sender: Any) {
        AuthenticationManager.shared.signInWithGoogle(presentingViewController: self) { success, error in
            if success {
                print("Google Sign-In successful!")
                self.transitionToHome()
            } else if let error = error {
                print("Google Sign-In failed: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func appleButtonTapped(_ sender: Any) {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        AuthenticationManager.shared.handleSignInWithAppleRequest(request)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        AuthenticationManager.shared.handleSignInWithAppleCompletion(.success(authorization)) { success, error in
            if success {
                print("Apple Sign-In successful!")
                self.transitionToHome()
            } else if let error = error {
                print("Apple Sign-In failed: \(error.localizedDescription)")
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign-In error: \(error.localizedDescription)")
        // Handle error
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}


