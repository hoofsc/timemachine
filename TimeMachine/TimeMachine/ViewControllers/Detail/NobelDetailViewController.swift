//
//  NobelDetailViewController.swift
//  TimeMachine
//
//  Created by DH on 3/2/20.
//  Copyright © 2020 Retinal Media. All rights reserved.
//

import UIKit
import MapKit

internal class NobelDetailViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var motivation: UILabel!


    var nobel: Nobel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nobel = nobel else { return }
        titleLabel.text = "\(nobel.firstname) \(nobel.surname)"
        subtitleLabel.text = "\(nobel.year)"
        category.text = nobel.category
        motivation.text = nobel.motivation
        setUpStackView()
        setUpMapView()
        displayMapView()
    }


    private func setUpStackView() {
        stackView.setCustomSpacing(20.0, after: subtitleLabel)
    }

    private func setUpMapView() {
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "nobel_anno")
        mapView.isUserInteractionEnabled = false
    }

    private func displayMapView() {
        guard let centerLat = nobel?.location.latitude,
              let centerLng = nobel?.location.longitude else  {
                return
        }
        let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLng)
        setRegion(with: center)
        let anno = MKPointAnnotation()
        anno.coordinate = center
        mapView.addAnnotation(anno)
    }

    private func setRegion(with center: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
}
