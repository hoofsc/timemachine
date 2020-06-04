//
//  MapViewController.swift
//  TimeMachine
//
//  Created by DH on 2/28/20.
//  Copyright © 2020 Retinal Media. All rights reserved.
//

import UIKit
import MapKit

internal class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!


    var parentVC: MainViewController? {
        return parent as? MainViewController
    }
    var defaultRegion: MKCoordinateRegion {
        let centerCoord = CLLocationCoordinate2D(latitude: defaultPoint.latitude, longitude: defaultPoint.longitude)
        // adjust this for UX -- based on bounds of results
        let span = MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 1.5)
        return MKCoordinateRegion(center: centerCoord, span: span)
    }
    var inputAnnotation: MKPointAnnotation?
    var selectedSTPAnnotation: STPAnnotation?


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAppearance()
        setUpMapView()
        setUpDatePicker()
    }


    @IBAction func handleInputSearch() {
        guard let inputAnnotation = inputAnnotation else { return }
        dismissInputUI()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: datePicker.date)
        let inputPoint = SpaceTimePoint(id: -1,
                                        latitude: inputAnnotation.coordinate.latitude,
                                        longitude: inputAnnotation.coordinate.longitude,
                                        year: year,
                                        label: "Me")
        parentVC?.givenPoint = inputPoint
        parentVC?.performSearch()
    }

    @IBAction func handleInputCancel() {
        dismissInputUI()
    }


    func display(results: [SpaceTimePoint]) {
        mapView.removeAnnotations(mapView.annotations)
        let annotations = results
                            .map({ stp -> (SpaceTimePoint, CLLocationCoordinate2D) in
                                return (stp, CLLocationCoordinate2D(latitude: stp.latitude, longitude: stp.longitude))
                            }).map({ (point, coordinate) -> MKAnnotation in
                                let annotation = STPAnnotation(point: point)
                                annotation.coordinate = coordinate
                                return annotation
                            })
        mapView.addAnnotations(annotations)
    }

    func presentInputUI() {
        if let inputAnnotation = inputAnnotation {
            mapView.removeAnnotation(inputAnnotation)
        }
        let anno = MKPointAnnotation()
        anno.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(anno)
        inputAnnotation = anno
        inputViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    func dismissInputUI() {
        inputViewBottomConstraint.constant = -1.0 * userInputView.bounds.height
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        if let inputAnnotation = inputAnnotation {
            mapView.removeAnnotation(inputAnnotation)
        }
    }


    private func setUpAppearance() {
        datePicker.backgroundColor = .white
        inputViewBottomConstraint.constant = -1.0 * userInputView.bounds.height
    }

    private func setUpMapView() {
        mapView.delegate = self
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "space_time_point_anno")
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "input_coord_anno")
        mapView.setRegion(defaultRegion, animated: true)
    }

    private func setUpDatePicker() {
        datePicker.maximumDate = Date()
    }
}


extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let anno = annotation as? STPAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "space_time_point_anno", for: anno)
            view.annotation = annotation
            view.clusteringIdentifier = "space_time_point_cluster"
            view.displayPriority = .defaultHigh
            return view
        }
        if let anno = annotation as? MKPointAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "input_coord_anno", for: anno)
            view.annotation = annotation
            view.image = UIImage(systemName: "plus.circle")
            view.displayPriority = .required
            if let userInputView = userInputView {
                view.centerOffset = CGPoint(x: 0, y: -1.0 * userInputView.bounds.height / 2.0)
            }
            return view
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard let inputAnnotation = inputAnnotation else { return }
        inputAnnotation.coordinate = mapView.centerCoordinate
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let anno = view.annotation as? STPAnnotation else { return }
        selectedSTPAnnotation = anno
    }
}
