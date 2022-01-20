//
//  ViewPostViewController.swift
//  BloggingApp
//
//  Created by Ivan Potapenko on 22.12.2021.
//

import UIKit

class ViewPostViewController: UITabBarController, UITableViewDataSource, UITableViewDelegate {
    private let post: BlogPost
    
    init(post: BlogPost) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        //title,header, body
        // Poster
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        table.register(PostHeaderTableViewCell.self,
                       forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // Table
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // title, image, text
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        //0: title
        
        //1: image
        
        //2: text
        switch index {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if #available(iOS 14.0, *) {
                var config = cell.defaultContentConfiguration()
                config.text = post.title
                config.textProperties.numberOfLines = 0
                config.textProperties.font = .systemFont(ofSize: 25, weight: .bold)
                
                cell.contentConfiguration = config
                cell.selectionStyle = .none
            } else {
                cell.textLabel?.text = post.title
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.font = .systemFont(ofSize: 25, weight: .bold)
                cell.selectionStyle = .none
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier, for: indexPath) as? PostHeaderTableViewCell else {
                fatalError()
            }
            cell.selectionStyle = .none
            cell.configure(with: .init(imageUrl: post.headerImageUrl))
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            if #available(iOS 14.0, *) {
                var config = cell.defaultContentConfiguration()
                config.text = post.text
                cell.contentConfiguration = config
                cell.selectionStyle = .none
            } else {
                cell.textLabel?.text = post.text
                cell.textLabel?.numberOfLines = 0
                cell.selectionStyle = .none
                
            }
            
            return cell
        default:
            fatalError()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        switch index {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 250
        case 2:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
}
