//
//  BrowserTabViewController.swift
//  OrionUI
//
//  Created by Amer Hukić on 10. 9. 2021..
//

import UIKit

class BrowserTabViewController: UIViewController {
  private let contentView = BrowserTabContentView()
  var hasLoadedUrl = false
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func loadWebsite(from url: URL) {
    contentView.webView.load(URLRequest(url: url))
    hasLoadedUrl = true
  }
}
