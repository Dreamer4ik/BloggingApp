//
//  TabBarViewController.swift
//  BloggingApp
//
//  Created by Ivan Potapenko on 22.12.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpControllers()
    }
    
    private func setUpControllers() {
        let home = HomeViewController()
        home.title = "Home"
        let profile = ProfileViewController()
        profile.title = "Profile"
        
        home.navigationItem.largeTitleDisplayMode = .always
        profile.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: profile)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
    
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
       
        if #available(iOS 15.0, *) {
                          let appearance = UITabBarAppearance()
                          appearance.backgroundColor = .secondarySystemBackground
                          tabBar.tintColor = .systemBlue
                          tabBar.standardAppearance = appearance
                          tabBar.scrollEdgeAppearance = tabBar.standardAppearance

        }else {
            tabBar.barTintColor = .secondarySystemBackground
            tabBar.tintColor = .systemBlue
        }
        
        
        setViewControllers([nav1,nav2], animated: true)
    }
    
    
}
