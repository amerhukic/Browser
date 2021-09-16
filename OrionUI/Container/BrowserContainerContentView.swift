//
//  BrowserContainerContentView.swift
//  OrionUI
//
//  Created by Amer Hukić on 10. 9. 2021..
//

import UIKit
import SnapKit

class BrowserContainerContentView: UIView {
  private let tabsScrollView = UIScrollView()
  private let tabsStackView = UIStackView()
  private let addressBarsScrollView = UIScrollView()
  private let addressBarsStackView = UIStackView()
  private let addressBarKeyboardBackgroundView = UIView()
  private let toolbar = BrowserToolbar()
  
  private let addressBarsScrollViewBottomOffset = -38
  private let addressBarWidthOffset = -48
  private let addressBarsStackViewSidePadding = 24
  private let addressBarsStackViewSpacing = CGFloat(4)
  private var addressBarsStackViewLeadingConstraint: Constraint?
  private var addressBarsStackViewTrailingConstraint: Constraint?
  private var addressBarsScrollViewBottomConstraint: Constraint?
  private var addressBarKeyboardBackgroundViewBottomConstraint: Constraint?
  private var addressBarsWidthConstraints = [Constraint]()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func addTabView(_ view: UIView) {
    tabsStackView.addArrangedSubview(view)
    view.snp.makeConstraints {
      $0.width.equalTo(self)
    }
  }
  
  func addAddressBar(_ addressBar: BrowserAddressBar) {
    addressBarsStackView.addArrangedSubview(addressBar)
    addressBar.snp.makeConstraints {
      addressBarsWidthConstraints.append($0.width.equalTo(self).offset(addressBarWidthOffset).constraint)
    }
  }
  
  func updateStateForKeyboardAppearing(with keyboardHeight: CGFloat) {
    addressBarKeyboardBackgroundView.isHidden = false
    addressBarsStackView.spacing = 30
    addressBarsStackViewLeadingConstraint?.update(inset: 16)
    addressBarsStackViewTrailingConstraint?.update(offset: -16)
    addressBarsScrollViewBottomConstraint?.update(offset: -keyboardHeight)
    addressBarKeyboardBackgroundViewBottomConstraint?.update(offset: -keyboardHeight)
    addressBarsWidthConstraints.forEach { $0.update(offset: -32) }
  }
  
  func updateStateForKeyboardDisappearing() {
    addressBarKeyboardBackgroundView.isHidden = true
    addressBarsStackView.spacing = addressBarsStackViewSpacing
    addressBarsStackViewLeadingConstraint?.update(offset: addressBarsStackViewSidePadding)
    addressBarsStackViewTrailingConstraint?.update(offset: -addressBarsStackViewSidePadding)
    addressBarsScrollViewBottomConstraint?.update(offset: addressBarsScrollViewBottomOffset)
    addressBarKeyboardBackgroundViewBottomConstraint?.update(offset: 0)
    addressBarsWidthConstraints.forEach { $0.update(offset: addressBarWidthOffset) }
  }
}

private extension BrowserContainerContentView {
  func setupView() {
    backgroundColor = UIColor(white: 0.97, alpha: 1)
    setupTabsScrollView()
    setupTabsStackView()
    setupToolbar()
    setupAddressBarsScrollView()
    setupAddressBarsStackView()
    setupAddressBarKeyboardBackgroundView()
  }
  
  func setupTabsScrollView() {
    tabsScrollView.isPagingEnabled = true
    tabsScrollView.showsHorizontalScrollIndicator = false
    tabsScrollView.showsVerticalScrollIndicator = false
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
    tabsStackView.spacing = 24
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
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
      $0.height.equalTo(100)
    }
  }
  
  func setupAddressBarsScrollView() {
    addressBarsScrollView.isPagingEnabled = true
    addressBarsScrollView.showsHorizontalScrollIndicator = false
    addressBarsScrollView.showsVerticalScrollIndicator = false
    addSubview(addressBarsScrollView)
    addressBarsScrollView.snp.makeConstraints {
      addressBarsScrollViewBottomConstraint = $0.bottom.equalTo(safeAreaLayoutGuide).offset(addressBarsScrollViewBottomOffset).constraint
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  func setupAddressBarsStackView() {
    addressBarsStackView.axis = .horizontal
    addressBarsStackView.alignment = .fill
    addressBarsStackView.distribution = .fillEqually
    addressBarsStackView.spacing = addressBarsStackViewSpacing
    addressBarsScrollView.addSubview(addressBarsStackView)
    addressBarsStackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      addressBarsStackViewLeadingConstraint = $0.leading.equalToSuperview().offset(addressBarsStackViewSidePadding).constraint
      addressBarsStackViewTrailingConstraint = $0.trailing.equalToSuperview().offset(-addressBarsStackViewSidePadding).constraint
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
}
