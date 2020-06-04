//
//  ListViewController.swift
//  TimeMachine
//
//  Created by DH on 2/28/20.
//  Copyright © 2020 Retinal Media. All rights reserved.
//

import UIKit

internal class ListViewController: UITableViewController {


    var parentVC: MainViewController? {
        return parent as? MainViewController
    }
    var nobels: [Nobel] {
        return parentVC?.nobels ?? []
    }


    private var searchResults: [SpaceTimePoint]?


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    func display(results: [SpaceTimePoint]) {
        searchResults = results
        tableView.reloadData()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchResults?.count ?? 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SpaceTimeCell", for: indexPath)
        if let cell = cell as? SpaceTimeCell,
           let stPoint = searchResults?[indexPath.row] {
                cell.point = stPoint
        }
        return cell
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let vc = segue.destination as? NobelDetailViewController,
            let ip = tableView.indexPathForSelectedRow,
            let nobelSTP = searchResults?[ip.row],
            let nobel = parentVC?.nobels?.first(where: {
                $0.spaceTimePoint == nobelSTP
            }) {
                vc.nobel = nobel
            }
    }
}
