//
//  CountryListViewModel.swift
//  NewsApp
//
//  Created by Shubham Kapoor on 10/02/20.
//  Copyright © 2020 Shubham Kapoor. All rights reserved.
//

import Foundation

class CountryListViewModel {
    
    func getCountryList() -> [CountryList]? {
        do {
            return try CountryListConfig.shared.getCountryListJsonFilePath(jsonName: Constants.GeneralConstants.countryJsonName)
        } catch let err {
            print(err)
            return nil
        }
    }
    
    public func emoji(countryCode: String) -> Character {
      let base = UnicodeScalar("🇦").value - UnicodeScalar("A").value

      var string = ""
      countryCode.uppercased().unicodeScalars.forEach {
        if let scala = UnicodeScalar(base + $0.value) {
          string.append(String(describing: scala))
        }
      }

      return Character(string)
    }
    
    func getSpecificCountryNews(countryCode: String) {
        print("News of \(countryCode) is shown.")
    }
}
