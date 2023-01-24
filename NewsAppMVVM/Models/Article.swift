//
//  Article.swift
//  NewsAppMVVM
//
//  Created by Oscar David Myerston Vega on 24/01/23.
//

import Foundation

struct ArticleResponse: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
    let description: String?
}
