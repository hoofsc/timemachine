//
//  Nobel.swift
//  TimeMachine
//
//  Created by DH on 2/28/20.
//  Copyright © 2020 Retinal Media. All rights reserved.
//

import UIKit

internal struct Nobel: Codable {

    let id: Int
    let category: String
    let died: Date
    let diedcity: String
    let borncity: String
    let born: Date
    let surname: String
    let firstname: String
    let motivation: String
    let city: String
    let borncountry: String
    let diedcountry: String
    let country: String
    let gender: String
    let name: String
    let location: Location
    let year: Int
    let spaceTimePoint: SpaceTimePoint

    public enum CodingKeys: String, CodingKey {
        case id
        case category
        case died
        case diedcity
        case borncity
        case born
        case surname
        case firstname
        case motivation
        case city
        case borncountry
        case year
        case diedcountry
        case country
        case gender
        case name
        case location
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        category = try container.decode(String.self, forKey: .category)
        died = try container.decode(Date.self, forKey: .died)
        diedcity = try container.decode(String.self, forKey: .diedcity)
        borncity = try container.decode(String.self, forKey: .borncity)
        born = try container.decode(Date.self, forKey: .born)
        surname = try container.decode(String.self, forKey: .surname)
        firstname = try container.decode(String.self, forKey: .firstname)
        motivation = try container.decode(String.self, forKey: .motivation)
        city = try container.decode(String.self, forKey: .city)
        borncountry = try container.decode(String.self, forKey: .borncountry)
        year = Int(try container.decode(String.self, forKey: .year)) ?? 0
        diedcountry = try container.decode(String.self, forKey: .diedcountry)
        country = try container.decode(String.self, forKey: .country)
        gender = try container.decode(String.self, forKey: .gender)
        name = try container.decode(String.self, forKey: .name)
        location = try container.decode(Location.self, forKey: .location)
        spaceTimePoint = SpaceTimePoint(id: id,
                                        latitude: location.latitude,
                                        longitude: location.longitude,
                                        year: year,
                                        label:  "\(firstname) \(surname) (\(Int(year)))")
    }
    
}
