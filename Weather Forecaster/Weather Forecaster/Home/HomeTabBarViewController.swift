//
//  HomeTabBarViewController.swift
//  Weather Forecaster
//
//  Created by Kevin E. Rafferty II on 2/4/22.
//

import UIKit

class HomeTabBarViewController: UITabBarController {
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - UITabBarController Delegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }
}
