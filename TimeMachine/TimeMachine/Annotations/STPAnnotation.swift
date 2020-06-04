//
//  STPAnnotation.swift
//  TimeMachine
//
//  Created by DH on 2/28/20.
//  Copyright © 2020 Retinal Media. All rights reserved.
//

import UIKit
import MapKit

final class STPAnnotation: MKPointAnnotation {
    let id: Int
    var point: SpaceTimePoint

    init(point: SpaceTimePoint) {
        id = point.id
        self.point = point
        super.init()
        title = point.label
    }
}
