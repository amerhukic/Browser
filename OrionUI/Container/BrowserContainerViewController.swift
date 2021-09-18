//
//  BrowserContainerViewController.swift
//  OrionUI
//
//  Created by Amer Hukić on 10. 9. 2021..
//

import UIKit

class BrowserContainerViewController: UIViewController {
  let contentView = BrowserContainerContentView()
  var tabViewControllers = [BrowserTabViewController]()
  let keyboardManager = KeyboardManager()
  var isAddressBarActive = false
  var currentTabIndex = 0
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupAddressBarsScrollView()
    setupKeyboardManager()
    openNewTab()
  }
}

private extension BrowserContainerViewController {
  func setupNavigationBar() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
  }
  
  func setupAddressBarsScrollView() {
    contentView.addressBarsScrollView.delegate = self
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
    addressBar.onGoTapped = { [weak self] text in
      guard let self = self else { return }
      self.tabViewControllers[self.currentTabIndex].loadWebsite(urlString: text)
      self.dismissKeyboard()
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

extension BrowserContainerViewController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    currentTabIndex = Int(round(contentView.addressBarsScrollView.contentOffset.x / contentView.addressBarPageWidth))
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // width of one address bar page is address bar width + padding of `addressBarsStackViewSpacing / 2` from left and right side
    // we need to exclude the leading and trailing offset of (24 - address bar stack view padding from one side) from the precentage calculation
    let padding = 2 * (contentView.addressBarsStackViewSidePadding - (contentView.addressBarsStackViewSpacing) / 2)
    let percentage = contentView.addressBarsScrollView.contentOffset.x / (contentView.addressBarsScrollView.contentSize.width - padding)
    
    // we need to add tabs stack view spacing to the tabs scroll view content width, because spacing after last page is missing (we don't have any padding on sides)
    contentView.tabsScrollView.contentOffset.x = percentage * (contentView.tabsScrollView.contentSize.width + contentView.tabsStackViewSpacing)
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let pageFraction = targetContentOffset.pointee.x / contentView.addressBarPageWidth
    var nextTabIndex: Int
    if velocity.x > 0 {
      // swiping from right to left
      nextTabIndex = Int(ceil(pageFraction))
    } else if velocity.x == 0 {
      // no swiping - user lifted finger
      nextTabIndex = Int(round(pageFraction))
    } else {
      // swiping left to right
      nextTabIndex = Int(floor(pageFraction))
    }
    
    if currentTabIndex < nextTabIndex {
      currentTabIndex += 1
    } else if currentTabIndex > nextTabIndex {
      currentTabIndex -= 1
    }
    targetContentOffset.pointee = CGPoint(x: CGFloat(currentTabIndex) * contentView.addressBarPageWidth,
                                          y: targetContentOffset.pointee.y)
  }
}
