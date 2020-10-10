//
//  Constants.swift
//  Technovation
//
//  Created by Samantha Su on 4/25/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit

struct Constants {
    //userStandard memory key
    static let dailyChallengeKey = "kDailyChallenge"
    //when this is true = checkbox is unchecked for the day
    static let checkBoxKey = "kCheckBox"
    
    static let suggestionKey = "kSuggestion"
    
    static let isHidden = "kHidden"
    
    
    //user personal info, refreshed every time app opens
    static var points: Int?
    static var uID: String?
    static var purchasedItem: Array<String> = ["face1", "head1"]
//    static var avatarName: String?
    
    
    //UI design constants
    static var cornerR : CGFloat = 20
    static var red : CGColor = CGColor(srgbRed: 255/255.0, green: 111/255.0, blue: 88/255.0, alpha: 1)
    static var blue : CGColor = CGColor(srgbRed: 70/255.0, green: 103/255.0, blue: 142/255.0, alpha: 1)
}
