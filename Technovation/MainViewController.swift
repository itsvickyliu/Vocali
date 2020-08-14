//
//  MainViewController.swift
//  Technovation
//
//  Created by Samantha Su on 4/27/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//
import UIKit
import UserNotifications

class MainViewController : UIViewController, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var customWordTextField: UITextField!
    @IBOutlet weak var customDrillsButton: UIButton!
    
    fileprivate let checker = UITextChecker()
    
    @IBAction func goToCustomDrill(_ sender: Any) {
        guard customWordTextField.text != "" else {return}
        customWordTextField.resignFirstResponder()
        let modePopup = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ModePopVC") as! ModePopViewController
        modePopup.keyWord = customWordTextField.text
        present(modePopup, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customWordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        setupUI()
        requestNotificationAccess()
        scheduleNotification()
    }

    func setupUI(){
        logo.roundCornersForAspectFit(radius: Constants.cornerR)
        formatTextField(textField: customWordTextField, placeholder: "Custom Word")
        customWordTextField.setLeftPaddingPoints(0)
        customWordTextField.addInputAccessoryView(title: "Done", target: self, selector: #selector(tapDone))
        customWordTextField.font = UIFont(name: "FredokaOne-Regular", size: 35)
        customWordTextField.textColor = UIColor(displayP3Red: 147.0/255.0, green: 189.0/255.0, blue: 238.0/255.0, alpha: 1)
    }
    
    @objc func tapDone() {
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard textField.text?.count != 0 , textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {return}
        let range = NSRange(location: 0, length: textField.text!.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: textField.text!, range: range, startingAt: 0, wrap: false, language: "en")

        if misspelledRange.location == NSNotFound{
            //is word
            customWordTextField.textColor = UIColor(cgColor: Constants.red)
            customDrillsButton.isEnabled = true
        } else{
            customWordTextField.textColor = UIColor(displayP3Red: 147.0/255.0, green: 189.0/255.0, blue: 238.0/255.0, alpha: 1)
            customDrillsButton.isEnabled = false
        }
    }
    
    
    
    func requestNotificationAccess() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        //notification testing
//        center.removeAllDeliveredNotifications()
//        center.removeAllPendingNotificationRequests()
//        center.getPendingNotificationRequests { (notificationRequests) in
//             for notificationRequest:UNNotificationRequest in notificationRequests {
//                print("notification: ", notificationRequest.identifier)
//            }
//        }
        
        let content = UNMutableNotificationContent()
        content.title = "Vocali Daily Challenge"
        content.subtitle = "Check out today's speech challenge in Vocali!"
        content.sound = UNNotificationSound.default

        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current

        dateComponents.hour = 15 // 15:00 hours
           
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
                 dateMatching: dateComponents, repeats: true)

        //testing
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: "583a086e-db3e-11ea-87d0-0242ac130003", content: content, trigger: trigger)

        // add our notification request
        center.add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}

extension MainViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
