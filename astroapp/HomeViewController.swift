//
//  HomeViewController.swift
//  astroapp
//
//  Created by Krish Mittal on 08/08/24.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        AuthenticationManager.shared.signOut()
        self.transitionToLogin()
    }
}
