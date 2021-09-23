//
//  BrowserContainerContentView.swift
//  OrionUI
//
//  Created by Amer Hukić on 10. 9. 2021..
//

import UIKit
import SnapKit

class BrowserContainerContentView: UIView {
  let tabsScrollView = UIScrollView()
  let tabsStackView = UIStackView()
  let addressBarsScrollView = UIScrollView()
  let addressBarsStackView = UIStackView()
  let addressBarKeyboardBackgroundView = UIView()
  let toolbar = BrowserToolbar()
  let overlayView = UIView()
  
  // Address bar animation constants
  let tabsStackViewSpacing = CGFloat(24)
  let addressBarWidthOffset = CGFloat(-48)
  let addressBarContainerHidingWidthOffset = CGFloat(-200)
  let addressBarsStackViewSidePadding = CGFloat(24)
  let addressBarsStackViewSpacing = CGFloat(4)
  let addressBarsHidingCenterOffset = CGFloat(30)
  
  // Toolbar collapsing and expanding animation constants
  let addressBarsScrollViewExpandingHalfwayBottomOffset = CGFloat(-22)
  let addressBarsScrollViewExpandingFullyBottomOffset = CGFloat(-38)
  let addressBarsScrollViewCollapsingHalfwayBottomOffset = CGFloat(-8)
  let addressBarsScrollViewCollapsingFullyBottomOffset = CGFloat(20)
  let toolbarCollapsingHalfwayBottomOffset = CGFloat(30)
  let toolbarCollapsingFullyBottomOffset = CGFloat(80)
  let toolbarExpandingHalfwayBottomOffset = CGFloat(40)
  let toolbarExpandingFullyBottomOffset = CGFloat(0)

  var addressBarsScrollViewBottomConstraint: Constraint?
  var addressBarKeyboardBackgroundViewBottomConstraint: Constraint?
  var toolbarBottomConstraint: Constraint?
  
  var addressBarPageWidth: CGFloat {
    frame.width + addressBarWidthOffset + addressBarsStackViewSpacing
  }
  
  var addressBars: [BrowserAddressBar] {
    addressBarsStackView.arrangedSubviews as? [BrowserAddressBar] ?? []
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Helper methods
private extension BrowserContainerContentView {
  func setupView() {
    backgroundColor = UIColor(white: 0.97, alpha: 1)
    setupTabsScrollView()
    setupTabsStackView()
    setupToolbar()
    setupAddressBarsScrollView()
    setupAddressBarsStackView()
    setupAddressBarKeyboardBackgroundView()
    setupOverlayView()
  }
  
  func setupTabsScrollView() {
    tabsScrollView.showsHorizontalScrollIndicator = false
    tabsScrollView.showsVerticalScrollIndicator = false
    tabsScrollView.isScrollEnabled = false
    addSubview(tabsScrollView)
    tabsScrollView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  func setupTabsStackView() {
    tabsStackView.axis = .horizontal
    tabsStackView.alignment = .fill
    tabsStackView.distribution = .fillEqually
    tabsStackView.spacing = tabsStackViewSpacing
    tabsScrollView.addSubview(tabsStackView)
    tabsStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalToSuperview()
    }
  }
  
  func setupToolbar() {
    addSubview(toolbar)
    toolbar.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      toolbarBottomConstraint = $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).constraint
      $0.height.equalTo(100)
    }
  }
  
  func setupAddressBarsScrollView() {
    addressBarsScrollView.clipsToBounds = false
    addressBarsScrollView.showsHorizontalScrollIndicator = false
    addressBarsScrollView.showsVerticalScrollIndicator = false
    addressBarsScrollView.decelerationRate = .fast
    addSubview(addressBarsScrollView)
    addressBarsScrollView.snp.makeConstraints {
      addressBarsScrollViewBottomConstraint = $0.bottom.equalTo(safeAreaLayoutGuide).offset(addressBarsScrollViewExpandingFullyBottomOffset).constraint
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  func setupAddressBarsStackView() {
    addressBarsStackView.clipsToBounds = false
    addressBarsStackView.axis = .horizontal
    addressBarsStackView.alignment = .fill
    addressBarsStackView.distribution = .fill
    addressBarsStackView.spacing = addressBarsStackViewSpacing
    addressBarsScrollView.addSubview(addressBarsStackView)
    addressBarsStackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.equalToSuperview().offset(addressBarsStackViewSidePadding)
      $0.trailing.equalToSuperview().offset(-addressBarsStackViewSidePadding)
      $0.height.equalToSuperview()
    }
  }
  
  func setupAddressBarKeyboardBackgroundView() {
    addressBarKeyboardBackgroundView.backgroundColor = .keyboardGray
    insertSubview(addressBarKeyboardBackgroundView, belowSubview: toolbar)
    addressBarKeyboardBackgroundView.snp.makeConstraints {
      addressBarKeyboardBackgroundViewBottomConstraint = $0.bottom.equalTo(safeAreaLayoutGuide).constraint
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(60)
    }
  }
  
  func setupOverlayView() {
    overlayView.alpha = 0
    overlayView.backgroundColor = .white
    insertSubview(overlayView, belowSubview: addressBarKeyboardBackgroundView)
    overlayView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
