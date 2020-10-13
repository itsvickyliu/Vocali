//
//  SurveyViewController.swift
//  Technovation
//
//  Created by Vicky Liu on 10/13/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let leftButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(popToPrevious))
        leftButton.image = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold))
        leftButton.tintColor = UIColor(cgColor: Constants.blue)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc private func popToPrevious() {
        navigationController?.popViewController(animated: true)
    }
}
