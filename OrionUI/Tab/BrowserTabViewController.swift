//
//  BrowserTabViewController.swift
//  OrionUI
//
//  Created by Amer Hukić on 10. 9. 2021..
//

import UIKit
import WebKit

protocol BrowserTabViewControllerDelegate: AnyObject {
  func tabViewControllerDidStartLoadingURL(_ tabViewController: BrowserTabViewController)
  func tabViewController(_ tabViewController: BrowserTabViewController, didChangeLoadingProgressTo progress: CGFloat)
  func tabViewControllerDidScroll(yOffsetChange: CGFloat)
  func tabViewControllerDidEndDragging()
}

class BrowserTabViewController: UIViewController {
  private let contentView = BrowserTabContentView()
  private var isScrolling = false
  private var startYOffset = CGFloat(0)
  private var loadingProgressObservation: NSKeyValueObservation?
  var hasLoadedUrl = false
  weak var delegate: BrowserTabViewControllerDelegate?
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupWebView()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    guard keyPath == "estimatedProgress" else { return }
    delegate?.tabViewController(self, didChangeLoadingProgressTo: CGFloat(contentView.webView.estimatedProgress))
  }
  
  func loadWebsite(from url: URL) {
    contentView.webView.load(URLRequest(url: url))
    hasLoadedUrl = true
    delegate?.tabViewControllerDidStartLoadingURL(self)
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

// MARK: Helper methods
private extension BrowserTabViewController {
  func setupWebView() {
    contentView.webView.scrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
    contentView.webView.navigationDelegate = self
    contentView.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
  }
}

// MARK: Action methods
private extension BrowserTabViewController {
  @objc func handlePan(_ panGestureRecognizer: UIPanGestureRecognizer) {
    let yOffset = contentView.webView.scrollView.contentOffset.y
    switch panGestureRecognizer.state {
    case .began:
      startYOffset = yOffset
    case .changed:
      delegate?.tabViewControllerDidScroll(yOffsetChange: startYOffset - yOffset)
    case .failed, .ended, .cancelled:
      delegate?.tabViewControllerDidEndDragging()
    default:
      break
    }
  }
}

// MARK: WKNavigationDelegate
extension BrowserTabViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if navigationAction.navigationType == .linkActivated {
      guard let url = navigationAction.request.url else {return}
      webView.load(URLRequest(url: url))
    }
    decisionHandler(.allow)
  }
}
