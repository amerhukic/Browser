//
//  BrowserContainerViewController+Keyboard.swift
//  Browser
//
//  Created by Amer Hukić on 18. 9. 2021..
//

import UIKit

extension BrowserContainerViewController {
  func setupKeyboardManager() {
    viewModel.setKeyboardHandler(onKeyboardWillShow: { [weak self] notification in
      guard let self = self, self.isAddressBarActive else { return }
      self.setCancelButtonHidden(false)
      self.animateWithKeyboard(for: notification) { keyboardFrame in
        self.updateStateForKeyboardAppearing(with: keyboardFrame.height)
      }
    }, onKeyboardWillHide: { [weak self] notification in
      guard let self = self, self.isAddressBarActive else { return }
      self.isAddressBarActive = false
      self.setCancelButtonHidden(true)
      self.animateWithKeyboard(for: notification) { _ in
        self.updateStateForKeyboardDisappearing()
      }
    })
  }
}

// MARK: Helper methods
private extension BrowserContainerViewController {
  func animateWithKeyboard(for notification: NSNotification, animation: ((CGRect) -> Void)?) {
    guard let frame = notification.keyboardEndFrame,
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
    contentView.addressBarKeyboardBackgroundView.isHidden = false
    let offset = keyboardHeight - contentView.safeAreaInsets.bottom
    contentView.addressBarKeyboardBackgroundViewBottomConstraint?.update(offset: -offset + 10)
    contentView.addressBarsScrollViewBottomConstraint?.update(offset: -offset)
    tabViewControllers[safe: currentTabIndex]?.showEmptyState()
    setSideAddressBarsHidden(true)
  }
  
  func updateStateForKeyboardDisappearing() {
    contentView.addressBarKeyboardBackgroundView.isHidden = true
    contentView.addressBarKeyboardBackgroundViewBottomConstraint?.update(offset: 0)
    contentView.addressBarsScrollViewBottomConstraint?.update(offset: contentView.addressBarsScrollViewExpandingFullyBottomOffset)
    tabViewControllers[safe: currentTabIndex]?.hideEmptyStateIfNeeded()
    setSideAddressBarsHidden(false)
  }
  
  func setSideAddressBarsHidden(_ isHidden: Bool) {
    if let leftAddressBar = leftAddressBar {
      setHidden(isHidden, forLeftAddressBar: leftAddressBar)
    }
    if let rightAddressBar = rightAddressBar {
      setHidden(isHidden, forRightAddressBar: rightAddressBar)
    }
  }
  
  func setHidden(_ isHidden: Bool, forRightAddressBar addressBar: UIView) {
    // In some cases keyboard will show is called multiple times.
    // To prevent the address bar center from being offset multiple times we have to check if it is already offset
    if (isHidden && addressBar.alpha == 0) {
      return
    }
    
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
    if (isHidden && addressBar.alpha == 0) {
      return
    }
    
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
