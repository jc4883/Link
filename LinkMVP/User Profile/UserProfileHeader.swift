//
//  UserProfileHeader.swift
//  LinkMVP
//
//  Created by Jung Yeon Choi on 7/20/19.
//  Copyright © 2019 Peter Choi. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    var user : User? {
        didSet { //runs when fetchUser is called
            guard let urlString = user?.profileImageURL else {return}
            profileImageView.loadImage(urlString: urlString)
            guard let username = user?.username else {return}
            usernameLabel.text = username
        }
    }
    
    let profileImageView : CustomImageView = {
        let iv = CustomImageView()
        return iv
    }()
    
    let gridbutton : UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "grid")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "list")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "ribbon")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel : UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postsLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n",
                                                       attributes: [NSAttributedString.Key.font:
                                                        UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "posts",
                                                 attributes: [NSAttributedString.Key.foregroundColor:
                                                    UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followersLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n",
                                                       attributes: [NSAttributedString.Key.font:
                                                        UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers",
                                                 attributes: [NSAttributedString.Key.foregroundColor:
                                                    UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel : UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n",
                                                       attributes: [NSAttributedString.Key.font:
                                                        UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following",
                                                 attributes: [NSAttributedString.Key.foregroundColor:
                                                    UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let editProfileButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14 )
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addSubview puts new subview on top
        addSubview(profileImageView)
        profileImageView.anchor(topAnchor: self.topAnchor, bottomAnchor: nil, leftAnchor: self.leftAnchor, rightAnchor: nil, topPadding: 12, bottomPadding: 0, leftPadding: 12, rightPadding: 0, width: 80, height: 80 )
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.clipsToBounds = true
        setupBottomToolbar()
        addSubview(usernameLabel)
        usernameLabel.anchor(topAnchor: profileImageView.bottomAnchor, bottomAnchor: gridbutton.topAnchor, leftAnchor: leftAnchor, rightAnchor: rightAnchor, topPadding: 4, bottomPadding: 0, leftPadding: 12, rightPadding: 12, width: 0, height: 0)
        setupUserStats()
        addSubview(editProfileButton)
        editProfileButton.anchor(topAnchor: postsLabel.bottomAnchor, bottomAnchor: nil, leftAnchor: postsLabel.leftAnchor, rightAnchor: followingLabel.rightAnchor, topPadding: 2, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 34)
    }
    
    fileprivate func setupUserStats(){
        let stack = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.anchor(topAnchor: topAnchor, bottomAnchor: nil, leftAnchor: profileImageView.rightAnchor, rightAnchor: rightAnchor, topPadding: 12, bottomPadding: 0, leftPadding: 12, rightPadding: 12, width: 0, height: 50)
    }
    
    fileprivate func setupBottomToolbar() {
        let topDivider = UIView()
        topDivider.backgroundColor = UIColor.lightGray
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = UIColor.lightGray
        
        let stack = UIStackView(arrangedSubviews: [gridbutton, listButton, bookmarkButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        addSubview(stack)
        addSubview(topDivider)
        addSubview(bottomDivider)
        stack.anchor(topAnchor: nil, bottomAnchor: self.bottomAnchor, leftAnchor: leftAnchor, rightAnchor: rightAnchor, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 50)
        topDivider.anchor(topAnchor: stack.topAnchor, bottomAnchor: nil, leftAnchor: leftAnchor, rightAnchor: rightAnchor, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 0.5)
        bottomDivider.anchor(topAnchor: stack.bottomAnchor, bottomAnchor: nil, leftAnchor: leftAnchor, rightAnchor: rightAnchor, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 0.5)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

