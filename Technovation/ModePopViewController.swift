//
//  ModePopViewController.swift
//  Technovation
//
//  Created by Samantha Su on 4/29/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit

class ModePopViewController : UIViewController{
    
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var easyBouncingButton: UIButton!
    @IBOutlet weak var fluencyButton: UIButton!
   
    let viewModel = StandardViewModel()
    var mode = String()
    
    var keyWordIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        formatUI()
        showAnimate()
    }
    
    func formatUI(){
        popView.layer.cornerRadius = Constants.cornerR
        popView.layer.masksToBounds = true
        
        formatButton(button: easyBouncingButton)
        formatButton(button: fluencyButton)
    }
    
    @IBAction func segueToEB(_ sender: Any) {
        performSegue(withIdentifier: "popToEBLevel", sender: self)
    }
    
    @IBAction func segueToFluency(_ sender: Any) {
        performSegue(withIdentifier: "popToFluencyLevel", sender: self)
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popToEBLevel"{
            if let destVC = segue.destination as? GameViewController {
                //depending on which one the user presses, sets keyword variable of GameViewController
                destVC.keyWord = viewModel.levels[keyWordIndex!].keyWord
                destVC.mode = "Easy bouncing"
                print("EB segue called")
            }
        }
        if segue.identifier == "popToFluencyLevel"{
            if let destVC = segue.destination as? GameViewController {
                //depending on which one the user presses, sets keyword variable of GameViewController
                destVC.keyWord = viewModel.levels[keyWordIndex!].keyWord
                destVC.mode = "Fluency"
            }
        }
    }
}
