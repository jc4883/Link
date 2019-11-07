//
//  NotificationCell.swift
//  LinkMVP
//
//  Created by Jung Yeon Choi on 8/2/19.
//  Copyright © 2019 Peter Choi. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

class NotificationCell: BaseCell {
    
    //gets called on cellForItemAt NotificationsController
    var link : Link? {
        didSet{
            //get profile image for each cell
            guard let linkCreator = link?.linkCreator else {return}
            let ref =  Database.database().reference().child("users").child(linkCreator)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String : Any] else {return}
                let profileImageURL = dictionary["profileImageURL"] as? String ?? ""
                
                self.userProfileImageView.loadImage(urlString: profileImageURL)

            }) { (err) in
                print("Failed to fetch links", err)
            }
            
            //set other properties for each cell
            setupCellProperties()
            
        }
    }
    
    fileprivate func setupCellProperties() {
        guard let activity = link?.activity else {return}
        guard let time = link?.time else {return}
        guard let invitees = link?.invitees else {return}
        guard let latitude = link?.latitude else {return}
        guard let longitude = link?.longitude else {return}
        titleLabel.text = "\(activity) - \(time)"
        subtitleTextView.text = invitees
        
        let markerCenterCamera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: 12)
        mapView.camera = markerCenterCamera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = activity
        marker.snippet = time
        marker.map = mapView
    }
    
    let mapView : GMSMapView = {
        //default camera position
        let camera = GMSCameraPosition.camera(withLatitude: 40.808031, longitude: -73.963753, zoom: 12)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        return mapView
    }()
    
    let separatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230/255, green:  230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    let userProfileImageView : CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        //half of width/height
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //UITextView better suited for editing
    let subtitleTextView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = .lightGray
        
        return textView
    }()
    
    override func setupViews(){
        addSubview(mapView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        
        
        addConstraintWithFormat(format: "H:|-16-[v0]-16-|", views: mapView)
        addConstraintWithFormat(format: "H:|-16-[v0(44)]|", views: userProfileImageView )
        addConstraintWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-16-[v2(1)]|", views: mapView, userProfileImageView, separatorView)
        addConstraintWithFormat(format: "H:|[v0]|", views: separatorView)
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: 1, constant: 8))
        //left constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        //right constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: mapView, attribute: .right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
        
        //top constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        //left constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant:8))
        //right constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1, constant: 0))
        //height constraint
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20))
        
        
        //addConstraintWithFormat(format: "V:[v0(20)]", views: titleLabel)
        //addConstraintWithFormat(format: "H:|[v0]|", views: titleLabel)
        
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

