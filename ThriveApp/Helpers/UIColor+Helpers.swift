//
//  UIColor+Helpers.swift
//  ThriveApp
//
//  Created by Vadims Vorobjovs on 16/03/2023.
//

import UIKit

extension UIColor {
    static func hex(_ value: UInt) -> UIColor {
        return UIColor(red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(value & 0x0000FF) / 255.0,
                       alpha: CGFloat(1.0))
    }
}
