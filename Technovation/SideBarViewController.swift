//
//  SideBarViewController.swift
//  Technovation
//
//  Created by Samantha Su on 10/12/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit

class SideBarViewController: UIViewController{
    @IBOutlet weak var voluntaryStutteringButton: UIButton!
    
    override func viewDidLoad() {
        voluntaryStutteringButton.titleLabel?.textAlignment = .center
    }
    
}
