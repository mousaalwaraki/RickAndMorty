//
//  EpisodesViewController.swift
//  RickAndMorty
//
//  Created by Mousa Alwaraki on 10/7/20.
//

import UIKit
import CoreData

class EpisodesViewController: UIViewController {

    @IBOutlet weak var episodesSearchBar: UISearchBar!
    @IBOutlet weak var episodesTableView: UITableView!
    
    var episodes = [Episode]()
    var filterEpisodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCoreData()
        
        episodesTableView.delegate = self
        episodesTableView.dataSource = self
        
        episodesSearchBar.delegate = self
    }
    
    func save(episode: EpisodeModel) {
      
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

      let managedContext = appDelegate.persistentContainer.viewContext
      
      let entity = NSEntityDescription.entity(forEntityName: "Episode",
                                   in: managedContext)!
      
      let episodeManagedObject = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
        episodeManagedObject.setValue(episode.air_date, forKey: "air_date")
        episodeManagedObject.setValue(episode.characters, forKey: "characters")
        episodeManagedObject.setValue(episode.episode, forKey: "episode")
        episodeManagedObject.setValue(episode.name, forKey: "name")
        episodeManagedObject.setValue(episode.url, forKey: "url")
        
      do {
        try managedContext.save()
        episodes.append(episodeManagedObject as! Episode)
      } catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    func fetchCoreData() {
        CoreDataManager().fetchData("Episode") { [self] (returnedArray: [NSManagedObject]) in
            episodes = returnedArray as! [Episode]
            if episodes.isEmpty {
                fetchAPIData()
            }
            filterEpisodes = episodes
            episodesTableView.reloadData()
        }
    }
    
    func fetchAPIData() {
        APIManager().fetchGenericPageData(name: "episode") { [self] (numberOfLocationPages: EpisodeResults) in
            let numberOfPages = numberOfLocationPages.info?.pages
            
            APIManager().fetchGenericObjectData(name: "episode", numberOfPages: numberOfPages ?? 0) { (jsonEpisodeArray: [EpisodeResults]) in
                for episode in jsonEpisodeArray {
                    
                    for result in episode.results {
                        DispatchQueue.main.async {
                            save(episode: result!)
                        }
                    }
                }
                DispatchQueue.main.sync {
                    filterEpisodes = episodes
                    episodesTableView.reloadData()
                }
            }
        }
    }
}

extension EpisodesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterEpisodes.filter({($0.episode?.contains("S0\(section + 1)"))!}).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath) as! LocationTableViewCell
        let seasonNumber = "S0\(indexPath.section + 1)"
        let season = filterEpisodes.filter({($0.episode?.contains(seasonNumber))!})[indexPath.row]
        
        cell.selectionStyle = .none
        cell.locationLabel.text = (season.episode)! + " " + (season.name)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if filterEpisodes.filter({($0.episode?.contains("S0\(section + 1)"))!}).count == 0 {
            return 0
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        headerView.tintColor = .secondarySystemBackground
        
        let label = UILabel(frame: CGRect(x: 25, y: 10, width: view.frame.width - 32, height: 30))
        label.text = "Season 0\(section + 1)"
        label.textColor = .secondaryLabel
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = EpisodeDetailViewController(nibName: "EpisodeDetailViewController", bundle: nil)
        let seasonNumber = "S0\(indexPath.section + 1)"
        nextVC.episode = filterEpisodes.filter({($0.episode?.contains(seasonNumber))!})[indexPath.row]
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension EpisodesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            filterEpisodes = episodes.filter({($0.name?.lowercased().contains(searchText.lowercased()))!})
        } else {
            filterEpisodes = episodes
        }
        episodesTableView.reloadData()
    }
}
