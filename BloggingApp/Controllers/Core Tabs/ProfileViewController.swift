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
        
        let sheet = UIAlertController(title: "Log out", message: "Are you sure you'd like to log out?", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "name")
                        let signInVc = LoginViewController()
                        signInVc.navigationItem.largeTitleDisplayMode = .always
                        let navVc = UINavigationController(rootViewController: signInVc)
                        navVc.navigationBar.prefersLargeTitles = true
                        navVc.modalPresentationStyle = .fullScreen
                        self?.present(navVc, animated: true, completion: nil)
                    }
                }
            }
        }))
        present(sheet, animated: true, completion: nil)
    }
    
}
