//
//  URLValidator.swift
//  Browser
//
//  Created by Amer Hukić on 21. 9. 2021..
//

import Foundation

struct URLValidator {
  func isValidURL(_ urlString: String) -> Bool {
    guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue),
          let match = detector.firstMatch(in: urlString,
                                          options: [],
                                          range: NSRange(location: 0, length: urlString.utf16.count)) else {
      return false
    }
    // it is a link, if the match covers the whole string
    return match.range.length == urlString.utf16.count
  }
}
