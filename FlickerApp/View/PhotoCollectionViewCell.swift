//
//  PhotoCollectionViewCell.swift
//  FlickerApp
//
//  Created by Anusha Raju on 12/14/24.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    let photoImg: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill // Adjust as per your needs
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImg)
        setupCellConstraints()
        customizeCellBorder()
    }
    
    func setupCellConstraints(){
        NSLayoutConstraint.activate([
            photoImg.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func customizeCellBorder(){
        contentView.layer.cornerRadius = 12 // Adjust radius as needed
        contentView.layer.masksToBounds = true // Clips the content to the rounded corners
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1.0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
