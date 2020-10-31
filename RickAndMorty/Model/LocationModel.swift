//
//  Location.swift
//  RickAndMorty
//
//  Created by Mousa Alwaraki on 10/6/20.
//

import Foundation

struct LocationModel: Decodable  {
    var id: Int?
    var name: String?
    var type: String?
    var dimension: String?
    var residents: [String?]
    var url: String?
    var created: String?
}

struct LocationResults: Decodable {
    var info: Info?
    var results: [LocationModel?]
}
