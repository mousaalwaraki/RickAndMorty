//
//  LocationsViewController.swift
//  RickAndMorty
//
//  Created by Mousa Alwaraki on 10/6/20.
//

import UIKit
import CoreData

class LocationsViewController: UIViewController {

    @IBOutlet weak var locationSearch: UISearchBar!
    @IBOutlet weak var locationTableView: UITableView!
    
    var locations = [Location]()
    var filterLocations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCoreData()
        
        locationTableView.delegate = self
        locationTableView.dataSource = self
        
        locationSearch.delegate = self
    }
    
    func save(location: LocationModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

      let managedContext = appDelegate.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "Location",
                                   in: managedContext)!
      
      let locationManagedObject = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
        locationManagedObject.setValue(location.dimension, forKey: "dimension")
        locationManagedObject.setValue(location.name, forKey: "name")
        locationManagedObject.setValue(location.residents, forKey: "residents")
        locationManagedObject.setValue(location.type, forKey: "type")
        
      do {
        try managedContext.save()
        locations.append(locationManagedObject as! Location)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    func fetchCoreData() {
        CoreDataManager().fetchData("Location") { [self] (returnedArray: [NSManagedObject]) in
            locations = returnedArray as! [Location]
            if locations.isEmpty {
                fetchAPIData()
            }
            filterLocations = locations
            locationTableView.reloadData()
        }
    }
    
    func fetchAPIData() {
        APIManager().fetchGenericPageData(name: "location") { [self] (numberOfLocationPages: LocationResults) in
            let numberOfPages = numberOfLocationPages.info?.pages
            
            APIManager().fetchGenericObjectData(name: "location", numberOfPages: numberOfPages ?? 0) { (jsonLocationArray: [LocationResults]) in
                for location in jsonLocationArray {
                    
                    for result in location.results {
                        DispatchQueue.main.async {
                            save(location: result!)
                        }
                    }
                }
                DispatchQueue.main.sync {
                    filterLocations = locations
                    locationTableView.reloadData()
                }
            }
        }
    }
}


extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
  
        cell.selectionStyle = .none
        cell.locationLabel.text = filterLocations[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = LocationDetailViewController(nibName: "LocationDetailViewController", bundle: nil)
        nextVC.location = filterLocations[indexPath.row]
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension LocationsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            filterLocations = locations.filter({($0.name?.lowercased().contains(searchText.lowercased()))!})
        } else {
            filterLocations = locations
        }
        locationTableView.reloadData()
    }
}
