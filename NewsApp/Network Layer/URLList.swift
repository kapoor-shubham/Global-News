//
//  URLList.swift
//  NewsApp
//
//  Created by Shubham Kapoor on 05/02/20.
//  Copyright © 2020 Shubham Kapoor. All rights reserved.
//

import Foundation

struct UrlList {
    
    static let shared = UrlList()
    
    let baseURL = "https://newsapi.org/v2/"
    let apiKey = "9dfb27a3d38d483ba42ec73f17cff546"
    
    let topHeadlience = "top-headlines?"
    
}
