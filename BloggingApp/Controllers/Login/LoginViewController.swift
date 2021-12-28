//
//  LoginViewController.swift
//  BloggingApp
//
//  Created by Ivan Potapenko on 22.12.2021.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .systemBackground
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if !IAPManager.shared.isPremium() {
                let vc = PayWallViewController()
                let navVc = UINavigationController(rootViewController: vc)
                self.present(navVc, animated: true, completion: nil)
            }
        }
    }
    


}
