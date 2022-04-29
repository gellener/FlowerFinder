//
//  ExploreViewController.swift
//  FinalProj
//
//  Created by Rosemary Gellene on 4/28/22.
//

import UIKit

class ExploreViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    
    let totalPlaces = 9
    var currentPlace = 0
    let places = ["Blue Ridge Mountains, North Carolina", "Lisse, Netherlands", "Akureyri, Iceland", "Route 1, California", "Carmona, Spain", "Glacier National Park, Montana", "Tokyo, Japan", "Washington, D.C.", "Umm Qais, Jordan", "Central Nepal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeLabel.text = places[currentPlace]
        imageView.image = UIImage(named: "image\(currentPlace)")
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        currentPlace += 1
        placeLabel.text = places[currentPlace]
        imageView.image = UIImage(named: "image\(currentPlace)")
        if currentPlace == totalPlaces {
            currentPlace = 0
            placeLabel.text = places[currentPlace]
            imageView.image = UIImage(named: "image\(currentPlace)")
        }
    }
    
}
