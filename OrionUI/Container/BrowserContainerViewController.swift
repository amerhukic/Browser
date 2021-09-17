//
//  BrowserContainerViewController.swift
//  OrionUI
//
//  Created by Amer Hukić on 10. 9. 2021..
//

import UIKit

class BrowserContainerViewController: UIViewController {
  private let contentView = BrowserContainerContentView()
  private var tabViewControllers = [BrowserTabViewController]()
  private var isAddressBarActive = false
  private let keyboardManager = KeyboardManager()
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupKeyboardManager()
    openNewTab()
  }
}

private extension BrowserContainerViewController {
  // MARK: Setup methods
  func setupNavigationBar() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
  }
  
  // MARK: Keyboard handling
  func setupKeyboardManager() {
    keyboardManager.onKeyboardWillShow = { [weak self] notification in
      guard let self = self, self.isAddressBarActive else { return }
      self.navigationController?.setNavigationBarHidden(false, animated: true)
      self.animateWithKeyboard(for: notification) { keyboardFrame in
        self.contentView.updateStateForKeyboardAppearing(with: keyboardFrame.height)
      }
    }
    
    keyboardManager.onKeyboardWillHide = { [weak self] notification in
      guard let self = self, self.isAddressBarActive else { return }
      self.isAddressBarActive = false
      self.navigationController?.setNavigationBarHidden(true, animated: true)
      self.animateWithKeyboard(for: notification) { _ in
        self.contentView.updateStateForKeyboardDisappearing()
      }
    }
  }
  
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
  
  // MARK: Helper methods
  func openNewTab() {
    addTabViewController()
    addAddressBar()
  }
  
  func addTabViewController() {
    let tabViewController = BrowserTabViewController()
    tabViewControllers.append(tabViewController)
    contentView.addTabView(tabViewController.view)
    addChild(tabViewController)
    tabViewController.didMove(toParent: self)
  }
  
  func addAddressBar() {
    let addressBar = BrowserAddressBar()
    addressBar.onBeginEditing = { [weak self] in
      self?.isAddressBarActive = true
    }
    addressBar.onGoTapped = { [weak self] in
      self?.dismissKeyboard()
    }
    contentView.addAddressBar(addressBar)
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
}

// MARK: Action methods
private extension BrowserContainerViewController {
  @objc func cancelButtonTapped() {
    dismissKeyboard()
  }
}
