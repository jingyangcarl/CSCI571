//
//  GuardianHomeDetail.swift
//  Homework9
//
//  Created by Jing Yang on 4/26/20.
//  Copyright © 2020 Jing Yang. All rights reserved.
//

import Foundation

struct GuardianHomeDetail: Decodable {
    var response: DetailResponse
}

struct DetailResponse: Decodable {
    var status: String;
    var userTier: String;
    var total: Int;
    var content: DetailContent;
}

struct DetailContent: Decodable {
    var id: String;
    var type: String;
    var sectionId: String;
    var sectionName: String;
    var webPublicationDate: String;
    var webTitle: String;
    var webUrl: String;
    var apiUrl: String;
    var blocks: DetailBlocks;
    var isHosted: Bool;
    var pillarId: String;
    var pillarName: String;
}

struct DetailBlocks: Decodable {
    var main: DetailMain?;
    var body: [DetailBody?];
    var totalBodyBlocks: Int;
}

struct DetailMain: Decodable {
    var id: String;
    var bodyHtml: String;
    var bodyTextSummary: String;
    var attributes: DetailAttribute;
    var published: Bool;
    var createdDate: String?;
    var firstPublishedDate: String;
    var publishedDate: String;
    var lastModifiedDate: String;
    var contributors: [DetailContributor];
    var elements: [DetailMainElement]
}

struct DetailAttribute: Decodable {}
struct DetailContributor: Decodable {}
struct DetailMainElement: Decodable {
    var type: String;
    var assets: [DetailAsset];
    var imageTypeData: DetailImageTypeData?;
}
struct DetailImageTypeData: Decodable {}

struct DetailAsset: Decodable {
    var type: String;
    var mimeType: String;
    var file: String;
    var typeData: DetailTypeData;
}
struct DetailTypeData: Decodable {}

struct DetailBody: Decodable {
    var id: String;
    var bodyHtml: String;
    var bodyTextSummary: String;
    var attributes: DetailAttribute;
    var published: Bool;
    var createdDate: String?;
    var firstPublishedDate: String;
    var publishedDate: String;
    var lastModifiedDate: String;
    var contributors: [DetailContributor];
    var elements: [DetailBodyElement];
}

struct DetailBodyElement: Decodable {
}
