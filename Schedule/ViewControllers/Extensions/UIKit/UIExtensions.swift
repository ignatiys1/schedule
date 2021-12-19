//
//  UIStackView.swift
//  Schedule
//
//  Created by Ignat Urbanovich on 18.12.21.
//

import Foundation
import UIKit

extension UIStackView {
    
    
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, distribution: UIStackView.Distribution) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

extension UIFont {
    
    static var avenirNextDemiBold20: UIFont {
        return UIFont.init(name: "Avenir Next Demi Bold", size: 20)!
    }
    
    static var avenirNextDemiBold14: UIFont {
        UIFont(name: "Avenir Next Demi Bold", size: 14)!
    }
    
    static var avenirNext20: UIFont {
        UIFont(name: "Avenir Next", size: 20)!
    }
    
    static var avenirNext14: UIFont {
        UIFont(name: "Avenir Next", size: 14)!
    }
    
    static var avenirNext30: UIFont {
        UIFont(name: "Avenir Next", size: 30)!
    }
}

extension UILabel {
    
    convenience init(text: String, font: UIFont?, textAlignment: NSTextAlignment) {
        self.init()
        
        self.text = text
        self.textColor = .black
        self.font = font
        self.textAlignment = textAlignment
        self.adjustsFontSizeToFitWidth = true
        self.translatesAutoresizingMaskIntoConstraints = false
        //self.backgroundColor = .red
    }
    
}
