//
//  BrowserAddressBar.swift
//  OrionUI
//
//  Created by Amer Hukić on 11. 9. 2021..
//

import UIKit
import SnapKit

class BrowserAddressBar: UIView {
  private let containerView = UIView()
  private let shadowView = UIView()
  private let domainLabel = UILabel()
  private let plusOverlayView = UIView()
  private let textField = TextField()
  private let textFieldSidePadding = CGFloat(4)
  private var textFieldLeadingConstraint: Constraint?
  private var textFieldTrailingConstraint: Constraint?
  private var text: String?
  var containerViewWidthConstraint: Constraint?

  var onBeginEditing: (() -> Void)?
  var onGoTapped: ((String) -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    shadowView.layer.shadowPath = UIBezierPath(rect: containerView.frame).cgPath
  }
  
  func setContainerAlpha(_ alpha: CGFloat) {
    containerView.alpha = alpha
  }
  
  func setPlusOverlayAlpha(_ alpha: CGFloat) {
    plusOverlayView.alpha = alpha
  }
  
  func setDomain(_ domain: String) {
    domainLabel.text = domain
  }
}

private extension BrowserAddressBar {
  func setupView() {
    layer.masksToBounds = false
    containerView.layer.masksToBounds = false
    setupContainerView()
    setupShadowView()
    setupTextField()
    setupDomainLabel()
    setupPlusOverlayView()
  }
  
  func setupContainerView() {
    addSubview(containerView)
    containerView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
      containerViewWidthConstraint = $0.width.equalToSuperview().constraint
    }
  }
  
  func setupShadowView() {
    shadowView.layer.masksToBounds = false
    shadowView.layer.shadowColor = UIColor.lightGray.cgColor
    shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
    shadowView.layer.shadowOpacity = 0.15
    shadowView.layer.shadowRadius = 4
    containerView.addSubview(shadowView)
  }
  
  func setupTextField() {
    textField.delegate = self
    containerView.addSubview(textField)
    textField.snp.makeConstraints {
      $0.height.equalTo(46)
      $0.top.bottom.equalToSuperview().inset(8)
      textFieldLeadingConstraint = $0.leading.equalToSuperview().offset(textFieldSidePadding).constraint
      textFieldTrailingConstraint = $0.trailing.equalToSuperview().offset(-textFieldSidePadding).constraint
    }
  }
  
  func setupDomainLabel() {
    domainLabel.textAlignment = .center
    addSubview(domainLabel)
    domainLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.equalToSuperview().multipliedBy(0.65)
    }
  }
  
  func setupPlusOverlayView() {
    let imageView = UIImageView(image: UIImage(systemName: "plus"))
    imageView.contentMode = .scaleAspectFit
    plusOverlayView.addSubview(imageView)
    imageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(24)
    }
    
    plusOverlayView.layer.cornerRadius = textField.layer.cornerRadius
    plusOverlayView.backgroundColor = .white
    plusOverlayView.alpha = 0
    containerView.addSubview(plusOverlayView)
    plusOverlayView.snp.makeConstraints {
      $0.edges.equalTo(textField)
    }
  }

  func showEditingState() {
    shadowView.isHidden = true
    domainLabel.alpha = 0
    textFieldLeadingConstraint?.update(offset: 0)
    textFieldTrailingConstraint?.update(offset: 0)
  }
  
  func showInactiveState() {
    shadowView.isHidden = false
    domainLabel.alpha = 1
    textFieldLeadingConstraint?.update(offset: textFieldSidePadding)
    textFieldTrailingConstraint?.update(offset: -textFieldSidePadding)
  }
}

extension BrowserAddressBar: UITextFieldDelegate {
  func textFieldDidBeginEditing(_: UITextField) {
    onBeginEditing?()
    textField.text = text
    showEditingState()
    textField.activityState = .editing
  }
  
  func textFieldDidEndEditing(_: UITextField) {
    textField.text = text
    showInactiveState()
    textField.activityState = .inactive
  }
  
  func textFieldShouldReturn(_: UITextField) -> Bool {
    text = textField.text
    showInactiveState()
    onGoTapped?(text ?? "")
    return true
  }
}
