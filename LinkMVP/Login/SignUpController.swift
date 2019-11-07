//
//  SignUpController.swift
//  LinkMVP
//
//  Created by Jung Yeon Choi on 7/20/19.
//  Copyright © 2019 Peter Choi. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system) //ie) .infoDark, .contactAdd, when pressed
        //button.backgroundColor = .red
        //? because UIImage may produce nil making withRenderingMode not function
        //withRenderingMode returns UIImage, which we pass into setImage
        let image1 = UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal)//
        button.setImage(image1, for: .normal)//underscore, no need for type
        //allow adding additional constraints to modify this size or position
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }() //?
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        //UIImagePickerController must implement delegate, which need UIIPCD, UINCD protocols
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.originalImage] as? UIImage {
            //plusPhotoButton.setImage(editedImage, for: .normal)
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            print("here")
        } else if let originalImage = info[.editedImage] as? UIImage {
            //plusPhotoButton.setImage(originalImage, for: .normal)
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            print("here2")
        } else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.bounds.size.width/2
        plusPhotoButton.clipsToBounds = true
        plusPhotoButton.layer.borderWidth = 3
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor //UIColor.black is a get var, initializes a UIColor
        dismiss(animated: true, completion: nil)
        
    }
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        //backgroundColor inherit from UIView
        //white:0 is black with very low alpha value
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let usernameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.borderStyle = .roundedRect
        //backgroundColor inherit from UIView
        //white:0 is black with very low alpha value
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        //mask typing
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        //backgroundColor inherit from UIView
        //white:0 is black with very low alpha value
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        
        return tf
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        //button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        //call extension function which returns UIColor class
        button.backgroundColor = UIColor.rbg(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5 //layer is of type CALayer
        //? since label does not have to have a title
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        //target is button (self), selects objc method or object, you can specify
        //UIControl.Event.touchUpInside, but .touchUpInside is understood
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    //?
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 //default is false
            && usernameTextField.text?.count ?? 0 > 0
            && passwordTextField.text?.count ?? 0 > 0
        if isFormValid {
            signUpButton.backgroundColor = UIColor.rbg(red: 17, green: 154, blue: 237)
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor.rbg(red: 149, green: 204, blue: 244)
            signUpButton.isEnabled = false
        }
    }
    //TODO: profileImageURLAbsoluteString is force unwrapped ()
    @objc func handleSignUp() {
        //A guard statement is used to transfer program control out of a scope if one or more conditions aren’t met.
        guard let email = emailTextField.text, email.count > 0 else {return}
        guard let username = usernameTextField.text, username.count > 0 else {return}
        guard let password = passwordTextField.text, password.count > 0 else {return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
            if let error = error {
                print("sign up errno: ", error)
            }
            guard let image = self.plusPhotoButton.imageView?.image else{return}
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else {return}
            let filename = UUID().uuidString //unique string for each profile pic
            //add unique child and its profile pic to storage
            let storageRef = Storage.storage().reference().child("profile_images").child(filename)
            storageRef.putData(uploadData, metadata: nil, completion:
                //upon completion, downloadURL of pic from storage, then add user to database
                { (metadata, err) in
                    if let err = err {
                        print("failed to upload photo: ", err)
                        return
                    }
                    storageRef.downloadURL(completion: { (url, err) in
                        guard let profileImageURLAbsoluteString = url?.absoluteString else{return}
                        print("successfully retrieved profile picture URL: ", profileImageURLAbsoluteString)
                        print("uid: ", dataResult?.user.uid ?? "") //where is .uid in documentation?
                        guard let uid = dataResult?.user.uid else{return} //guard is same as if let, but you must return somewhere
                        //now guaranteed that uid isn't nil
                        let dictionaryValues = ["username": username, "profileImageURL": profileImageURLAbsoluteString]
                        let values = [uid: dictionaryValues]
                        //updateChildValues adds not overwrites on child "users"
                        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, databaseRef) in
                            if let err = err {
                                print("failed to save user info to db:", err)
                                return
                            }
                            print("succesfully saved user info to db")
                            guard let mainTabBarController =
                                UIApplication.shared.keyWindow?.rootViewController as?
                                MainTabBarController else {return}
                            mainTabBarController.setupViewControllers()
                            self.dismiss(animated: true, completion: nil)
                        })
                        
                    })
                    
                    
                    
            })
            
            
        }
    }
    
    
    /*
     Auth.auth().createUser(withEmail: "dummy@gmail.com", password: "123123", completion: {
     (user: User?, error: Error?) in
     if let error = error {
     print("Sign Up err: ", error)
     }
     print(user?.uid)
     })
     */
    let alreadyHaveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(attributedString: NSAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        attributedTitle.append(NSAttributedString(string: "Log In.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.rbg(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        
        button.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowLogIn() {
        //pop and push view controllers to move betwee Scenes!
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() { //creates view
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addSubview(alreadyHaveAccountButton)
        view.addSubview(plusPhotoButton) //take UIView, add subclass UIButton
        /* //frame mess up on horizontal orientation
         //inheritance for .frame, CGRect creates structure containing rectangle dimensions
         plusPhotoButton.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
         plusPhotoButton.center = view.center
         */
        
        /* //use helper function UIView.anchor()
         //auto layout
         plusPhotoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true //height
         plusPhotoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true //width
         
         //view.topAnchor position plus 40
         plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
         */
        alreadyHaveAccountButton.anchor(topAnchor: nil, bottomAnchor: view.bottomAnchor, leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 50)
        
        
        plusPhotoButton.anchor(topAnchor: view.topAnchor, bottomAnchor: nil, leftAnchor: nil, rightAnchor: nil, topPadding: 40, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 140, height: 140)
        // (center of x same as view's
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        /* //easier to use stackview
         view.addSubview(emailTextField)
         //.constraint() returns NSLayoutConstraints, we can activate using function .activate()
         NSLayoutConstraint.activate([
         //plusPhotoButton.bottomAnchor implied
         emailTextField.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20),
         emailTextField.heightAnchor.constraint(equalToConstant: 50),
         //specify positon of ends
         emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
         emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40)
         ])
         */
        setUpInputField()
    }
    //fileprivate, only visible within this source file
    fileprivate func setUpInputField() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.axis = .vertical //stackView has NSLayoutConstraint property
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        
        stackView.anchor(topAnchor: plusPhotoButton.bottomAnchor, bottomAnchor: nil,
                         leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor,
                         topPadding: 20, bottomPadding: 0, leftPadding: 40,
                         rightPadding: 40, width: 0, height: 200)
        
        //NSLayoutConstraint.activate([
        //stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20),
        //stackView.heightAnchor.constraint(equalToConstant: 200),
        //stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
        //stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40)
        //])
    }
}

extension UIView {
    func anchor(topAnchor: NSLayoutYAxisAnchor?, bottomAnchor: NSLayoutYAxisAnchor?,
                leftAnchor: NSLayoutXAxisAnchor?, rightAnchor: NSLayoutXAxisAnchor?,
                topPadding: CGFloat, bottomPadding: CGFloat, leftPadding: CGFloat,
                rightPadding: CGFloat, width: CGFloat, height: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        //prevent forceful unwrap on nil (null pointer exception)
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: topPadding).isActive = true
        }
        if let bottomAnchor = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomPadding).isActive = true
        }
        if let leftAnchor = leftAnchor {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: leftPadding).isActive = true
        }
        if let rightAnchor = rightAnchor {
            self.rightAnchor.constraint(equalTo: rightAnchor, constant: -rightPadding).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
