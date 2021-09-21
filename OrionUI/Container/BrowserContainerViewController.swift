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
  var isAddressBarActive = false
  var currentTabIndex = 0
  var hasHiddenTab = false
  let viewModel: BrowserContainerViewModel

  init(viewModel: BrowserContainerViewModel = .init()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupAddressBarsScrollView()
    setupKeyboardManager()
    openNewTab(isHidden: false)
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
  
  func openNewTab(isHidden: Bool) {
    addTabViewController(isHidden: isHidden)
    addAddressBar(isHidden: isHidden)
  }
  
  func addTabViewController(isHidden: Bool) {
    let tabViewController = BrowserTabViewController()
    tabViewController.view.alpha = isHidden ? 0 : 1
    tabViewController.view.transform = isHidden ? CGAffineTransform(scaleX: 0.8, y: 0.8) : .identity
    tabViewControllers.append(tabViewController)
    contentView.tabsStackView.addArrangedSubview(tabViewController.view)
    tabViewController.view.snp.makeConstraints {
      $0.width.equalTo(contentView)
    }
    addChild(tabViewController)
    tabViewController.didMove(toParent: self)
  }
  
  func addAddressBar(isHidden: Bool) {
    let addressBar = BrowserAddressBar()
    addressBar.onBeginEditing = { [weak self] in
      self?.isAddressBarActive = true
    }
    addressBar.onGoTapped = { [weak self, weak addressBar] text in
      guard let self = self else { return }
      let tabViewController = self.tabViewControllers[self.currentTabIndex]
      let isLastTab = (self.currentTabIndex == self.tabViewControllers.count - 1)
      if isLastTab && !tabViewController.hasLoadedUrl {
        self.openNewTab(isHidden: true)
      }
      if let url = self.viewModel.getURL(for: text) {
        addressBar?.setDomain(self.viewModel.getDomain(from: url))
        tabViewController.loadWebsite(from: url)
      }
      self.dismissKeyboard()
    }
    contentView.addressBarsStackView.addArrangedSubview(addressBar)
    addressBar.snp.makeConstraints {
      $0.width.equalTo(contentView).offset(contentView.addressBarWidthOffset)
    }
    
    if isHidden {
      hasHiddenTab = true
      addressBar.containerViewWidthConstraint?.update(offset: contentView.addressBarContainerHidingWidthOffset)
      addressBar.setContainerAlpha(0)
      addressBar.setPlusOverlayAlpha(1)
    }
  }
  
  func dismissKeyboard() {
    view.endEditing(true)
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

    // if it is one tab before last tab then we should animate the appearance of the last hidden tab
    if currentTabIndex == (tabViewControllers.count - 2) && hasHiddenTab {
      let currentXOffset = contentView.addressBarsScrollView.contentOffset.x
      let addressBarWidth = contentView.frame.width + contentView.addressBarWidthOffset
      let hiddenAddressBarContainerWidth = addressBarWidth + contentView.addressBarContainerHidingWidthOffset
      let offsetBeforeStartingStretching = CGFloat(currentTabIndex) * contentView.addressBarPageWidth + hiddenAddressBarContainerWidth
      
      // animate alpha of hidden address bar
      let percentage = 1 - (offsetBeforeStartingStretching - currentXOffset) / hiddenAddressBarContainerWidth
      guard let hiddenAddressBar = contentView.addressBars.last else { return }
      hiddenAddressBar.setContainerAlpha(min(1, 1.2 * percentage))
      
      // animate stretching of hidden address bar
      if currentXOffset > offsetBeforeStartingStretching {
        let diff = currentXOffset - offsetBeforeStartingStretching
        hiddenAddressBar.containerViewWidthConstraint?.update(offset: contentView.addressBarContainerHidingWidthOffset + diff)
      }
    }
    
    // finish hidden tab animation and show hidden tab
    if currentTabIndex == (tabViewControllers.count - 1) && hasHiddenTab {
      let currentXOffset = contentView.addressBarsScrollView.contentOffset.x
      let hiddenAddressBarContainerWidth = contentView.frame.width + contentView.addressBarWidthOffset + contentView.addressBarContainerHidingWidthOffset
      let offsetBeforeStartingStretching = CGFloat(currentTabIndex - 1) * contentView.addressBarPageWidth + hiddenAddressBarContainerWidth
      let diff = currentXOffset - offsetBeforeStartingStretching
      guard let hiddenAddressBar = contentView.addressBars.last else { return }
      let widthOffset = contentView.addressBarContainerHidingWidthOffset + diff
      hiddenAddressBar.containerViewWidthConstraint?.update(offset: widthOffset < 0 ? widthOffset : 0)
    }
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
    
    // finish hidden tab animation and show hidden tab
    if currentTabIndex == (tabViewControllers.count - 1) && hasHiddenTab {
      let hiddenTabViewController = tabViewControllers.last
      let hiddenAddressBar = contentView.addressBars.last
      UIView.animate(withDuration: 0.3) {
        hiddenTabViewController?.view.transform = .identity
        hiddenTabViewController?.view.alpha = 1
        hiddenAddressBar?.setPlusOverlayAlpha(0)
        hiddenAddressBar?.setContainerAlpha(1)
      }
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if currentTabIndex == tabViewControllers.count - 1 {
      hasHiddenTab = false
    }
  }
}

// MARK: Action methods
private extension BrowserContainerViewController {
  @objc func cancelButtonTapped() {
    dismissKeyboard()
  }
}
