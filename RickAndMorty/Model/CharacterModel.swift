//
//  Character.swift
//  RickAndMorty
//
//  Created by Mousa Alwaraki on 10/6/20.
//

import Foundation
import CoreData

struct CharacterModel: Decodable {
    var id: Int?
    var name: String?
    var status: LifeStatus?
    var species: String?
    var type: String?
    var gender: Gender?
    var origin: Origin?
    var location: CurrentLocation?
    var image: String?
    var episode: [String]?
    var url: String?
    var created: String?
}

struct CharacterResults: Decodable {
    var info: Info?
    var results: [CharacterModel]
}

struct Info: Decodable {
    var count: Int?
    var pages: Int?
}

struct Origin: Decodable , Hashable {
    var name: String?
    var url: String?
}

struct CurrentLocation: Decodable , Hashable {
    var name: String?
    var url: String?
}

