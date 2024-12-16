//
//  PhotoDetailsVC.swift
//  FlickerApp
//
//  Created by Anusha Raju on 12/15/24.
//


import UIKit

class PhotoDetailsVC: UIViewController {

    var details : [String: String] = [:]
    
    var imgTitle: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 22) // Use bold font
        label.numberOfLines = 0
        label.textAlignment = .center // Center align text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var img: UIImageView = {
        var img = UIImageView()
        img.contentMode = .scaleToFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 12
        img.layer.borderWidth = 2 // Set border width
        img.layer.borderColor = UIColor.gray.cgColor // Border color
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    var author: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var publishedDate: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        layoutSubviews()
        setupConstraints()
        setupDetails()
    }
    
    func layoutSubviews(){
        view.addSubview(imgTitle)
        view.addSubview(img)
        view.addSubview(author)
        view.addSubview(publishedDate)
        
        

    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            
            imgTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imgTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            imgTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imgTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imgTitle.bottomAnchor.constraint(equalTo: img.topAnchor, constant: -20),
            
            img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            img.widthAnchor.constraint(equalToConstant: 300), // Example width
            img.heightAnchor.constraint(equalToConstant: 200), // Example height
            
            author.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 20),
            author.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            author.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            publishedDate.topAnchor.constraint(equalTo: author.bottomAnchor, constant: 20),
            publishedDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            publishedDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
    }
    
    func setupDetails(){
        
        imgTitle.text = details["title"]
        author.text = "Author: \(details["author"] ?? "N/A")"
        publishedDate.text = "Published Date: \(details["publishedDate"] ?? "N/A")"
        let imageURL = details["imgURL"]
        ImageDownloader.shared.getImage(url:imageURL ) { [] image in
            DispatchQueue.main.async {
                self.img.image = image
            }
        }
    }
}
