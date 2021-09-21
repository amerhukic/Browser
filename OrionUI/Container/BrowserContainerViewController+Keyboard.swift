//
//  BrowserContainerViewController+Keyboard.swift
//  OrionUI
//
//  Created by Amer Hukić on 18. 9. 2021..
//

import UIKit

extension BrowserContainerViewController {
  func setupKeyboardManager() {
    viewModel.setKeyboardHandler(onKeyboardWillShow: { [weak self] notification in
      guard let self = self, self.isAddressBarActive else { return }
      self.navigationController?.setNavigationBarHidden(false, animated: true)
      self.animateWithKeyboard(for: notification) { keyboardFrame in
        self.updateStateForKeyboardAppearing(with: keyboardFrame.height)
      }
    }, onKeyboardWillHide: { [weak self] notification in
      guard let self = self, self.isAddressBarActive else { return }
      self.isAddressBarActive = false
      self.navigationController?.setNavigationBarHidden(true, animated: true)
      self.animateWithKeyboard(for: notification) { _ in
        self.updateStateForKeyboardDisappearing()
      }
    })
  }
}

private extension BrowserContainerViewController {
  func animateWithKeyboard(for notification: NSNotification, animation: ((CGRect) -> Void)?) {
    guard let frame = notification.keyboardFrame,
          let duration = notification.keyboardAnimationDuration,
          let curve = notification.keyboardAnimationCurve else {
      return
    }
    UIViewPropertyAnimator(duration: duration, curve: curve) {
      animation?(frame)
      self.view?.layoutIfNeeded()
    }.startAnimation()
  }
  
  func updateStateForKeyboardAppearing(with keyboardHeight: CGFloat) {
    contentView.overlayView.alpha = 1
    contentView.addressBarKeyboardBackgroundView.isHidden = false
    contentView.addressBarKeyboardBackgroundViewBottomConstraint?.update(offset: -keyboardHeight)
    contentView.addressBarsScrollViewBottomConstraint?.update(offset: -keyboardHeight)
    setSideAddressBarsHidden(true)
  }
  
  func updateStateForKeyboardDisappearing() {
    contentView.overlayView.alpha = 0
    contentView.addressBarKeyboardBackgroundView.isHidden = true
    contentView.addressBarKeyboardBackgroundViewBottomConstraint?.update(offset: 0)
    contentView.addressBarsScrollViewBottomConstraint?.update(offset: contentView.addressBarsScrollViewBottomOffset)
    setSideAddressBarsHidden(false)
  }
  
  func setSideAddressBarsHidden(_ isHidden: Bool) {
    let numberOfPages = tabViewControllers.count
    let currentPage = Int(currentTabIndex)
    
    if currentPage == 0 && numberOfPages > 1 {
      let rightAddressBar = contentView.addressBarsStackView.arrangedSubviews[currentPage + 1]
      setHidden(isHidden, forRightAddressBar: rightAddressBar)
    }
    
    if currentPage > 0 {
      let leftAddressBar = contentView.addressBarsStackView.arrangedSubviews[currentPage - 1]
      setHidden(isHidden, forLeftAddressBar: leftAddressBar)
      
      if currentPage < numberOfPages - 1 {
        let rightAddressBar = contentView.addressBarsStackView.arrangedSubviews[currentPage + 1]
        setHidden(isHidden, forRightAddressBar: rightAddressBar)
      }
    }
  }
  
  func setHidden(_ isHidden: Bool, forRightAddressBar addressBar: UIView) {
    let offset = contentView.addressBarsHidingCenterOffset
    if isHidden {
      addressBar.center = CGPoint(x: addressBar.center.x + offset,
                                  y: addressBar.center.y - offset)
    } else {
      addressBar.center = CGPoint(x: addressBar.center.x - offset,
                                  y: addressBar.center.y + offset)
    }
    addressBar.alpha = isHidden ? 0 : 1
  }
  
  func setHidden(_ isHidden: Bool, forLeftAddressBar addressBar: UIView) {
    let offset = contentView.addressBarsHidingCenterOffset
    if isHidden {
      addressBar.center = CGPoint(x: addressBar.center.x - offset,
                                  y: addressBar.center.y - offset)
    } else {
      addressBar.center = CGPoint(x: addressBar.center.x + offset,
                                  y: addressBar.center.y + offset)
    }
    addressBar.alpha = isHidden ? 0 : 1
  }
}
