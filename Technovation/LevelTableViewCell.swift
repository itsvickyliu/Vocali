//
//  LevelTableViewCell.swift
//  Technovation
//
//  Created by Samantha Su on 3/23/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {
    
    let viewModel = StandardViewModel()
    
    @IBOutlet weak var keywordLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupBasic()
    }
    
    override var frame: CGRect {
            get {
                return super.frame
            }
            set (newFrame) {
                var frame = newFrame
                let newWidth = frame.width * 0.85 // get 80% width here
                let space = (frame.width - newWidth) / 2
                frame.size.width = newWidth
                frame.origin.x += space

                super.frame = frame

            }
        }
    
    func setupBasic(){
        // set up appearances of all cells
        keywordLabel.font = UIFont(name: "FredokaOne-Regular", size: 50)
        keywordLabel.textColor = UIColor(displayP3Red: 0.93, green: 0.455, blue: 0.38, alpha: 1)
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor

        // add corner radius on `contentView`
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
    }
    
    func getKeywordLabel() -> (String){
        return keywordLabel.text!
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.9, initialSpringVelocity: 5, options: [],animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: { finished in
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 5, options: .curveEaseIn,animations: {
            self.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
            },completion: { finished in

        })
    }
}
