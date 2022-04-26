//
//  FlowerFactViewController.swift
//  FinalProj
//
//  Created by Rosemary Gellene on 4/26/22.
//

import UIKit
import AVFoundation

class FlowerFactViewController: UIViewController {
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var factButton: UIButton!
    
    var factNumber = -1
    var soundNumber = -1
    let totalNumberOfFacts = 15
    let totalNumberOfSounds = 3
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        factLabel.text = ""
    }
    
    func playSound(name: String) {
        if let sound = NSDataAsset(name: name) {
            do {
                try audioPlayer = AVAudioPlayer(data: sound.data)
                audioPlayer.play()
            } catch {
                print("ERROR: \(error.localizedDescription) Could not initialize AVAudioPlayer object.")
            }
            
        } else {
            print("ERROR: Could not read data from file sound0")
        }
    }
    
    func nonRepeatingRandom(originalNumber: Int, upperLimit: Int) -> Int {
        var newNumber: Int
        repeat {
            newNumber = Int.random(in: 0...upperLimit)
        } while originalNumber == newNumber
        return newNumber
    }
    
    
    @IBAction func factButtonPressed(_ sender: UIButton) {
        let facts = ["The largest flower in the world can be up to ten feet tall and three feet wide, and it can weigh up to 24 pounds! It is called the Titan Arum and it has a distinctive smell of rotting flesh, hence why it is also known as the corpse flower.", "The smallest flower in the world is the Wolffia globosa or Watermeal. This tiny green plant is the size of a grain of rice, and the flower is located in a small hole in the surface of the plant.", "In the US, almost 60% of all freshly cut flowers are grown in California.", "The heads of sunflowers move throughout the day to follow the route of the sun from the east to the west.", " Moon flowers are called that because they bloom only at night and close during the day.", "There are more than 400,000 plants which flower in the world, but many have not been discovered yet so that number is likely to be higher.", "Bamboos are a flowering plant, but it only flowers every few years.", "The most expensive flower ever sold is a Shenzhen Nongke Orchid. It took eight years to develop and it only blooms once every four to five years, but it was sold for $200,000 at an auction!", "Lilies are beautiful flowers, but they are highly toxic for cats.", "The nice scent of roses comes from microscopic perfume glands on their petals.", "There exists a variety of flower called the Chocolate Cosmos which actually smells like chocolate!", "The nature of the soil it grows in, such as its acidity level, determines the colour of hydrangeas. If the soil is less acidic the flower will be pink, and the more acidic it is the bluer the flower!", "The agave is known as a monocarpic plant, meaning it can stay dormant for years and only blooms once and then dies.", "Scientists managed to resurrect a 32,000 years old Arctic flower in Siberia by using seeds buried by an Ice Age squirrel.", "Vanilla flowers are really delicate: they only open for a couple of hours at a time and need to be pollinated by hand to produce a vanilla bean."]
        
        factNumber = nonRepeatingRandom(originalNumber: factNumber, upperLimit: facts.count-1)
        factLabel.text = facts[factNumber]
        
        soundNumber = nonRepeatingRandom(originalNumber: soundNumber, upperLimit: totalNumberOfSounds-1)
        print("*** The new sound number is \(soundNumber)")
        playSound(name: "sound\(soundNumber)")
    }
}
