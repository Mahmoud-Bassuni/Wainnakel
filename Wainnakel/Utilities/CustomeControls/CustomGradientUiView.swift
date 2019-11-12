//
//  CustomGradientUiView.swift
//  Wainnakel
//
//  Created by Bassuni on 11/6/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//

import Foundation
import UIKit
class CustomGradientUiView : UIView
{
    @IBInspectable  public var firstGradientColor: String = ""
    @IBInspectable  public var lastGradientColor: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        guard firstGradientColor != "" && lastGradientColor != ""  else { return }
             self.setGradientBackground(colorOne: UIColor(named: firstGradientColor)!, colorTwo: UIColor(named: lastGradientColor)!)
    }
}

class CustomUiView : UIView
{
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor(named: "MenuColor")?.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }
    
}
