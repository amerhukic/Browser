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
  let toolbar = BrowserToolbar()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
      $0.top.equalTo(toolbar)
      $0.leading.trailing.equalToSuperview()
    }
  }
  
  func setupAddressBarsStackView() {
    addressBarsStackView.axis = .horizontal
    addressBarsStackView.alignment = .fill
    addressBarsStackView.distribution = .fillEqually
    addressBarsStackView.spacing = 4
    addressBarsScrollView.addSubview(addressBarsStackView)
    addressBarsStackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.height.equalToSuperview()
    }
  }
}
