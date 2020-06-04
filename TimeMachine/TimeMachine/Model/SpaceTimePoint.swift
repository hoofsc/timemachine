//
//  SpaceTimePoint.swift
//  TimeMachine
//
//  Created by DH on 2/28/20.
//  Copyright © 2020 Retinal Media. All rights reserved.
//

import CoreLocation

internal struct SpaceTimePoint {
    let id: Int
    let latitude: Double
    let longitude: Double
    let year: Int
    let label: String

    func distanceTo(point: SpaceTimePoint) -> Double {
        let a = CLLocation(latitude: latitude, longitude: longitude)
        let b = CLLocation(latitude: point.latitude, longitude: point.longitude)
        let yearCost = Double(abs(Double(year) - Double(point.year)))
        let km = a.distance(from: b) / 1000.0
        let geoCost = km / 10
        return yearCost + geoCost
    }
}


extension SpaceTimePoint: KDTreePoint {
    static var dimensions: Int {
        return 3
    }

    func kdDimension(_ dimension: Int) -> Double {
        switch dimension {
        case 0:
            return latitude
        case 1:
            return longitude
        case 2:
            return Double(year)
        default:
            fatalError("SpaceTimePoint dimension[\(dimension) is not defined.")
        }
    }

    func squaredDistance(to otherPoint: SpaceTimePoint) -> Double {
        return pow(distanceTo(point: otherPoint), 2)
    }
}
