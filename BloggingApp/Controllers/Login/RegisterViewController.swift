//
//  RegisterViewController.swift
//  BloggingApp
//
//  Created by Ivan Potapenko on 22.12.2021.
//

import UIKit

class RegisterViewController: UIViewController {

    //Header View
    private let headerView = LoginHeaderView()
    //Name Field
    private let nameField: UITextField = {
        let field = UITextField()
        // Настройка расстояния внутри филда от границ
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Full Name"
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    //Email Field
    private let emailField: UITextField = {
        let field = UITextField()
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        // Настройка расстояния внутри филда от границ
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Email adress"
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
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.placeholder = "Password"
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    //Log in button
    private let registerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Create account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        addSubview()
        
        registerButton.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)

    }
    
    private func addSubview() {
        view.addSubview(headerView)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top , width: view.width, height: view.height/5)
        
        nameField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width-40, height: 50)
        emailField.frame = CGRect(x: 20, y: nameField.bottom + 10, width: view.width-40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 10, width: view.width-40, height: 50)
        registerButton.frame = CGRect(x: 20, y: passwordField.bottom + 30, width: view.width-40, height: 50)
    }
    
    @objc func didTapRegister() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let name = nameField.text, !name.isEmpty else {
                  return
              }
        //Create user
        AuthManager.shared.signUp(email: email, password: password) {[weak self] success in
            if success {
                //Update database
                let newUser = User(name: name, email: email, profilePictureUrl: nil)
                DatabaseManager.shared.insert(user: newUser) { inserted in
                    guard inserted else {
                        return
                    }
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(name, forKey: "name")
                    DispatchQueue.main.async {
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true, completion: nil)
                    }
                }
            } else {
                print("Failed to create account")
            }
        }
        
        
    }
    



}
