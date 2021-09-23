//
//  BrowserTabContentView.swift
//  OrionUI
//
//  Created by Amer Hukić on 13. 9. 2021..
//

import UIKit
import WebKit

class BrowserTabContentView: UIView {
  let webView = WKWebView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension BrowserTabContentView {
  func setupView() {
    backgroundColor = .white
    setupWebView()
  }
  
  func setupWebView() {
    webView.allowsBackForwardNavigationGestures = true
    webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    addSubview(webView)
    webView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
