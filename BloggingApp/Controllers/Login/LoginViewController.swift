//
//  LoginViewController.swift
//  BloggingApp
//
//  Created by Ivan Potapenko on 22.12.2021.
//

import UIKit

class LoginViewController: UIViewController {
    //Header View
    private let headerView = LoginHeaderView()
    //Email Field
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        // Настройка расстояния внутри филда от границ
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Email adress"
        //убираем т9 и подчеркивание коррекции красным
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    //Password Field
    private let passwordField: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.placeholder = "Password"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    //Log in button
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    //Create Account
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .systemBackground
        addSubview()
        
        loginButton.addTarget(self, action: #selector(didTapLogIn), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            if !IAPManager.shared.isPremium() {
//                let vc = PayWallViewController()
//                let navVc = UINavigationController(rootViewController: vc)
//                self.present(navVc, animated: true, completion: nil)
//            }
//        }
    }
    
    private func addSubview() {
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(createAccountButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top , width: view.width, height: view.height/5)
        
        emailField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width-40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 10, width: view.width-40, height: 50)
        loginButton.frame = CGRect(x: 20, y: passwordField.bottom + 30, width: view.width-40, height: 50)
        createAccountButton.frame = CGRect(x: 20, y: loginButton.bottom + 10, width: view.width-40, height: 50)
    }
    
    @objc func didTapLogIn() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
                  return
              }
        
        AuthManager.shared.signIn(email: email, password: password) { [weak self] success in
            guard success else {
                return
            }
            DispatchQueue.main.async {
                UserDefaults.standard.set(email, forKey: "email")
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @objc func didTapCreateAccount() {
        let vc = RegisterViewController()
        
        vc.title = "Create Account"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }


}
