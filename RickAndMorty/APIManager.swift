//
//  APIManager.swift
//  RickAndMorty
//
//  Created by Mousa Alwaraki on 10/10/20.
//

import Foundation
import UIKit

class APIManager {
    
    let baseUrl = "https://rickandmortyapi.com/api/"
    
    func fetchGenericPageData<T: Decodable>(name: String ,completion: @escaping (T) -> ()) {
        
        let urlString = baseUrl + name
        let url = URL(string: urlString)
        
        guard url != nil else {
            return
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                
                let decoder = JSONDecoder()
                
                do {
                    
                    let jsonData =  try decoder.decode(T.self, from: data!)

                    completion(jsonData)
                    
                } catch {
                    print("Error in JSON parsing: \(error)")
                }
            }
        }
        dataTask.resume()
    }
    
    func fetchGenericObjectData<T: Decodable>(name: String, numberOfPages: Int, completion: @escaping ([T]) -> ()) {
        
        var jsonArray: [T] = [T]()
        
        for page in 1...numberOfPages {
            let urlString = baseUrl + name + "/?page=\(page)"
            let url = URL(string: urlString)
            
            guard url != nil else {
                return
            }
            
            let session = URLSession.shared
            
            let dataTask = session.dataTask(with: url!) { (data, response, error) in
                
                if error == nil && data != nil {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let jsonData =  try decoder.decode(T.self, from: data!)
                        jsonArray.append(jsonData)
                        if page == numberOfPages {
                            completion(jsonArray)
                        }
                        
                    } catch {
                        print("Error in JSON parsing: \(error)")
                    }
                }
            }
            dataTask.resume()
        }
    }
}
