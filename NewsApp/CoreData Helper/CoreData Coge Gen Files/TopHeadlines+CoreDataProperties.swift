//
//  TopHeadlines+CoreDataProperties.swift
//  NewsApp
//
//  Created by Shubham Kapoor on 10/02/20.
//  Copyright © 2020 Shubham Kapoor. All rights reserved.
//
//

import Foundation
import CoreData


extension TopHeadlines {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopHeadlines> {
        return NSFetchRequest<TopHeadlines>(entityName: "TopHeadlines")
    }

    @NSManaged public var articleDescription: String?
    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var publishedAt: Date?
    @NSManaged public var sourceID: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?

}
