//
//  Array+Helpers.swift
//  Browser
//
//  Created by Amer Hukić on 21. 9. 2021..
//

import Foundation

extension Array {
  subscript (safe index: Index) -> Iterator.Element? {
    get {
      (startIndex <= index && index < endIndex) ? self[index] : nil
    }
    
    set {
      guard startIndex <= index && index < endIndex, let newValue = newValue else { return }
      self[index] = newValue
    }
  }
}
