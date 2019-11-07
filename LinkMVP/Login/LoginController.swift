//
//  LoginController.swift
//  LinkMVP
//
//  Created by Jung Yeon Choi on 7/20/19.
//  Copyright © 2019 Peter Choi. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    let logoContainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rbg(red: 0, green: 120, blue: 175)
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        view.addSubview(logoImageView)
        logoImageView.anchor(topAnchor: nil, bottomAnchor: nil, leftAnchor: nil, rightAnchor: nil, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoImageView.contentMode = .scaleAspectFill
        
        return view
    }()
    
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
    
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        //button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        //call extension function which returns UIColor class
        button.backgroundColor = UIColor.rbg(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5 //layer is of type CALayer
        //? since label does not have to have a title
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        //target is button (self), selects objc method or object, you can specify
        //UIControl.Event.touchUpInside, but .touchUpInside is understood
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (dataResult, err) in
            if let err = err {
                print("failed to log in: ", err)
                return
            }
            print("successfully logged in: ", dataResult?.user.uid ?? "")
            //undo present()
            //we dismiss the navigation controller for login/signup
            guard let mainTabBarController =
                UIApplication.shared.keyWindow?.rootViewController as?
                MainTabBarController else {return}
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 //default is false
            && passwordTextField.text?.count ?? 0 > 0
        if isFormValid {
            loginButton.backgroundColor = UIColor.rbg(red: 17, green: 154, blue: 237)
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = UIColor.rbg(red: 149, green: 204, blue: 244)
            loginButton.isEnabled = false
        }
    }
    
    let dontHaveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(attributedString: NSAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        attributedTitle.append(NSAttributedString(string: "Sign Up.", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.rbg(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        //Pushes a view controller onto the receiver’s stack and updates the display.
        //signUpController becomes top View Controller in the stack, above loginPage/
        //navigationController property refers to nearest UINavigationController ancestor.
        //here its rootViewController is the current Login Page, about to push sign up
        //controller
        navigationController?.pushViewController(signUpController, animated: true)
    }
    
    //status bar (time, wifi, etc) made white font
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        //view is specific view that our viewController manages
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addSubview(dontHaveAccountButton)
        view.addSubview(logoContainerView)
        dontHaveAccountButton.anchor(topAnchor: nil, bottomAnchor: view.bottomAnchor, leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 50)
        logoContainerView.anchor(topAnchor: view.topAnchor, bottomAnchor: nil, leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor, topPadding: 0, bottomPadding: 0, leftPadding: 0, rightPadding: 0, width: 0, height: 150)
        setupInputFields()
    }
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        //always add subview before anchoring!
        stackView.anchor(topAnchor: logoContainerView.bottomAnchor, bottomAnchor: nil, leftAnchor: view.leftAnchor, rightAnchor: view.rightAnchor, topPadding: 40, bottomPadding: 0, leftPadding: 40, rightPadding: 40, width: 0, height: 140)
    }
}

