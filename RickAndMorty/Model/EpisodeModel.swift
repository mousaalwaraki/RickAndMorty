//
//  Episode.swift
//  RickAndMorty
//
//  Created by Mousa Alwaraki on 10/6/20.
//

import Foundation

struct EpisodeModel: Decodable  {
    var id: Int?
    var name: String?
    var air_date: String?
    var episode: String?
    var characters: [String?]
    var url: String?
    var created: String?
}

struct EpisodeResults: Decodable {
    var info: Info?
    var results: [EpisodeModel?]
}
