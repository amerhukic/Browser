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
  private let addressBarsHidingCenterOffset = CGFloat(30)
  private var addressBarsScrollViewBottomConstraint: Constraint?
  private var addressBarKeyboardBackgroundViewBottomConstraint: Constraint?
  
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
      $0.width.equalTo(self).offset(addressBarWidthOffset)
    }
  }
  
  func updateStateForKeyboardAppearing(with keyboardHeight: CGFloat) {
    // show overlay view
    overlayView.alpha = 1

    // show address bar gray background view
    addressBarKeyboardBackgroundView.isHidden = false
    addressBarKeyboardBackgroundViewBottomConstraint?.update(offset: -keyboardHeight)
    addressBarsScrollViewBottomConstraint?.update(offset: -keyboardHeight)
    
    // move and hide address bars on left and right side of the current address bar
    setSideAddressBarsHidden(true)
  }
  
  func updateStateForKeyboardDisappearing() {
    overlayView.alpha = 0
    addressBarKeyboardBackgroundView.isHidden = true
    addressBarKeyboardBackgroundViewBottomConstraint?.update(offset: 0)
    addressBarsScrollViewBottomConstraint?.update(offset: addressBarsScrollViewBottomOffset)
    setSideAddressBarsHidden(false)
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
  
  func setSideAddressBarsHidden(_ isHidden: Bool) {
    let numberOfPages = addressBarsStackView.arrangedSubviews.count
    let currentPage = Int(currentPage)
    
    if currentPage == 0 && numberOfPages > 1 {
      let rightAddressBar = addressBarsStackView.arrangedSubviews[currentPage + 1]
      setHidden(isHidden, forRightAddressBar: rightAddressBar)
    }
    
    if currentPage > 0 {
      let leftAddressBar = addressBarsStackView.arrangedSubviews[currentPage - 1]
      setHidden(isHidden, forLeftAddressBar: leftAddressBar)
      
      if Int(currentPage) < (numberOfPages - 1) {
        let rightAddressBar = addressBarsStackView.arrangedSubviews[currentPage + 1]
        setHidden(isHidden, forRightAddressBar: rightAddressBar)
      }
    }
  }
  
  func setHidden(_ isHidden: Bool, forRightAddressBar addressBar: UIView) {
    if isHidden {
      addressBar.center = CGPoint(x: addressBar.center.x + addressBarsHidingCenterOffset,
                                  y: addressBar.center.y - addressBarsHidingCenterOffset)
    } else {
      addressBar.center = CGPoint(x: addressBar.center.x - addressBarsHidingCenterOffset,
                                  y: addressBar.center.y + addressBarsHidingCenterOffset)
    }
    addressBar.alpha = isHidden ? 0 : 1
  }
  
  func setHidden(_ isHidden: Bool, forLeftAddressBar addressBar: UIView) {
    if isHidden {
      addressBar.center = CGPoint(x: addressBar.center.x - addressBarsHidingCenterOffset,
                                  y: addressBar.center.y - addressBarsHidingCenterOffset)
    } else {
      addressBar.center = CGPoint(x: addressBar.center.x + addressBarsHidingCenterOffset,
                                  y: addressBar.center.y + addressBarsHidingCenterOffset)
    }
    addressBar.alpha = isHidden ? 0 : 1
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
    
    if currentPage < nextPage {
      currentPage += 1
    } else if currentPage > nextPage {
      currentPage -= 1
    }
    targetContentOffset.pointee = CGPoint(x: currentPage * pageWidth, y: targetContentOffset.pointee.y)
  }
}
