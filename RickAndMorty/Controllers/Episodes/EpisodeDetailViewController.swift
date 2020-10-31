//
//  EpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Mousa Alwaraki on 10/7/20.
//

import UIKit
import CoreData

class EpisodeDetailViewController: UIViewController {
    
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var seasonAndEpisodeLabel: UILabel!
    @IBOutlet weak var dateAiredLabel: UILabel!
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    
    var episode: Episode?
    var characters: [Character?] = [Character?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charactersCollectionView.delegate = self
        charactersCollectionView.dataSource = self
        
        charactersCollectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ResidentCell")
        
        fillLabels()
        
        DispatchQueue.main.async {
            self.fetchCoreData()
        }
    }
    
    func fillLabels() {
        episodeNameLabel.text = episode?.name
        seasonAndEpisodeLabel.text = episode?.episode
        dateAiredLabel.text = "Date aired: " + (episode?.air_date)!
    }
    
    func fetchCoreData() {
        CoreDataManager().fetchData("Character") { [self] (returnedArray: [NSManagedObject]) in
            characters = returnedArray as! [Character]
            characters = characters.filter({($0?.episode?.contains((episode?.url)!))!})
            charactersCollectionView.reloadData()
        }
    }
}

extension EpisodeDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResidentCell", for: indexPath) as! CharacterCollectionViewCell
        let url = URL(string: (characters[indexPath.row]?.image)!)
        let image = UIImage(named: "placeholder")
        cell.characterImageView.kf.setImage(with: url, placeholder: image)
        cell.characterNameLabel.text = characters[indexPath.row]!.name!
        cell.characterImageView.layer.cornerRadius = 6
        
        return cell
    }
}

extension EpisodeDetailViewController: UICollectionViewDelegateFlowLayout {
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
