//
//  NSNotification+Helpers.swift
//  OrionUI
//
//  Created by Amer Hukić on 16. 9. 2021..
//

import UIKit

extension NSNotification {
  var keyboardAnimationDuration: Double? {
    userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
  }
  
  var keyboardFrame: CGRect? {
    (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
  }
  
  var keyboardAnimationCurve: UIView.AnimationCurve? {
    guard let curveValue = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return nil }
    return UIView.AnimationCurve(rawValue: curveValue)
  }
}
