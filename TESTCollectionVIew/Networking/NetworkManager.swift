//
//  NetworkManager.swift
//  TESTCollectionVIew
//
//  Created by Kseniya Smirnova on 5.10.22.
//

import UIKit

class NetworkManager {
    
    //MARK: - Variables

    static let shared = NetworkManager()
    
    let group = DispatchGroup()
    
     let cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    //MARK: - Functions
    
    func getImages(succesBlock: @escaping ([Result]) -> Void) {
        let key = "9oHpOxwR0PAzJrgPuBdadtrGwAAwT4-OTt5cBu-IoHU"
        let url = "https://api.unsplash.com/search/photos?page=7&query=office&client_id=\(key)"
        
        guard let url = URL(string: url) else { return }
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }

            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                let result = jsonResult.results
                succesBlock(result)
            } catch {
                print("Error! Could not decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func downloadImage(urlString: String, index: Int, success: @escaping (Int, UIImage) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                guard let image = UIImage(data: data) else { return }
                self.cache.setObject(image, forKey: index as NSNumber)
                success(index, image)
            }
        }.resume()
    }
}
