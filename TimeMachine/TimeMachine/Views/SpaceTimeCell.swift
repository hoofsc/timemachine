//
//  SpaceTimeCell.swift
//  TimeMachine
//
//  Created by DH on 2/28/20.
//  Copyright © 2020 Retinal Media. All rights reserved.
//

import UIKit

internal class SpaceTimeCell: UITableViewCell {

    var point: SpaceTimePoint? {
        didSet {
            guard let label = point?.label else { return }
            textLabel?.text = label
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .byWordWrapping
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
    }
}
