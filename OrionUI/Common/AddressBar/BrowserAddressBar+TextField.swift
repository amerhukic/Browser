//
//  BrowserAddressBar+TextField.swift
//  OrionUI
//
//  Created by Amer Hukić on 11. 9. 2021..
//

import UIKit

extension BrowserAddressBar {
  class TextField: UITextField {
    override init(frame: CGRect) {
      super.init(frame: frame)
      setupView()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
      var rect = super.leftViewRect(forBounds: bounds)
      rect.origin.x += 10
      rect.size.width = 30
      return rect
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
      var rect = super.rightViewRect(forBounds: bounds)
      rect.origin.x -= 20
      rect.size.width = 30
      return rect
    }

    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
      var rect = super.clearButtonRect(forBounds: bounds)
      rect.origin.x -= 15
      rect.size.width = 30
      return rect
    }
  }
}

private extension BrowserAddressBar.TextField {
  func setupView() {
    layer.cornerRadius = 12
    backgroundColor = .white
    clearButtonMode = .whileEditing
    setupPlaceholder()
    setupLeftView()
    setupRightView()
  }
  
  func setupPlaceholder() {
    let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.textFieldGray]
    attributedPlaceholder = NSAttributedString(string: "Search or enter website", attributes: attributes)
  }
  
  func setupLeftView() {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
    imageView.tintColor = .textFieldGray
    imageView.contentMode = .scaleAspectFit
    leftView = imageView
    leftViewMode = .always
  }
  
  func setupRightView() {
    let recordingButton = UIButton(type: .system)
    recordingButton.setImage(UIImage(systemName: "mic.fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
    recordingButton.imageView?.contentMode = .scaleAspectFit
    recordingButton.tintColor = .textFieldGray
    rightView = recordingButton
    rightViewMode = .unlessEditing
  }
}

