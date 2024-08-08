//
//  BaseViewController.swift
//  astroapp
//
//  Created by Krish Mittal on 08/08/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    func transitionToHome() {
        let tabbarViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabbarViewController) as? TabbarController
        view.window?.rootViewController = tabbarViewController
        view.window?.makeKeyAndVisible()
    }
    
    func transitionToLogin() {
        let loginViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? AuthenticationViewController
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
    }
}
