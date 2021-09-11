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
    backgroundColor = .white
    setupTabsScrollView()
    setupTabsStackView()
    setupToolbar()
  }
  
  func setupTabsScrollView() {
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
    tabsStackView.spacing = 8
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
    }
  }
}
