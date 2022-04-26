//
//  Flower.swift
//  FinalProj
//
//  Created by Rosemary Gellene on 4/25/22.
//

import Foundation
import CoreLocation
import Firebase
import MapKit

class Flower: NSObject, MKAnnotation {
    var flowerName: String
    var locationName: String
    var coordinate: CLLocationCoordinate2D
    var flowerDescription: String
    var createdOn: Date
    var postingUserID: String
    var documentID: String
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var title: String? {
        return flowerName
    }
    
    var subtitle: String? {
        return locationName
    }
    
    var dictionary: [String: Any] {
        let timeIntervalDate = createdOn.timeIntervalSince1970
        return ["flowerName": flowerName, "locationName": locationName, "latitude": latitude, "longitude": longitude, "flowerDescription": flowerDescription, "createdOn": timeIntervalDate, "postingUserID": postingUserID, "documentID": documentID]
    }
    
                init(flowerName: String, locationName: String, coordinate: CLLocationCoordinate2D, flowerDescription: String, createdOn: Date, postingUserID: String, documentID: String) {
        self.flowerName = flowerName
        self.locationName = locationName
        self.coordinate = coordinate
        self.flowerDescription = flowerDescription
        self.createdOn = createdOn
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init(dictionary: [String: Any]) {
        let flowerName = dictionary["flowerName"] as! String? ?? ""
        let locationName = dictionary["locationName"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let flowerDescription = dictionary["flowerDescription"] as! String? ?? ""
        let timeIntervalDate = dictionary["createdOn"] as! TimeInterval? ?? TimeInterval()
        let createdOn = Date(timeIntervalSince1970: timeIntervalDate)
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
            self.init(flowerName: flowerName, locationName: locationName, coordinate: coordinate, flowerDescription: flowerDescription, createdOn: createdOn, postingUserID: postingUserID, documentID: "")
    }
     
    convenience override init() {
            self.init(flowerName: "", locationName: "", coordinate: CLLocationCoordinate2D(), flowerDescription: "", createdOn: Date(), postingUserID: "", documentID: "")
    }
     
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab the user id
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("😡 ERROR: Could not save data because we don't have a valid postingUserID.")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID, otherwise .addDocument will create one
        if self.documentID == "" {
            var ref: DocumentReference? = nil // Firestore will create a new ID for us
            ref = db.collection("flowers").addDocument(data: dataToSave){ error in
                guard error == nil else {
                    print("😡 ERROR: Adding document \(error!.localizedDescription).")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("😀 Added document \(self.documentID) to the cloud. It worked!")
                completion(true)
            }
        } else { // else save to the existing document id with .setData
            let ref = db.collection("flowers").document(self.documentID)
            ref.setData(dataToSave) { error in
                guard error == nil else {
                    print("😡 ERROR: Updating document \(error!.localizedDescription).")
                    return completion(false)
                }
                print("😀 Updated document \(self.documentID) to the cloud. It worked!")
                completion(true)
            }
        }
        
    }
}
