//
//  BrowserContainerViewController+AddressBarsAnimation.swift
//  OrionUI
//
//  Created by Amer Hukić on 23. 9. 2021..
//

import UIKit

extension BrowserContainerViewController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    currentTabIndex = Int(round(contentView.addressBarsScrollView.contentOffset.x / contentView.addressBarPageWidth))
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // width of one address bar page is address bar width + padding of `addressBarsStackViewSpacing / 2` from left and right side
    // we need to exclude the leading and trailing offset of (24 - address bar stack view padding from one side) from the precentage calculation
    let padding = 2 * (contentView.addressBarsStackViewSidePadding - contentView.addressBarsStackViewSpacing / 2)
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
      hiddenAddressBar.containerView.alpha = min(1, 1.2 * percentage)
      
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
        hiddenAddressBar?.plusOverlayView.alpha = 0
        hiddenAddressBar?.containerView.alpha = 1
      }
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if currentTabIndex == tabViewControllers.count - 1 {
      hasHiddenTab = false
    }
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate && currentTabIndex == tabViewControllers.count - 1 {
      hasHiddenTab = false
    }
  }
}
