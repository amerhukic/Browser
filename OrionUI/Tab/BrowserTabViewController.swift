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
    contentView.webView.load(URLRequest(url: URL(string: "http://google.com")!))
  }
}
