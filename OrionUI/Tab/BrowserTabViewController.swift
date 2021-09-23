//
//  BrowserTabViewController.swift
//  OrionUI
//
//  Created by Amer Hukić on 10. 9. 2021..
//

import UIKit
import WebKit

protocol BrowserTabViewControllerDelegate: AnyObject {
  func webViewDidScroll(yOffsetChange: CGFloat)
  func webViewDidEndDragging()
}

class BrowserTabViewController: UIViewController {
  private let contentView = BrowserTabContentView()
  private var isScrolling = false
  private var startYOffset = CGFloat(0)
  var hasLoadedUrl = false
  weak var delegate: BrowserTabViewControllerDelegate?
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentView.webView.scrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
    contentView.webView.navigationDelegate = self
  }
  
  func loadWebsite(from url: URL) {
    contentView.webView.load(URLRequest(url: url))
    hasLoadedUrl = true
    hideEmptyStateIfNeeded()
  }
  
  func showEmptyState() {
    UIView.animate(withDuration: 0.2) {
      self.contentView.emptyView.alpha = 1
    }
  }
  
  func hideEmptyStateIfNeeded() {
    guard hasLoadedUrl else { return }
    UIView.animate(withDuration: 0.2) {
      self.contentView.emptyView.alpha = 0
    }
  }
}

private extension BrowserTabViewController {
  @objc func handlePan(_ panGestureRecognizer: UIPanGestureRecognizer) {
    let yOffset = contentView.webView.scrollView.contentOffset.y
    switch panGestureRecognizer.state {
    case .began:
      startYOffset = yOffset
    case .changed:
      delegate?.webViewDidScroll(yOffsetChange: startYOffset - yOffset)
    case .failed, .ended, .cancelled:
      delegate?.webViewDidEndDragging()
    default:
      break
    }
  }
}

extension BrowserTabViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if navigationAction.navigationType == .linkActivated {
      guard let url = navigationAction.request.url else {return}
      webView.load(URLRequest(url: url))
    }
    decisionHandler(.allow)
  }
}
