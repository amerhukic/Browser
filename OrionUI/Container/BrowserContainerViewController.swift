//
//  BrowserContainerViewController.swift
//  OrionUI
//
//  Created by Amer Hukić on 10. 9. 2021..
//

import UIKit

class BrowserContainerViewController: UIViewController {
  private let contentView = BrowserContainerContentView()
  private var tabViewControllers = [BrowserTabViewController]()
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    openNewTab()
  }
}

// MARK: Helper methods
private extension BrowserContainerViewController {
  func openNewTab() {
    let tabViewController = BrowserTabViewController()
    tabViewControllers.append(tabViewController)
    contentView.tabsStackView.addArrangedSubview(tabViewController.view)
    tabViewController.view.snp.makeConstraints {
      $0.width.equalTo(contentView)
    }
    addChild(tabViewController)
    tabViewController.didMove(toParent: self)
  }
}
