//
//  Movie.swift
//  MovieApp
//
//  Created by User on 19.08.2024.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let original_language: String?
    let poster_path: String?
    let release_date: String?
    let original_title: String?
    let original_name: String?
    let overview: String?
    let vote_average: Double
    let vote_count: Int
}
