//
//  BrowserTabViewController.swift
//  OrionUI
//
//  Created by Amer Hukić on 10. 9. 2021..
//

import UIKit

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
  }
  
  func loadWebsite(from url: URL) {
    contentView.webView.load(URLRequest(url: url))
    hasLoadedUrl = true
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
