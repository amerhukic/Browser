//
//  BrowserContainerViewController.swift
//  OrionUI
//
//  Created by Amer Hukić on 10. 9. 2021..
//

import UIKit

class BrowserContainerViewController: UIViewController {
  private let contentView = BrowserContainerContentView()
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
