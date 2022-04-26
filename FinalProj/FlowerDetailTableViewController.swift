//
//  FlowerDetailTableViewController.swift
//  FinalProj
//
//  Created by Rosemary Gellene on 4/25/22.
//

import UIKit
import MapKit
import GooglePlaces

class FlowerDetailTableViewController: UITableViewController {
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var flowerNameField: UITextField!
    @IBOutlet weak var locationNameField: UITextField!
    @IBOutlet weak var thoughtsTextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    var flower: Flower!
    let regionDistance: CLLocationDistance = 50_000 //50km
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if flower == nil {
            flower = Flower()
        }
        
        let region = MKCoordinateRegion(center: flower.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: true)
        
        updateUserInterface()
        
        // hide keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func updateUserInterface() {
        flowerNameField.text = flower.flowerName
        locationNameField.text = flower.locationName
        thoughtsTextView.text = flower.flowerDescription
        updateMap()
    }
    
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(flower)
        mapView.setCenter(flower.coordinate, animated: true)
    }
    
    func updateFromUserInterface() {
        flower.flowerName = flowerNameField.text!
        flower.locationName = locationNameField.text!
        flower.flowerDescription = thoughtsTextView.text
    }
    
    @IBAction func findLocationButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        flower.saveData { success in
            if success {
                self.leaveViewController()
            } else {
                print("ERROR: Couldn't leave this view controller because data wasn't saved.")
                      
            }
                      
        }
    }
                      
    
}

extension FlowerDetailTableViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    updateFromUserInterface()
    flower.locationName = place.name ?? "Unknown place"
    flower.coordinate = place.coordinate
    updateUserInterface()
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
}
