//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Mousa Alwaraki on 10/6/20.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterImage.layer.cornerRadius = 6
        
        guard let character = character else {
            return
        }
        
        let url = URL(string: character.image!)
        characterImage.kf.setImage(with: url)
        
        characterName.text = character.name
        
        if let characterStatus = character.status {
            statusLabel.text = "\(character.name ?? "") is \(characterStatus)"
        }
        if let characterGender = character.gender {
            genderLabel.text = "Gender: " + ((characterGender as? String)!)
        }

        speciesLabel.text = "Species: \(character.species ?? "")"
        originLabel.text = "Origin: \(character.origin ?? "" as NSObject)"
        locationLabel.text = "Last known location: \(character.location ?? "" as NSObject)"
    }
}
