//
//  ViewController.swift
//  BloggingApp
//
//  Created by Ivan Potapenko on 22.12.2021.
//

import UIKit

class HomeViewController: UIViewController {
    //Create post button
    private let composeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        composeButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        addSubview()
      
    }

    private func addSubview() {
        view.addSubview(composeButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        composeButton.frame = CGRect(x: view.frame.width - 88,
                                     y: view.frame.height - 88 - view.safeAreaInsets.bottom,
                                     width: 60,
                                     height: 60)
    }
    
    @objc private func didTapCreate() {
        let vc = CreateNewPostViewController()
        vc.title = "Create Post"
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }

}

