//
//  MapController.swift
//  LinkMVP
//
//  Created by Jung Yeon Choi on 7/20/19.
//  Copyright © 2019 Peter Choi. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class MapController: UIViewController {
    //self.view = mapView
    
    let mapView : GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 40.808031, longitude: -73.963753, zoom: 12)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        return mapView
    }()
    
    let dropLinkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Drop a Link", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.backgroundColor = UIColor.rbg(red: 204, green: 0, blue: 104)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Map"
        
        setupMap()
        setupMarkers()
        setupDropLinkButton()
    }
    

    fileprivate func setupMap(){
        self.view = mapView
        let crossHair = UIImageView(image: UIImage(named: "plus_unselected"))
        view.addSubview(crossHair)
        crossHair.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        crossHair.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        crossHair.anchor(topAnchor: nil, bottomAnchor: nil, leftAnchor: nil, rightAnchor: nil, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 30, height: 30)
    }
    
    fileprivate func setupMarkers() {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        Database.database().reference().child("users").child(uid).child("links").observe(.value) { (snapshot) in
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let value = rest.value as? [String : Any] else {return}
                guard let latitude = value["latitude"] as? CLLocationDegrees else{return}
                guard let longitude = value["longitude"] as? CLLocationDegrees else{return}
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker.title = "Marker"
                marker.snippet = "Snippet"
                marker.map = self.mapView
            }
        }
    }
    
    fileprivate func setupDropLinkButton(){
        view.addSubview(dropLinkButton)
        dropLinkButton.anchor(topAnchor: nil, bottomAnchor: view.bottomAnchor, leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor, topPadding: 0, bottomPadding: -120, leftPadding: 40, rightPadding: 40, width: 0, height: 70)
        dropLinkButton.addTarget(self, action: #selector(handleDropLinkButton), for: .touchUpInside)
    }
    
    @objc func handleDropLinkButton(){
        let linkLocation = mapView.camera.target
        print(linkLocation)

        DispatchQueue.main.async {
            let linkDropController = LinkDropController()
            linkDropController.coordinate = linkLocation
            //linkDropController.delegate = self
            
            //we now have navigationController for our loginController
            let navigationController = UINavigationController(rootViewController: linkDropController)
            //you must present the navigation controller!
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}



