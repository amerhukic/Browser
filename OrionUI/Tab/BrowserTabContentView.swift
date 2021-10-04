//
//  BrowserTabContentView.swift
//  OrionUI
//
//  Created by Amer Hukić on 13. 9. 2021..
//

import UIKit
import WebKit
import SnapKit

class BrowserTabContentView: UIView {
  let webView = WKWebView()
  let emptyStateView = BrowserTabEmptyStateView()
  let statusBarBackgroundView = StatusBarBackgroundView()
  var statusBarBackgroundViewHeightConstraint: Constraint?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    statusBarBackgroundViewHeightConstraint?.update(offset: statusBarHeight)
  }
}

// MARK: Helper methods
private extension BrowserTabContentView {
  func setupView() {
    backgroundColor = .white
    layer.masksToBounds = false
    setupShadow()
    setupWebView()
    setupEmptyStateView()
    setupStatusBarBackgroundView()
  }
  
  func setupShadow() {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowOpacity = 0.5
    layer.shadowRadius = 15
  }
  
  func setupWebView() {
    webView.allowsBackForwardNavigationGestures = true
    webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
    webView.scrollView.contentInset = .zero
    webView.scrollView.layer.masksToBounds = false
    addSubview(webView)
    webView.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.leading.bottom.trailing.equalToSuperview()
    }
  }
  
  func setupStatusBarBackgroundView() {
    statusBarBackgroundView.backgroundColor = .white
    addSubview(statusBarBackgroundView)
    statusBarBackgroundView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      statusBarBackgroundViewHeightConstraint = $0.height.equalTo(0).constraint
    }
  }
  
  func setupEmptyStateView() {
    emptyStateView.alpha = 0
    addSubview(emptyStateView)
    emptyStateView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
