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
    var flowerImage: UIImage
    var flowerImageUUID: String
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
        return ["flowerName": flowerName, "locationName": locationName, "latitude": latitude, "longitude": longitude, "flowerDescription": flowerDescription, "flowerImageUUID": flowerImageUUID, "createdOn": timeIntervalDate, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    init(flowerName: String, locationName: String, coordinate: CLLocationCoordinate2D, flowerDescription: String, flowerImage: UIImage, flowerImageUUID: String, createdOn: Date, postingUserID: String, documentID: String) {
        self.flowerName = flowerName
        self.locationName = locationName
        self.coordinate = coordinate
        self.flowerDescription = flowerDescription
        self.flowerImage = flowerImage
        self.flowerImageUUID = flowerImageUUID
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
        let flowerImageUUID = dictionary["flowerImageUUID"] as! String? ?? ""
        let timeIntervalDate = dictionary["createdOn"] as! TimeInterval? ?? TimeInterval()
        let createdOn = Date(timeIntervalSince1970: timeIntervalDate)
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        self.init(flowerName: flowerName, locationName: locationName, coordinate: coordinate, flowerDescription: flowerDescription, flowerImage: UIImage(), flowerImageUUID: flowerImageUUID, createdOn: createdOn, postingUserID: postingUserID, documentID: "")
    }
    
    convenience override init() {
        self.init(flowerName: "", locationName: "", coordinate: CLLocationCoordinate2D(), flowerDescription: "", flowerImage: UIImage(), flowerImageUUID: "", createdOn: Date(), postingUserID: "", documentID: "")
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
    
    func saveImage(completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        //convert flowerImage to a datatype that Firebase can save
        guard let imageToSave = self.flowerImage.jpegData(compressionQuality: 0.5) else {
            print("ERROR: could not convert image to data format")
            return completed(false)
        }
        
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        if flowerImageUUID == "" {
            //if there is no UUID we will create one
            flowerImageUUID = UUID().uuidString
        }
        //create a ref to upload storage w new UUID
        let storageRef = storage.reference().child(documentID).child(self.flowerImageUUID)
        let uploadTask = storageRef.putData(imageToSave, metadata: uploadMetadata) { metadata, error in
            guard error == nil else {
                print("ERORR: during .putData storage upload for reference \(storageRef). Error = \(error?.localizedDescription ?? "<unknown error>")")
                return completed(false)
            }
            print("Upload worked. Metadata = \(metadata)")
        }
        
        uploadTask.observe(.success) { snapshot in
            //create dict representing data to save
            let dataToSave = self.dictionary
            let ref = db.collection("flowers").document(self.documentID)
            ref.setData(dataToSave) { error in
                if let error = error {
                    print("ERROR: saving document \(self.documentID) in success observer")
                    completed(false)
                } else {
                    print("Document update with ref id \(ref.documentID)")
                    completed(true)
                }
            }
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                print("ERROR: \(error.localizedDescription) upload task for file \(self.flowerImageUUID)")
            }
            return completed(false)
        }
    }
}
