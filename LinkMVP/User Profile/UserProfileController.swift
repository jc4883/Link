//
//  UserProfileController.swift
//  LinkMVP
//
//  Created by Jung Yeon Choi on 7/20/19.
//  Copyright © 2019 Peter Choi. All rights reserved.
//

import UIKit
import Firebase

//UserProfileController is profile page
class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        //every instance of UIViewController will have its view (in this case collectionView)
        collectionView.backgroundColor = .white
        //property of UIViewController, appears when VC is visible
        fetchUser() //create User property first before registering
        //UICollectionView.self is an Anyclass.
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerID")
        //You must always register collectionView!!
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        setupLogoutButton()
    }
    
    fileprivate func setupLogoutButton(){
        guard let gear = UIImage(named: "gear") else{return}
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: gear.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navigationController = UINavigationController(rootViewController: loginController)
                self.present(navigationController, animated: true, completion: nil)
            } catch let signOutErr {
                print("sign out failed: ", signOutErr)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .purple
        return cell
    }
    //vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //picture width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2)/3
        return CGSize(width: width, height: width)
    }
    
    
    
    //create header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath) as! UserProfileHeader
        //header has user property bc we've registered as type userProfileHeader
        header.user = self.user
        return header
    }
    
    //resize with delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    var user : User?
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
    Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value ?? "")
            guard let dictionary = snapshot.value as? [String: Any] else{return}
            self.user = User(dictionary: dictionary)
            self.navigationItem.title = self.user?.username
            self.collectionView?.reloadData()
        }) { (error) in
            print("failed to get profile username: ", error)
        }
    }
}

struct User {
    let username : String
    let profileImageURL : String
    init(dictionary : [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
}

