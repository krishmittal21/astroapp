//
//  LoginViewController.swift
//  astroapp
//
//  Created by Krish Mittal on 08/08/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            errorLabel.text = "Please enter your email and password."
            return
        }
        
        AuthenticationManager.shared.email = email
        AuthenticationManager.shared.password = password
        
        AuthenticationManager.shared.signInWithEmailPassword { [weak self] success, error in
            guard let self = self else { return }
            if success {
                print("Log-In successful!")
            } else if let error = error {
                self.errorLabel.text = "Log-In failed: \(error.localizedDescription)"
            } else {
                self.errorLabel.text = AuthenticationManager.shared.errorMessage
            }
        }
    }
    
}
