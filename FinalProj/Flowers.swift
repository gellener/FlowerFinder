//
//  Flowers.swift
//  FinalProj
//
//  Created by Rosemary Gellene on 4/25/22.
//

import Foundation
import Firebase

class Flowers {
    var flowerArray: [Flower] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ())  {
        db.collection("flowers").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.flowerArray = []
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                let flower = Flower(dictionary: document.data())
                flower.documentID = document.documentID
                self.flowerArray.append(flower)
            }
            completed()
        }
    }
}

