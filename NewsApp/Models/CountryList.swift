//
//  CountryList.swift
//  NewsApp
//
//  Created by Shubham Kapoor on 05/02/20.
//  Copyright © 2020 Shubham Kapoor. All rights reserved.
//

import Foundation

// MARK: - CountryList
struct CountryList: Codable {
    let countryName: String
    let countryCode: String
}

typealias CountryListResponseModel = [CountryList]




