//
//  CountryListConfig.swift
//  NewsApp
//
//  Created by Shubham Kapoor on 10/02/20.
//  Copyright © 2020 Shubham Kapoor. All rights reserved.
//

import Foundation

class CountryListConfig {
    
    static let shared = CountryListConfig()
    
    private func getTimezoneJsonFilePath(filename: String) -> String? {
        return Bundle.main.path(forResource: filename, ofType: "json")
    }
    
    private func checkFileExist(filename: String) -> Bool {
        if let path = getTimezoneJsonFilePath(filename: filename) {
            return FileManager.default.fileExists(atPath: path)
        } else {
            return false
        }
    }
    
    /// Get Country List Model Obj
    func getCountryListJsonFilePath(jsonName: String) throws -> [CountryList]? {
        var countryListObj: [CountryList]?
        do {
            if checkFileExist(filename: jsonName) {
                if let path = Bundle.main.path(forResource: jsonName, ofType: "json") {
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        
                        let countryListModel = try JSONDecoder().decode(CountryListResponseModel.self, from: data)
                        countryListObj = countryListModel
                    }
                } else {
                    throw NSError.kFilenotFound as! Error
                }
            }
        } catch let error {
            throw error
        }
        return countryListObj
    }
}

