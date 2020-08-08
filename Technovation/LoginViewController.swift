//
//  LoginViewController.swift
//  Technovation
//
//  Created by Samantha Su on 4/25/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController:UIViewController{
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatUI()
        errorLabel.alpha = 0
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        self.view.addGestureRecognizer(tap)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func formatUI(){
        formatTextField(textField: emailTextField, placeholder: "email")
        formatTextField(textField: passwordTextField, placeholder: "password")
        formatButton(button: loginButton)
    }
    
    @IBAction func didLogin(_ sender: Any) {
        //setting up Firestore for data retrieval
        Firestore.firestore().settings = FirestoreSettings()
        let db = Firestore.firestore()
        
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }else{
                //retrieve previously stored data from Firebase
                Constants.uID = result!.user.uid
                let docRef = db.collection("users").document(Constants.uID!)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        Constants.points = document.get("points") as? Int
                        /*Constants.avatarName = document.get("avatarName") as? String
                        print("Document data: points \(String(describing: Constants.points)), avatarName \(String(describing: Constants.avatarName))")*/
                    } else {
                        print("Document does not exist")
                    }
                }
                self.transitionToHome()
            }
        }
    }
    func transitionToHome(){
        let tableViewController = storyboard?.instantiateViewController(identifier: "MainVC")
        let nav = UINavigationController()
        nav.viewControllers = [tableViewController!]
        
        view.window?.rootViewController = nav
        view.window?.makeKeyAndVisible()
    }
}
