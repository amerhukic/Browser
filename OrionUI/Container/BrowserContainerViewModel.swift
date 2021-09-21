//
//  BrowserContainerViewModel.swift
//  OrionUI
//
//  Created by Amer Hukić on 21. 9. 2021..
//

import Foundation

class BrowserContainerViewModel {
  private let urlGenerator: URLGenerator
  private let keyboardManager: KeyboardManager
  
  init(urlGenerator: URLGenerator = .init(),
       keyboardManager: KeyboardManager = .init()) {
    self.urlGenerator = urlGenerator
    self.keyboardManager = keyboardManager
  }
  
  func setKeyboardHandler(onKeyboardWillShow keyboardWillShowHandler: ((NSNotification) -> Void)?,
                          onKeyboardWillHide keyboardWillHideHandler: ((NSNotification) -> Void)?) {
    keyboardManager.keyboardWillShowHandler = keyboardWillShowHandler
    keyboardManager.keyboardWillHideHandler = keyboardWillHideHandler
  }
  
  func getURL(for text: String) -> URL? {
    urlGenerator.getURL(for: text)
  }
}
