//
//  EducationViewController.swift
//  Technovation
//
//  Created by Samantha Su on 4/30/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit
import WebKit

class EducationViewController : UIViewController{
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        if let url = URL(string: "https://www.stutteringhelp.org/sites/default/files/Migrate/sometimes_stutter.pdf") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        let leftButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(popToPrevious))
        leftButton.image = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .bold))
        leftButton.tintColor = UIColor(cgColor: Constants.blue)
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc private func popToPrevious() {
        navigationController?.popViewController(animated: true)
    }
}
