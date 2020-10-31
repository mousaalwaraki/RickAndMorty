//
//  LocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Mousa Alwaraki on 10/7/20.
//

import UIKit
import Kingfisher
import CoreData

class LocationDetailViewController: UIViewController {

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimensionLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var residentsCollectionView: UICollectionView!
    @IBOutlet weak var currentResidentsLabel: UILabel!
    
    var location: Location?
    var characters: [Character] = [Character]()

    override func viewDidLoad() {
        super.viewDidLoad()

        residentsCollectionView.delegate = self
        residentsCollectionView.dataSource = self
        
        residentsCollectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ResidentCell")
        
        fillLabels()
        
        DispatchQueue.main.async {
            self.fetchCoreData()
        }
    }
    
    func fetchCoreData() {
        CoreDataManager().fetchData("Character") { [self] (returnedArray: [NSManagedObject]) in
            characters = returnedArray as! [Character]
            characters = characters.filter({$0.location as? String == location?.name})
            residentsCollectionView.reloadData()
        }
    }
    
    func fillLabels() {
        locationNameLabel.text = location?.name
        typeLabel.text = location?.type
        
        if location?.dimension == "unknown" {
            dimensionLabel.text = "Dimesnion: Unknown"
        } else {
            dimensionLabel.text = location?.dimension!
        }
    }
}

extension LocationDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResidentCell", for: indexPath) as! CharacterCollectionViewCell
        let url = URL(string: (characters[indexPath.row].image)!)
        let image = UIImage(named: "placeholder")
        cell.characterImageView.kf.setImage(with: url, placeholder: image)
        cell.characterNameLabel.text = characters[indexPath.row].name!
        cell.characterImageView.layer.cornerRadius = 6

        return cell
    }
}

extension LocationDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                            collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
}
