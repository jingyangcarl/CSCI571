//
//  GuardianHome.swift
//  Homework9
//
//  Created by Jing Yang on 4/25/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import Foundation

struct GuardianHome: Decodable {
    let response: Response
}

struct Response: Decodable {
    let status: String?;
    let userTier: String?;
    let total: Int?;
    let startIndex: Int?;
    let pageSize: Int?;
    let currentPage: Int?;
    let pages: Int?;
    let orderBy: String?;
    let results: [Result?];
}

struct Result: Decodable {
    let id: String?;
    let type: String?;
    let sectionId: String?;
    let sectionName: String?;
    let webPublicationDate: String?;
    let webTitle: String?;
    let webUrl: String?;
    let apiUrl: String?;
    let fields: Fields?;
    let isHosted: Bool?;
    let pillarId: String?;
    let pillarName: String?;
}

struct Fields: Decodable {
    let headline: String?;
    let shortUrl: String?;
    let thumbnail: String?;
}
