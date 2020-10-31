//
//  CharactersViewController.swift
//  RickAndMorty
//
//  Created by Mousa Alwaraki on 10/6/20.
//

import UIKit
import CoreData
import Kingfisher

class CharactersViewController: UIViewController {
    
    @IBOutlet weak var charactersCollectionView: UICollectionView!
    @IBOutlet weak var charactersSearchBar: UISearchBar!
    @IBOutlet weak var charactersFilterButton: UIButton!
    @IBOutlet weak var darkBgView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var lifeStatusSegmentedControl: UISegmentedControl!
    
    var characters = [Character]()
    var filterCharacters = [Character]()
    
    var genderFilter: Gender?
    var lifeStatusFilter: LifeStatus?
    var numberOfCells = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        fetchCoreData()
        
        addBlurEffectToDarkView()
        
        charactersCollectionView.delegate = self
        charactersCollectionView.dataSource = self
        
        charactersSearchBar.delegate = self
        
        charactersCollectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ResidentCell")
        
        hideFilterCard()
    }
    
    @IBAction func charactersFilterButtonTapped(_ sender: Any) {
        showFilterCard()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        hideFilterCard()
        asyncReloadCollectionView()
    }
    
    @IBAction func confirmFilterTapped(_ sender: Any) {
        switch genderSegmentedControl.selectedSegmentIndex {
        case 0:
            genderFilter = .male
        case 1:
            genderFilter = .female
        default:
            genderFilter = nil
        }
        
        switch lifeStatusSegmentedControl.selectedSegmentIndex {
        case 0:
            lifeStatusFilter = .alive
        case 1:
            lifeStatusFilter = .dead
        default:
            lifeStatusFilter = nil
        }
        
        hideFilterCard()
        filterCharacters(gender: genderFilter, lifeStatus: lifeStatusFilter)
        
        let indexPath = IndexPath(item: 0, section: 0)
        charactersCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        
        numberOfCells = min(50, filterCharacters.count)
        
        asyncReloadCollectionView()
    }
    
    
    func save(character: CharacterModel) {
      
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

      let managedContext = appDelegate.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "Character",
                                   in: managedContext)!
      
      let characterManagedObject = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
        characterManagedObject.setValue(character.episode, forKey: "episode")
        characterManagedObject.setValue(character.gender?.rawValue, forKey: "gender")
        characterManagedObject.setValue(character.origin?.name, forKey: "origin")
        characterManagedObject.setValue(character.location?.name, forKey: "location")
        characterManagedObject.setValue(character.image, forKey: "image")
        characterManagedObject.setValue(character.name, forKey: "name")
        characterManagedObject.setValue(character.species, forKey: "species")
        characterManagedObject.setValue(character.status?.rawValue, forKey: "status")
        characterManagedObject.setValue(character.type, forKey: "type")
        
      do {
        try managedContext.save()
        characters.append(characterManagedObject as! Character)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    func fetchCoreData() {
        CoreDataManager().fetchData("Character") { [self] (returnedArray: [NSManagedObject]) in
            characters = returnedArray as! [Character]
            if characters.isEmpty {
                fetchAPIData()
            } else {
                numberOfCells = 50
            }
            filterCharacters = characters
            asyncReloadCollectionView()
        }
    }
    
    func fetchAPIData() {
        APIManager().fetchGenericPageData(name: "character") { [self] (numberOfCharcterPages: CharacterResults) in
            let numberOfPages = numberOfCharcterPages.info?.pages

            APIManager().fetchGenericObjectData(name: "character", numberOfPages: numberOfPages ?? 0) { [self] (jsonCharacterArray: [CharacterResults]) in
                
                for character in jsonCharacterArray {
                    
                    for result in character.results {
                        DispatchQueue.main.async {
                            save(character: result)
                        }
                    }
                }
                DispatchQueue.main.sync {
                    numberOfCells = 50
                    filterCharacters = characters
                    asyncReloadCollectionView()
                }
            }
        }
    }
    
    func filterCharacters(gender: Gender? = nil, lifeStatus: LifeStatus? = nil) {
        
        filterCharacters = characters
        
        filterArrayWithSearchValue()
        
        if let gender = gender {
            filterCharacters = filterCharacters.filter({Gender(rawValue: $0.gender! as! String) == gender})
        }
        
        if let lifeStatus = lifeStatus {
            filterCharacters = filterCharacters.filter({LifeStatus(rawValue: $0.status! as! String) == lifeStatus})
        }
        asyncReloadCollectionView()
    }
    
    func hideFilterCard() {
        UIView.animate(withDuration: 0.3) { [self] in
            darkBgView.alpha = 0
            filterView.alpha = 0
        }
    }
    
    func filterArrayWithSearchValue() {
        if charactersSearchBar.text != "" {
            filterCharacters = filterCharacters.filter({($0.name?.lowercased().contains(charactersSearchBar.text?.lowercased() ?? "") ?? false)})
        }
    }
    
    func showFilterCard() {
        filterView.layer.cornerRadius = 12
        
        UIView.animate(withDuration: 0.3) { [self] in
            darkBgView.alpha = 0.75
            filterView.alpha = 1
        }
        
        switch genderFilter  {
        case .male:
            genderSegmentedControl.selectedSegmentIndex = 0
        case .female:
            genderSegmentedControl.selectedSegmentIndex = 1
        default:
            genderSegmentedControl.selectedSegmentIndex = 2
        }
        
        switch lifeStatusFilter {
        case .alive:
            lifeStatusSegmentedControl.selectedSegmentIndex = 0
        case .dead:
            lifeStatusSegmentedControl.selectedSegmentIndex = 1
        default:
            lifeStatusSegmentedControl.selectedSegmentIndex = 2
        }
    }
    
    func asyncReloadCollectionView() {
        DispatchQueue.main.async {
            self.charactersCollectionView.reloadData()
        }
    }
    
    func addBlurEffectToDarkView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = darkBgView.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        darkBgView.addSubview(blurEffectView)
        darkBgView.sendSubviewToBack(blurEffectView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !filterView.frame.contains(location) {
            hideFilterCard()
        }
    }
}

extension CharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResidentCell", for: indexPath) as! CharacterCollectionViewCell
                
        cell.characterNameLabel.text = filterCharacters[indexPath.row].name
        let url = URL(string: (filterCharacters[indexPath.row].value(forKey: "image"))! as! String)
        let image = UIImage(named: "placeholder")
        cell.characterImageView.kf.setImage(with: url, placeholder: image)
        cell.characterImageView.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = CharacterDetailViewController(nibName: "CharacterDetailViewController", bundle: nil)
        nextVC.character = filterCharacters[indexPath.row]
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == numberOfCells - 6 {
            numberOfCells = min(filterCharacters.count, numberOfCells + 20)
            asyncReloadCollectionView()
        }
    }
}

extension CharactersViewController: UICollectionViewDelegateFlowLayout {
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

extension CharactersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterCharacters = characters
        filterCharacters(gender: genderFilter, lifeStatus: lifeStatusFilter)
        
        filterArrayWithSearchValue()

        numberOfCells = min(50, filterCharacters.count)
        
        asyncReloadCollectionView()
    }
}

enum Gender: String, Codable {
    case male = "Male"
    case female = "Female"
    case genderLesss = "Genderless"
    case unknown = "unknown"
}

enum LifeStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}
