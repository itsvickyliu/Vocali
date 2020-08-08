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
    }
}
