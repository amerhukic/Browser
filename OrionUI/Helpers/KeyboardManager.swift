//
//  KeyboardManager.swift
//  OrionUI
//
//  Created by Amer Hukić on 16. 9. 2021..
//

import UIKit

class KeyboardManager {
  private var isKeyboardShown = false
  var onKeyboardWillShow: ((NSNotification) -> Void)?
  var onKeyboardWillHide: ((NSNotification) -> Void)?

  init() {
    addObservers()
  }
}

// MARK: Private methods
private extension KeyboardManager {
  func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
}

// MARK: Action methods
private extension KeyboardManager {
  @objc func keyboardWillShow(_ notification: NSNotification) {
    guard !isKeyboardShown else { return }
    isKeyboardShown = true
    onKeyboardWillShow?(notification)
  }
  
  @objc func keyboardWillHide(_ notification: NSNotification) {
    onKeyboardWillHide?(notification)
    isKeyboardShown = false
  }
}
