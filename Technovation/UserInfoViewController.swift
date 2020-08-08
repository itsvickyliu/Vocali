//
//  UserInfoViewController.swift
//  Technovation
//
//  Created by Samantha Su on 4/30/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class UserInfoViewController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        pointsLabel.text = "You have \(Constants.points ?? 0) points!"
        pointsLabel.font = UIFont(name: "FredokaOne-Regular", size: 25)
        pointsLabel.textColor = UIColor(cgColor: Constants.red)
    }
}
