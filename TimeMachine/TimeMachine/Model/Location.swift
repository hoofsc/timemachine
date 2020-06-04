//
//  Location.swift
//  TimeMachine
//
//  Created by DH on 2/28/20.
//  Copyright © 2020 Retinal Media. All rights reserved.
//

import UIKit

internal struct Location: Codable {
    let latitude: Double
    let longitude: Double

    public enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
    }
}
