//
//  MainVCModel.swift
//  TESTCollectionVIew
//
//  Created by Kseniya Smirnova on 9.10.22.
//

import UIKit

//MARK: - Protocol

protocol MainVCDelegate: AnyObject {
    func reloadCollectionView()
    func reloadItem(_ row: Int)
    func errorMessage(_ text: String)
}

class MainVCModel {
    
    struct ImageSize {
        let height: Int
        let width: Int
    }
    
    //MARK: - Variables
    
    weak var delegate: MainVCDelegate?
    
    private var results: [Result] = []
    private var allImageArray: [Image] = []
    private var defaultPrices: [String : Double] = [:]
    private var counter: Int = 0
    
    //MARK: - Functions
    
    func getImages() {
        if Reachability.isConnected() {
            NetworkManager.shared.getImages { [weak self] result in
                result.forEach( { self?.allImageArray.append(Image(results: $0)) } )
                self?.results = result
                self?.delegate?.reloadCollectionView()
            } errorBlock: { error in
                print(error.localizedDescription)
                self.delegate?.errorMessage("Something went wrong")
            }
        } else {
            delegate?.errorMessage("Check your internet connection")
        }
    }
    
    func setCell(row: Int) -> ImageCollectionViewCell.ResultCell {
        let result = results[row]
        return ImageCollectionViewCell.ResultCell(row: row,
                                                  counter: counter,
                                                  results: results,
                                                  result: result,
                                                  name: userName(row),
                                                  urlString: result.urls.regular,
                                                  priceDownload: defaultPrices[result.user.username] ?? 0,
                                                  allImageArray: allImageArray,
                                                  resultCount: resultsCount(),
                                                  paid: allImageArray[row].paid
        )
    }
    
    func resultsCount() -> Int {
        return results.count
    }
    
    func userName(_ row: Int) -> String {
        return results[row].user.username
    }
    
    func imageSize(_ row: Int) -> ImageSize {
        return ImageSize(height: results[row].height, width: results[row].width)
    }
    
    func price(name: String, row: Int) {
        //имитация отправки запроса цены и получение её с задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.defaultPrices[name] = pricesResponse[name] ?? 0
            if self.counter < self.results.count {
                self.counter += 1
                if self.counter == self.results.count {
                    self.delegate?.reloadCollectionView()
                }
            }
        }
    }
    
    func purchases(_ row: Int) {
        allImageArray[row].paid = true
        delegate?.reloadItem(row)
    }
    
    func purchased(_ row: Int) -> Bool {
        if counter == resultsCount() {
            if !allImageArray[row].paid {
                IAPManager.shared.purchase(product: Product(rawValue: userName(row))) { [weak self] _ in
                    self?.purchases(row)
                }
                return true
            }
        }
        return false
    }
}
