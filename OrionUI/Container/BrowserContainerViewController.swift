//
//  BrowserContainerViewController.swift
//  OrionUI
//
//  Created by Amer Hukić on 10. 9. 2021..
//

import UIKit

class BrowserContainerViewController: UIViewController {
  let viewModel: BrowserContainerViewModel
  let contentView = BrowserContainerContentView()
  var tabViewControllers = [BrowserTabViewController]()
  
  // Address bar animation properties
  var isAddressBarActive = false
  var hasHiddenTab = false
  var currentTabIndex = 0 {
    didSet {
      updateAddressBarsAfterTabChange()
    }
  }
  
  // Toolbar animation properties
  var collapsingToolbarAnimator: UIViewPropertyAnimator?
  var expandingToolbarAnimator: UIViewPropertyAnimator?
  var isCollapsed = false
  
  var currentAddressBar: BrowserAddressBar {
    contentView.addressBars[currentTabIndex]
  }
  
  var leftAddressBar: BrowserAddressBar? {
    contentView.addressBars[safe: currentTabIndex - 1]
  }
  
  var rightAddressBar: BrowserAddressBar? {
    contentView.addressBars[safe: currentTabIndex + 1]
  }
  
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
    setupCancelButton()
    setupAddressBarsScrollView()
    setupKeyboardManager()
    openNewTab(isHidden: false)
  }
  
  func setCancelButtonHidden(_ isHidden: Bool) {
    UIView.animate(withDuration: 0.1) {
      self.contentView.cancelButton.alpha = isHidden ? 0 : 1
    }
  }
}

// MARK: Helper methods
private extension BrowserContainerViewController {
  func setupAddressBarsScrollView() {
    contentView.addressBarsScrollView.delegate = self
  }
  
  func setupCancelButton() {
    contentView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
  }
  
  func openNewTab(isHidden: Bool) {
    addTabViewController(isHidden: isHidden)
    addAddressBar(isHidden: isHidden)
  }
  
  func addTabViewController(isHidden: Bool) {
    let tabViewController = BrowserTabViewController()
    tabViewController.view.alpha = isHidden ? 0 : 1
    tabViewController.view.transform = isHidden ? CGAffineTransform(scaleX: 0.8, y: 0.8) : .identity
    tabViewController.showEmptyState()
    tabViewController.delegate = self
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
      let isLastTab = self.currentTabIndex == self.tabViewControllers.count - 1
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
  
  func updateAddressBarsAfterTabChange() {
    currentAddressBar.setSideButtonsHidden(false)
    currentAddressBar.isUserInteractionEnabled = true
    leftAddressBar?.setSideButtonsHidden(true)
    leftAddressBar?.isUserInteractionEnabled = false
    rightAddressBar?.setSideButtonsHidden(true)
    rightAddressBar?.isUserInteractionEnabled = false
  }
}

// MARK: Action methods
private extension BrowserContainerViewController {
  @objc func cancelButtonTapped() {
    dismissKeyboard()
  }
}
