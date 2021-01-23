//
//  UITextField.swift
//  blindTestiOS
//
//  Created by Thibault BALSAMO on 22/01/2021.
//

import Foundation
import UIKit

extension UITextField {
    
    func setBottomLine() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 5, width: self.frame.width, height: 5)
        
        bottomLine.backgroundColor = UIColor(named: "Secondary")?.cgColor
        
        self.borderStyle = .none
        
        self.layer.addSublayer(bottomLine)
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)])
    }
}
