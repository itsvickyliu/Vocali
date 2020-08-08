//
//  MainViewController.swift
//  Technovation
//
//  Created by Samantha Su on 4/27/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//
import UIKit
import UserNotifications

class MainViewController : UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        requestNotificationAccess()
        scheduleNotification()
    }

    func setupUI(){
        logo.roundCornersForAspectFit(radius: Constants.cornerR)
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
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
}
