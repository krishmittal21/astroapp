//
//  LoveViewController.swift
//  astroapp
//
//  Created by Krish Mittal on 09/08/24.
//

import UIKit

class LoveViewController: BaseViewController {

    @IBOutlet weak var signOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func signOutButtonTapped(_ sender: Any) {
        AuthenticationManager.shared.signOut()
        self.transitionToLogin()
    }

}
