//
//  TabbarController.swift
//  astroapp
//
//  Created by Krish Mittal on 08/08/24.
//

import UIKit

class TabbarController: UITabBarController {

    var upperLineView: UIView!
    
    let spacing: CGFloat = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            self.addTabbarIndicatorView(index: 0, isFirstTime: true)
        }
    }
    
    func addTabbarIndicatorView(index: Int, isFirstTime: Bool = false) {
        guard let tabView = tabBar.items?[index].value(forKey: "view") as? UIView else {
            return
        }
        
        let newFrame = CGRect(x: tabView.frame.minX + spacing, y: tabView.frame.minY + 0.1, width: tabView.frame.size.width - spacing * 2, height: 4)
        
        if isFirstTime {
            upperLineView = UIView(frame: newFrame)
            upperLineView.backgroundColor = UIColor.white
            tabBar.addSubview(upperLineView)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
                self.upperLineView.frame = newFrame
            }, completion: nil)
        }
    }
}

extension TabbarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        addTabbarIndicatorView(index: self.selectedIndex)
    }
}

