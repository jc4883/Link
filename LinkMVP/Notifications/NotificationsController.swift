//
//  NotificationsController.swift
//  LinkMVP
//
//  Created by Jung Yeon Choi on 7/29/19.
//  Copyright © 2019 Peter Choi. All rights reserved.
//

import UIKit
import Firebase

class NotificationsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let notificationsMenuBar : NotificationsMenuBar = {
        let mb = NotificationsMenuBar()
        return mb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Links"
        navigationController?.navigationBar.isTranslucent = false
        //let titleLabel = UILabel(frame: CGRect(x: view.frame.width/2, y: 0, width: view.frame.width - 32, height: view.frame.height))
//        titleLabel.text = "Links"
//        titleLabel.textColor = UIColor.rbg(red: 51, green: 255, blue: 153)
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
//        navigationItem.titleView = titleLabel
 
        //navigationController?.navigationBar.barStyle = .blackTranslucent
        
        collectionView?.backgroundColor = .white
        collectionView.register(NotificationCell.self, forCellWithReuseIdentifier: "cellId")
        //change inset as not to be covered by menu bar, also for scroll
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)

        setupNotificationsMenuBar()
        
    //    fetchLinks()
        
        fetchOrderedLinks()
    }
    
    var links = [Link]()
    
    fileprivate func fetchOrderedLinks() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("links").child(uid)
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String : Any] else {return}
            
            let link = Link(dictionary: dictionary)
            self.links.append(link)
            self.collectionView.reloadData()
            
            
        }) { (err) in
            print("failed to fetch ordered links: ", err)
        }
    }
    
    fileprivate func setupNotificationsMenuBar() {
        view.addSubview(notificationsMenuBar)
        view.addConstraintWithFormat(format: "H:|[v0]|", views: notificationsMenuBar)
        view.addConstraintWithFormat(format: "V:|[v0(30)]|", views: notificationsMenuBar)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return links.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! NotificationCell
        //each cell has a link property that it represents
        cell.link = links[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}


extension UIView {
    
    func addConstraintWithFormat(format : String, views : UIView...){
        
        var viewsDictionary = [String : UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}




