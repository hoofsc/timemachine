//
//  MainViewController.swift
//  TimeMachine
//
//  Created by DH on 2/28/20.
//  Copyright © 2020 Retinal Media. All rights reserved.
//

import UIKit

let defaultPoint = SpaceTimePoint(id: -1,
                                  latitude: 37.4846,
                                  longitude: -122.1495,
                                  year: 2020,
                                  label: "Me")

enum DisplayType {
    case map
    case list
}

internal class MainViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!


    var nobels: [Nobel]?
    var kdTree: KDTree<SpaceTimePoint>?
    var searchResults: [SpaceTimePoint]?
    // start with default
    var givenPoint = defaultPoint

    private var displayType: DisplayType = .map
    private var mapViewController: MapViewController?
    private var listViewController: ListViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpChildren()
        setUpKDTree()
        performSearch()
    }


    @IBAction func segmentedControlDidChangeValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            displayType = .list
            mapViewController?.view.isHidden = true
            listViewController?.view.isHidden = false
            navigationItem.rightBarButtonItem?.isEnabled = false
        default:
            displayType = .map
            mapViewController?.view.isHidden = false
            listViewController?.view.isHidden = true
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }


    @objc
    private func handleUpdateInput() {
        switch displayType {
        case .map:
            mapViewController?.presentInputUI()
        case .list:
            break
        }
    }


    func performSearch() {
        guard let results = kdTreeSearch() else { return }
        display(results: results)
    }


    private func setUpNavBar() {
        title = "Time Machine"
        let inputBtn = UIBarButtonItem(title: "+",
                                        style: .done,
                                        target: self,
                                        action: #selector(handleUpdateInput))
        inputBtn.tintColor = .black
        navigationItem.rightBarButtonItem = inputBtn
    }

    private func setUpChildren() {
        guard let mapVC = storyboard?.instantiateViewController(identifier: "MapVC") as? MapViewController,
              let listVC = storyboard?.instantiateViewController(identifier: "ListVC") as? ListViewController else {
                return
        }
        listVC.willMove(toParent: self)
        containerView.addSubview(listVC.view)
        listVC.view.frame = containerView.bounds
        addChild(listVC)
        listVC.didMove(toParent: self)

        mapVC.willMove(toParent: self)
        addChild(mapVC)
        containerView.addSubview(mapVC.view)
        mapVC.view.frame = containerView.bounds
        mapVC.didMove(toParent: self)

        mapViewController = mapVC
        listViewController = listVC
    }

    private func setUpKDTree() {
        guard let nobels = loadNobels() else { return }
        let points = nobels.map({ return $0.spaceTimePoint })
        kdTree = KDTree(values: points)
        self.nobels = nobels
    }

    private func kdTreeSearch() -> [SpaceTimePoint]? {
        let searchResults: [SpaceTimePoint]? = kdTree?.nearestK(20, to: givenPoint)
        return searchResults
    }

    private func loadNobels() -> [Nobel]? {
       guard let path = Bundle.main.path(forResource: "nobel-prize-laureates", ofType: "json") else {
           return nil
       }
       let url = URL(fileURLWithPath: path)
       guard let data = try? Data(contentsOf: url) else { return nil }
       let decoder = JSONDecoder()
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-mm-dd"
       decoder.dateDecodingStrategy = .formatted(formatter)
       let nobels = try? decoder.decode([Nobel].self, from: data)
       return nobels
    }

    private func display(results: [SpaceTimePoint]) {
        mapViewController?.display(results: results)
        listViewController?.display(results: results)
    }
}
