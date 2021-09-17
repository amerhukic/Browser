//
//  BrowserTabViewController.swift
//  OrionUI
//
//  Created by Amer Hukić on 10. 9. 2021..
//

import UIKit

class BrowserTabViewController: UIViewController {
  private let contentView = BrowserTabContentView()
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func loadWebsite(urlString: String) {
    guard let url = URL(string: urlString) else { return }
    contentView.webView.load(URLRequest(url: url))
  }
}
