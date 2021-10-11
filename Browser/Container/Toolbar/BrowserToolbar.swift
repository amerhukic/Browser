//
//  BrowserToolbar.swift
//  Browser
//
//  Created by Amer Hukić on 10. 9. 2021..
//

import UIKit

class BrowserToolbar: UIToolbar {
  let goBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: nil)
  let goForwardButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: nil, action: nil)
  let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: nil, action: nil)
  let bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "book"), style: .plain, target: nil, action: nil)
  let tabsButton = UIBarButtonItem(image: UIImage(systemName: "square.on.square"), style: .plain, target: nil, action: nil)
  
  override init(frame: CGRect) {
    // If toolbar frame size is not set then autolayout breaks so we need to set it manually
    // https://stackoverflow.com/questions/59700020/layout-constraint-errors-with-simple-uitoolar-for-keyboard-inputaccessoryview
    super.init(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
    setupButtons()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension BrowserToolbar {
  func setupButtons() {
    items = [
      goBackButton,
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      goForwardButton,
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      shareButton,
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      bookmarkButton,
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      tabsButton
    ]
  }
}
