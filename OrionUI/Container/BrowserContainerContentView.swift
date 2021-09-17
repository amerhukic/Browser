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
  private let overlayView = UIView()
  
  private let tabsStackViewSpacing = CGFloat(24)
  private let addressBarsScrollViewBottomOffset = CGFloat(-38)
  private let addressBarWidthOffset = CGFloat(-48)
  private let addressBarsStackViewSidePadding = CGFloat(24)
  private let addressBarsStackViewSpacing = CGFloat(4)
  private var addressBarsStackViewLeadingConstraint: Constraint?
  private var addressBarsStackViewTrailingConstraint: Constraint?
  private var addressBarsScrollViewBottomConstraint: Constraint?
  private var addressBarKeyboardBackgroundViewBottomConstraint: Constraint?
  private var addressBarsWidthConstraints = [Constraint]()
  
  private var currentPage = CGFloat(0)
  private lazy var pageWidth: CGFloat = {
    frame.width + addressBarWidthOffset + addressBarsStackViewSpacing
  }()
  
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
    overlayView.alpha = 1
    addressBarKeyboardBackgroundView.isHidden = false
    addressBarsStackView.spacing = 30
    addressBarsStackViewLeadingConstraint?.update(inset: 16)
    addressBarsStackViewTrailingConstraint?.update(offset: -16)
    addressBarsScrollViewBottomConstraint?.update(offset: -keyboardHeight)
    addressBarKeyboardBackgroundViewBottomConstraint?.update(offset: -keyboardHeight)
    addressBarsWidthConstraints.forEach { $0.update(offset: -32) }
  }
  
  func updateStateForKeyboardDisappearing() {
    overlayView.alpha = 0
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
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
      $0.height.equalTo(100)
    }
  }
  
  func setupAddressBarsScrollView() {
    addressBarsScrollView.showsHorizontalScrollIndicator = false
    addressBarsScrollView.showsVerticalScrollIndicator = false
    addressBarsScrollView.decelerationRate = .fast
    addressBarsScrollView.delegate = self
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
  
  func setupOverlayView() {
    overlayView.alpha = 0
    overlayView.backgroundColor = .white
    insertSubview(overlayView, belowSubview: addressBarKeyboardBackgroundView)
    overlayView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

extension BrowserContainerContentView: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    currentPage = round(scrollView.contentOffset.x / pageWidth)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // width of one address bar page is address bar width + padding of `addressBarsStackViewSpacing / 2` from left and right side
    // we need to exclude the leading and trailing offset of (24 - address bar stack view padding from one side) from the precentage calculation
    let padding = 2 * (addressBarsStackViewSidePadding - (addressBarsStackViewSpacing) / 2)
    let percentage = addressBarsScrollView.contentOffset.x / (addressBarsScrollView.contentSize.width - padding)
    
    // we need to add tabs stack view spacing to the tabs scroll view content width, because spacing after last page is missing (we don't have any padding on sides)
    tabsScrollView.contentOffset.x = percentage * (tabsScrollView.contentSize.width + tabsStackViewSpacing)
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let finalXPosition = targetContentOffset.pointee.x
    var nextPage: CGFloat
    if velocity.x > 0 {
      // swiping from right to left
      nextPage = ceil(finalXPosition / pageWidth)
    } else if velocity.x == 0 {
      // no swiping - user lifted finger
      nextPage = round(finalXPosition / pageWidth)
    } else {
      // swiping left to right
      nextPage = floor(finalXPosition / pageWidth)
    }
    
    if nextPage < currentPage {
      nextPage = currentPage - 1
    } else if nextPage > currentPage {
      nextPage = currentPage + 1
    }
    targetContentOffset.pointee = CGPoint(x: nextPage * pageWidth, y: targetContentOffset.pointee.y)
  }
}
