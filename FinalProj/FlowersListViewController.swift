//
//  FlowersListViewController.swift
//  FinalProj
//
//  Created by Rosemary Gellene on 4/25/22.
//

import UIKit
import CoreLocation

class FlowersListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var flowers: Flowers!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Flowers Found"
        
        flowers = Flowers()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        flowers.loadData {
            self.flowers.flowerArray.sort(by: {$0.flowerName < $1.flowerName})
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFlower" {
            let destination = segue.destination as! FlowerDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.flower = flowers.flowerArray[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
        
    }
}

extension FlowersListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flowers.flowerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = flowers.flowerArray[indexPath.row].flowerName
        cell.detailTextLabel?.text = flowers.flowerArray[indexPath.row].locationName
        return cell
    }
    
    
}
