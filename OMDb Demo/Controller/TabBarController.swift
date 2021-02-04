//
//  TabBarController.swift
//  OMDb Demo
//
//  Created by Denis Aleksandrov on 1/30/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.selectedIndex = 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(#function + ": Selected \(viewController.title!)")
    }
    
}
