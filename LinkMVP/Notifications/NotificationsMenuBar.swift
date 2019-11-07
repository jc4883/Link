//
//  NotificationsMenuBar.swift
//  LinkMVP
//
//  Created by Jung Yeon Choi on 8/2/19.
//  Copyright © 2019 Peter Choi. All rights reserved.
//

import UIKit



class NotificationsMenuBar : UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {


    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellId = "cellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(NotificationsMenuBarCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(collectionView)
        addConstraintWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintWithFormat(format: "V:|[v0]|", views: collectionView)
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NotificationsMenuBarCell
        if indexPath.item == 0{
            cell.label.text = "Sent"
        } else {
            cell.label.text = "Received"
        }
        return cell
    }
    
    //size of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: frame.width/2, height: frame.height)
    }
    
    //spacing between each cell 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NotificationsMenuBarCell: BaseCell {

    
//    override var isHighlighted: Bool {
//        didSet{
//            imageView.tintColor =  isHighlighted ? .white : .black
//        }
//    }
//
    var label : UILabel = {
        let tempLabel = UILabel()
        //label.textColor = UIColor.rbg(red: 51, green: 255, blue: 153)
        tempLabel.textColor = .black
        tempLabel.backgroundColor = UIColor(red: 130/255, green: 130/255, blue: 230/255, alpha: 1)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempLabel.font = UIFont.boldSystemFont(ofSize: 14)
        return tempLabel
    }()
    
    override func setupViews() {
        self.backgroundColor = .white
        
        self.addSubview(label)
        
        label.anchor(topAnchor: self.topAnchor, bottomAnchor: self.bottomAnchor, leftAnchor: self.leftAnchor, rightAnchor: self.rightAnchor, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 0)

    }
}
