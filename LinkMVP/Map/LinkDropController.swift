//
//  linkDropController.swift
//  LinkMVP
//
//  Created by Jung Yeon Choi on 7/22/19.
//  Copyright © 2019 Peter Choi. All rights reserved.
//

//TODO:
//- find out how to pass data from MapController to LinkDropController
//- store information of link inside firebase
//- add marker to map in LinkDropController
//- date/time picker intead of Text
//- send text message to friend when dismissed
//- dismiss keyboard when map is pressed

import UIKit
import GoogleMaps
import Firebase

class LinkDropController: UIViewController {
    
    //data variables
    
    //weak var delegate: MapController!
    var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "xButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let invitee : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Who are you inviting?"
        tf.borderStyle = .roundedRect
        tf.backgroundColor =  UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let time : UITextField = {
        let tf = UITextField()
        tf.placeholder = "When?"
        tf.borderStyle = .roundedRect
        tf.backgroundColor =  UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        let dp = UIDatePicker()
        dp.datePickerMode = .dateAndTime
        dp.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        tf.inputView = dp
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        time.text = "Tomorrow at 6:30 PM"
    }
    
    let activity : UITextField = {
        let tf = UITextField()
        tf.placeholder = "What are you guys doing?"
        tf.borderStyle = .roundedRect
        tf.backgroundColor =  UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()

    let confirmLinkDropButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = UIColor.rbg(red: 150, green: 240, blue: 150)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleConfirmLinkDropButton), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleConfirmLinkDropButton() {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        
        guard let inviteeText = invitee.text else {return}
        guard let timeText = time.text else {return}
        guard let activityText = activity.text else {return}
        let linkCreator = uid

        confirmLinkDropButton.isEnabled = false
        
        let userLinkRef = Database.database().reference().child("links").child(uid)

        let ref = userLinkRef.childByAutoId()
        
        let values = ["linkCreator" : linkCreator, "invitees" : inviteeText, "time" : timeText, "activity" : activityText,
                      "longitude" : coordinate.longitude, "latitude" : coordinate.latitude, "creationDate" : Date().timeIntervalSince1970] as [String : Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err{
                print("failed to save link to DB", err)
                self.confirmLinkDropButton.isEnabled = true
                return
            }
            print("successfully saved link to DB")
        }

        dismiss(animated: true, completion: nil)
    }
    
    
    @objc fileprivate func handleTextInputChange() {
        let isFormValid = invitee.text?.count ?? 0 > 0 //default is false
            && time.text?.count ?? 0 > 0
            && activity.text?.count ?? 0 > 0
        if isFormValid {
            confirmLinkDropButton.backgroundColor = UIColor.rbg(red: 30, green: 200, blue: 30)
            confirmLinkDropButton.isEnabled = true
        } else {
            confirmLinkDropButton.backgroundColor = UIColor.rbg(red: 150, green: 240, blue: 150)
            confirmLinkDropButton.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        
        setupInputAndMap()
        
        setupCancelButton()
        
    }
    
    fileprivate func setupMapPosition(stackView : UIStackView){
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 12)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        let marker = GMSMarker()
        marker.position = coordinate
        marker.title = "Event"
        marker.map = mapView
        view.addSubview(mapView)
        mapView.anchor(topAnchor: view.topAnchor, bottomAnchor: stackView.topAnchor, leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor, topPadding: 0, bottomPadding: -20, leftPadding: 0, rightPadding: 0, width: 0, height: 0)
    }
    

    
    fileprivate func setupInputAndMap() {

        view.addSubview(confirmLinkDropButton)
        
        confirmLinkDropButton.anchor(topAnchor: nil, bottomAnchor: view.bottomAnchor, leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor, topPadding: 100, bottomPadding: -20, leftPadding: 40, rightPadding: 40, width: 0, height: 70)
        
        let stackView = UIStackView(arrangedSubviews: [invitee, time, activity])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        
        stackView.anchor(topAnchor: nil, bottomAnchor: confirmLinkDropButton.topAnchor, leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor, topPadding: 0, bottomPadding: -20, leftPadding: 40, rightPadding: 40, width: 0, height: 240)
        
        setupMapPosition(stackView: stackView)

    }
    
    fileprivate func setupCancelButton(){
        view.addSubview(cancelButton)
        cancelButton.anchor(topAnchor: view.topAnchor, bottomAnchor: nil, leftAnchor: nil, rightAnchor: view.rightAnchor, topPadding: 20, bottomPadding: 0, leftPadding: 0, rightPadding: 10, width: 0, height: 0)
        cancelButton.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
    }
    
    @objc fileprivate func handleCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
}
