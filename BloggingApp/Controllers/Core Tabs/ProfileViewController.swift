//
//  ProfileViewController.swift
//  BloggingApp
//
//  Created by Ivan Potapenko on 22.12.2021.
//

import UIKit
import PhotosUI

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Profile Photo
    
    //Full name
    
    // Email
    
    // List of posts
    
    private var user: User?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        return tableView
    }()
    
    let currentEmail: String
    
    init(currentEmail:String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpLogOutButton()
        addSubView()
        setUpTable()
        fetchProfileData()
        fetchPosts()
        title = "Profile"
    }
    private func addSubView() {
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpTable() {
        tableView.delegate = self
        tableView.dataSource = self
        setUpTableHeader()
    }
    
    private func setUpTableHeader(profilePhotoRef: String? = nil, name: String? = nil){
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        headerView.backgroundColor = .systemBlue
        headerView.isUserInteractionEnabled = true
        headerView.clipsToBounds = true
        tableView.tableHeaderView = headerView
        // Profile picture
        let profilePhoto = UIImageView(image: UIImage(systemName: "person.circle"))
        profilePhoto.tintColor = .white
        profilePhoto.contentMode = .scaleAspectFill
        profilePhoto.frame = CGRect(x: (view.width-(view.width/4))/2,
                                    y: (headerView.height-(view.width/4))/2.5,
                                    width: view.width/4,
                                    height: view.width/4)
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.width/2
        profilePhoto.isUserInteractionEnabled = true
        headerView.addSubview(profilePhoto)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
        profilePhoto.addGestureRecognizer(tap)
        
        // Email
        let emailLabel = UILabel(frame: CGRect(x: 20, y: profilePhoto.bottom+10, width: view.width-40, height: 100))
        headerView.addSubview(emailLabel)
        emailLabel.text = currentEmail
        emailLabel.textAlignment = .center
        emailLabel.textColor = .white
        emailLabel.font = .systemFont(ofSize: 25, weight: .bold)
        // Name
        if let name = name {
            title = name
        }
        
        if let ref = profilePhotoRef {
            //FetchImage
            print("Found photo ref: \(ref)")
            StorageManager.shared.downloadUrlForProfilePicture(path: ref) { url in
                guard let url = url else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        profilePhoto.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
        
    }
    
    @objc private func didTapProfilePhoto() {
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
              myEmail == currentEmail else {
                  return
              }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
        
        
        
    }
    
    private func fetchProfileData() {
        DatabaseManager.shared.getUser(email: currentEmail) {[weak self] user in
            guard let user = user else {
                return
            }
            self?.user = user
            DispatchQueue.main.async {
                self?.setUpTableHeader(
                    profilePhotoRef: user.profilePictureRef,
                    name: user.name
                )
            }
        }
    }
    
    private func setUpLogOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapLogOut))
    }
    
    ///Log out
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
    private var posts: [BlogPost] = []
    
    private func fetchPosts() {
        print("Fetching posts...")
        DatabaseManager.shared.getPosts(for: currentEmail) { [weak self] posts in
            self?.posts = posts
            print("Found: \(posts.count)")
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var isOwnedByCurrentUser = false
        if let email = UserDefaults.standard.string(forKey: "email"){
            isOwnedByCurrentUser = email == currentEmail
        }
        if !isOwnedByCurrentUser {
            if IAPManager.shared.canViewPost {
                let vc = ViewPostViewController(post: posts[indexPath.row], isOwnedByCurrentUser: isOwnedByCurrentUser)
                vc.navigationItem.largeTitleDisplayMode = .never
                vc.title = "Post"
                navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let vc = PayWallViewController()
                present(vc, animated: true)
            }
        }
        else {
            // Our post
            let vc = ViewPostViewController(post: posts[indexPath.row], isOwnedByCurrentUser: isOwnedByCurrentUser)
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = "Post"
            navigationController?.pushViewController(vc, animated: true)
        }
        
      
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        StorageManager.shared.uploadUserProfilePicture(email: currentEmail, image: image) {[weak self] success in
            guard let strongSelf = self else {
                return
            }
            if success {
                //Updata database
                DatabaseManager.shared.updateProfilePhoto(email: strongSelf.currentEmail) { updated in
                    guard updated else {
                        return
                    }
                    DispatchQueue.main.async {
                        strongSelf.fetchProfileData()
                    }
                }
            }
        }
    }
}
