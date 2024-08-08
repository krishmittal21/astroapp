//
//  FirestoreDatabaseManager.swift
//  
//
//  Created by Krish Mittal on 02/08/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirestoreDatabaseManager {
    static let shared = FirestoreDatabaseManager()
    
    private let db: Firestore
    
    private init() {
        db = Firestore.firestore()
    }
    
    // MARK: - Generic CRUD Operations
    
    func create<T: Codable>(collectionPath: String, data: T, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            let dictionary = try JSONSerialization.jsonObject(with: encodedData, options: .allowFragments) as? [String: Any] ?? [:]
            
            var ref: DocumentReference? = nil
            ref = db.collection(collectionPath).addDocument(data: dictionary) { error in
                if let error = error {
                    completion(.failure(error))
                } else if let documentId = ref?.documentID {
                    completion(.success(documentId))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func read<T: Codable>(collectionPath: String, documentId: String, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        db.collection(collectionPath).document(documentId).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = document?.data() else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document not found"])))
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func update<T: Codable>(collectionPath: String, documentId: String, data: T, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let encodedData = try JSONEncoder().encode(data)
            let dictionary = try JSONSerialization.jsonObject(with: encodedData, options: .allowFragments) as? [String: Any] ?? [:]
            
            db.collection(collectionPath).document(documentId).updateData(dictionary) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func delete(collectionPath: String, documentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection(collectionPath).document(documentId).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Query Operations
    
    func query<T: Codable>(collectionPath: String, field: String, isEqualTo value: Any, as type: T.Type, completion: @escaping (Result<[T], Error>) -> Void) {
        db.collection(collectionPath).whereField(field, isEqualTo: value).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
            
            do {
                let decodedObjects: [T] = try documents.compactMap { document in
                    let jsonData = try JSONSerialization.data(withJSONObject: document.data(), options: [])
                    return try JSONDecoder().decode(T.self, from: jsonData)
                }
                completion(.success(decodedObjects))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Listener Operations
    
    func addListener<T: Codable>(collectionPath: String, documentId: String, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void) -> ListenerRegistration {
        return db.collection(collectionPath).document(documentId).addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = documentSnapshot?.data() else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document not found"])))
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let decodedObject = try JSONDecoder().decode(T.self, from: jsonData)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
