//
//  ChallengeViewController.swift
//  Technovation
//
//  Created by Vicky Liu on 4/28/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit
import BEMCheckBox
import Firebase

class ChallengeViewController: UIViewController {

    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var completionCheckBox: BEMCheckBox!
    @IBOutlet weak var completionNoticeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataIfNeeded() { didLoad in
            print (didLoad)
        }
    }
    
    let defaults = UserDefaults.standard
    let defaultsKey = "lastRefresh"
    let calender = Calendar.current
    
    func setupUI(){
        //set up challengeLabel
        challengeLabel.font = UIFont(name: "FredokaOne-Regular", size: 30)
        challengeLabel.textColor = UIColor(cgColor: Constants.red)
        
        //set up completionLabel
        completionNoticeLabel.font = UIFont(name: "FredokaOne-Regular", size: 30)
        completionNoticeLabel.textColor = UIColor(cgColor: Constants.red)
        completionNoticeLabel.alpha = 0
        
        //get if the check box had been checked
        let checked = defaults.bool(forKey: Constants.checkBoxKey)
        if checked{
            //set up check box
            completionCheckBox.onAnimationType = .fill
            completionCheckBox.offAnimationType = .fill
            completionCheckBox.onTintColor = UIColor(cgColor: Constants.red)
            completionCheckBox.onFillColor = UIColor(cgColor: Constants.red)
            completionCheckBox.tintColor = UIColor(cgColor: Constants.red)
        } else {
            completionCheckBox.hideBox = true
            completionCheckBox.on = false
            completionCheckBox.isEnabled = false
            completionNoticeLabel.text = "You already completed your challenge for today!"
            completionNoticeLabel.alpha = 1
            challengeLabel.alpha = 0
        }
        
    }
    
    @IBAction func didCheckBox(_ sender: Any) {
        defaults.set(false, forKey: Constants.checkBoxKey)
        Firestore.firestore().settings = FirestoreSettings()
        let db = Firestore.firestore()
        
        //get no of points from Firestore to local storage
        let docRef = db.collection("users").document(Constants.uID!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                Constants.points = document.get("points") as? Int
                print("Number of points from Firestore: \(String(describing: Constants.points))")
                
                //save points to Firestore
                let newPoints = (Constants.points ?? 0) + 5
                db.collection("users").document(Constants.uID!).updateData([
                    "points": newPoints
                ]){ err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Firestore points +5, now: \(newPoints)")
                        Constants.points = newPoints
                        self.completionCheckBox.isEnabled = false
                    }
                }
            }
        }
    }
    

    func loadDataIfNeeded(completion: (String) -> Void) {

        if isRefreshRequired() {
            // update the challenge
            defaults.set(Date(), forKey: defaultsKey)
            getChallenge()
            completion("no previous data exists")
        } else {
            challengeLabel.text = defaults.object(forKey: Constants.dailyChallengeKey) as? String
            setupUI()
            completion("previous data exists")
        }
    }

    func isRefreshRequired() -> Bool {

        guard let lastRefreshDate = defaults.object(forKey: defaultsKey) as? Date else {
            return true
        }
        
        //if it's not the same day
        if let diff = calender.dateComponents([.day], from: lastRefreshDate, to: Date()).day, diff >= 1 {
            return true
        } else {
            return false
        }
    }
    
    func getChallenge(){    //grab challenges from Firebase
        Firestore.firestore().settings = FirestoreSettings()
        let db = Firestore.firestore()
        var challengeArray: Array<String> = []
        var randomNum = Int.random(in: 0..<30)
        var challenge: String = ""
        //get challenges from db
        let docRef = db.collection("challenges").document("oneMonth")
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                if let document = document, document.exists {
                    challengeArray = (document.get("challenges") as? Array)!
                    challenge = challengeArray[randomNum]
                    self.challengeLabel.text = challenge
                    //save data within location for access within the same day
                    self.defaults.set(self.challengeLabel.text, forKey: Constants.dailyChallengeKey)
                    //refresh checkbox memory
                    self.defaults.set(true, forKey: Constants.checkBoxKey)
                    self.setupUI()
                    
                }
            }
        }
    }
      
}
