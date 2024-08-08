//
//  RegisterViewController.swift
//  astroapp
//
//  Created by Krish Mittal on 08/08/24.
//

import UIKit

class RegisterViewController: BaseViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.text = ""
        setUpElements()
    }
    
    func setUpElements() {
        Utilities.styleTextField(nameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleTextField(confirmPasswordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {
            errorLabel.text = "Please fill in all fields."
            return
        }
        
        AuthenticationManager.shared.name = name
        AuthenticationManager.shared.email = email
        AuthenticationManager.shared.password = password
        AuthenticationManager.shared.confirmPassword = confirmPassword
        
        AuthenticationManager.shared.signUpWithEmailPassword { [weak self] success, error in
            guard let self = self else { return }
            if success {
                print("Sign-Up successful!")
                self.transitionToHome()
            } else if let error = error {
                self.errorLabel.text = "Sign-Up failed: \(error.localizedDescription)"
            } else {
                self.errorLabel.text = AuthenticationManager.shared.errorMessage
            }
        }
    }
}

