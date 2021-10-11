//
//  UIColor+Helpers.swift
//  Browser
//
//  Created by Amer Hukić on 11. 9. 2021..
//

import UIKit

// MARK: Colors
extension UIColor {
  static let textFieldGray = UIColor(white: 138 / 255, alpha: 1)
  static let loadingBarBlue = UIColor(red: 0, green: 122 / 255, blue: 255 / 255, alpha: 1)
  static let keyboardGray = UIColor(red: 214 / 255, green: 215 / 255, blue: 220 / 255, alpha: 1)
}

// MARK: Helpers
extension UIColor {
  var isDark: Bool {
    var r, g, b, a: CGFloat
    (r, g, b, a) = (0, 0, 0, 0)
    getRed(&r, green: &g, blue: &b, alpha: &a)
    let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
    return  luminance < 0.5
  }
}
