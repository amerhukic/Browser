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
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupKeyboardObservers()
    openNewTab()
    openNewTab()
    openNewTab()
  }
}

// MARK: Helper methods
private extension BrowserContainerViewController {
  func setupNavigationBar() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
  }
  
  func setupKeyboardObservers() {
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

// MARK: Keyboard handling
private extension BrowserContainerViewController {
  @objc func keyboardWillShow(_ notification: NSNotification) {
    guard isAddressBarActive else { return }
    navigationController?.setNavigationBarHidden(false, animated: true)
    animateWithKeyboard(notification: notification) { keyboardFrame in
      self.contentView.updateStateForKeyboardAppearing(with: keyboardFrame.height)
    }
  }
  
  @objc func keyboardWillHide(_ notification: NSNotification) {
    guard isAddressBarActive else { return }
    isAddressBarActive = false
    navigationController?.setNavigationBarHidden(true, animated: true)
    animateWithKeyboard(notification: notification) { _ in
      self.contentView.updateStateForKeyboardDisappearing()
    }
  }
  
  @objc func cancelButtonTapped() {
    dismissKeyboard()
  }
}

extension UIViewController {
  func animateWithKeyboard(
    notification: NSNotification,
    animations: ((_ keyboardFrame: CGRect) -> Void)?
  ) {
    // Extract the duration of the keyboard animation
    let durationKey = UIResponder.keyboardAnimationDurationUserInfoKey
    let duration = notification.userInfo![durationKey] as! Double
    
    // Extract the final frame of the keyboard
    let frameKey = UIResponder.keyboardFrameEndUserInfoKey
    let keyboardFrameValue = notification.userInfo![frameKey] as! NSValue
    
    // Extract the curve of the iOS keyboard animation
    let curveKey = UIResponder.keyboardAnimationCurveUserInfoKey
    let curveValue = notification.userInfo![curveKey] as! Int
    let curve = UIView.AnimationCurve(rawValue: curveValue)!
    
    // Create a property animator to manage the animation
    let animator = UIViewPropertyAnimator(
      duration: duration,
      curve: curve
    ) {
      // Perform the necessary animation layout updates
      animations?(keyboardFrameValue.cgRectValue)
      
      // Required to trigger NSLayoutConstraint changes
      // to animate
      self.view?.layoutIfNeeded()
    }
    
    // Start the animation
    animator.startAnimation()
  }
}
