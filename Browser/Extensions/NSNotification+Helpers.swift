//
//  NSNotification+Helpers.swift
//  Browser
//
//  Created by Amer Hukić on 16. 9. 2021..
//

import UIKit

extension NSNotification {
  var keyboardAnimationDuration: Double? {
    userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
  }
  
  var keyboardBeginFrame: CGRect? {
    (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
  }
  
  var keyboardEndFrame: CGRect? {
    (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
  }
  
  var keyboardWillShow: Bool {
    guard let keyboardBeginFrame = keyboardBeginFrame,
          let keyboardEndFrame = keyboardEndFrame else {
      return false
    }
    return keyboardBeginFrame.minY > keyboardEndFrame.minY
  }
  
  var keyboardAnimationCurve: UIView.AnimationCurve? {
    guard let curveValue = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return nil }
    return UIView.AnimationCurve(rawValue: curveValue)
  }
}
