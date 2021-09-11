//
//  BrowserAddressBar.swift
//  OrionUI
//
//  Created by Amer Hukić on 11. 9. 2021..
//

import UIKit

class BrowserAddressBar: UIView {
  private let shadowView = UIView()
  let textField = TextField()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    shadowView.layer.shadowPath = UIBezierPath(rect: textField.frame).cgPath
  }
}

private extension BrowserAddressBar {
  func setupView() {
    layer.masksToBounds = false
    setupShadowView()
    setupTextField()
  }
  
  func setupShadowView() {
    shadowView.layer.masksToBounds = false
    shadowView.layer.shadowColor = UIColor.lightGray.cgColor
    shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
    shadowView.layer.shadowOpacity = 0.35
    shadowView.layer.shadowRadius = 12
    addSubview(shadowView)
  }
  
  func setupTextField() {
    textField.delegate = self
    addSubview(textField)
    textField.snp.makeConstraints {
      $0.height.equalTo(46)
      $0.top.bottom.equalToSuperview().inset(8)
      $0.leading.trailing.equalToSuperview().inset(4)
    }
  }
}

extension BrowserAddressBar: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    print(1111)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    print(2222)
  }
}
