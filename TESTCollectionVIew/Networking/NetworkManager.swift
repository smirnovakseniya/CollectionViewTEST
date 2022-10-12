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
    
    let cache = NSCache<NSNumber, UIImage>()
    
    //MARK: - Functions
    
    func getImages(successBlock: @escaping ([Result]) -> Void, errorBlock: @escaping (Error) -> Void) {
        let APIkey = "9oHpOxwR0PAzJrgPuBdadtrGwAAwT4-OTt5cBu-IoHU"
        let url = "https://api.unsplash.com/search/photos?page=7&query=office&client_id=\(APIkey)"
        
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                let result = jsonResult.results
                successBlock(result)
            } catch {
                errorBlock(error)
            }
        }.resume()
    }
    
    func downloadImage(urlString: String, row: Int, success: @escaping (Int, UIImage) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                guard let image = UIImage(data: data) else { return }
                self.cache.setObject(image, forKey: row as NSNumber)
                success(row, image)
            }
        }.resume()
    }
}
