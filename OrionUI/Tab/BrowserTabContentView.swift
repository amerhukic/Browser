//
//  BrowserTabContentView.swift
//  OrionUI
//
//  Created by Amer Hukić on 13. 9. 2021..
//

import UIKit
import WebKit

class BrowserTabContentView: UIView {
  let emptyStateView = BrowserTabEmptyStateView()
  let webView = WKWebView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Helper methods
private extension BrowserTabContentView {
  func setupView() {
    backgroundColor = .white
    setupShadow()
    setupWebView()
    setupEmptyStateView()
  }
  
  func setupShadow() {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.lightGray.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowOpacity = 0.5
    layer.shadowRadius = 15
  }
  
  func setupWebView() {
    webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
    webView.allowsBackForwardNavigationGestures = true
    webView.scrollView.contentInset = .zero
    addSubview(webView)
    webView.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.leading.bottom.trailing.equalToSuperview()
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
