//
//  Styling.swift
//  Breakout
//
//  Created by Valdez, Armando Anthony on 12/12/20.
//

import Foundation
import UIKit

class Styling{
    static func styleFillButton(_ button: UIButton){
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button: UIButton){
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
}
