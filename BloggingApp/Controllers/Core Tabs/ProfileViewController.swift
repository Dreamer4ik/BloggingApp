//
//  ProfileViewController.swift
//  BloggingApp
//
//  Created by Ivan Potapenko on 22.12.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapLogOut))
        
    }
    
    
    @objc private func didTapLogOut() {
        
    }
    
}
