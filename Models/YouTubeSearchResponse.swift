//
//  YouTubeSearchResponse.swift
//  MovieApp
//
//  Created by User on 22.08.2024.
//

import Foundation

struct YouTubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
