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
    func reloadItem(row: Int)
}

class MainVCModel {
    
    //MARK: - Struct
    
    struct SizeImage {
        let height: Int
        let width: Int
    }
    
    //MARK: - Variables
    
    weak var delegate: MainVCDelegate?
    
    var results: [Result] = []
    var allImageArray: [Image] = []
    
    var counter: Int = 0
    
    private let cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    var priceDownload: [String : Double] = [        
        Product.impatrickt.rawValue : 0,
        Product.thestandingdesk.rawValue : 0,
        Product.thisisengineering.rawValue : 0,
        Product.stilclassis.rawValue : 0,
        Product.yolk_coworking_krakow.rawValue : 0,
        Product.socialcut.rawValue : 0,
        Product.anniespratt.rawValue : 0,
        Product.dell.rawValue : 0,
        Product.flysi3000.rawValue : 0,
        Product.christinhumephoto.rawValue : 0
    ]

    //MARK: - Functions
    
    func getImages() {
        NetworkManager.shared.getImages { result in
            for i in result {
                self.allImageArray.append(Image(results: i, buy: false))
            }
            self.results = result
            self.delegate?.reloadCollectionView()
        }
    }
    
    func setCell(row: Int) -> ImageCollectionViewCell.ResultCell {
        let allImageArrayCell = allImageArray[row]
        let resultsCell = results[row]
        return ImageCollectionViewCell.ResultCell.init(row: row,
                                                       counter: counter,
                                                       results: results,
                                                       result: resultsCell,
                                                       name: resultsCell.user.username,
                                                       urlString: resultsCell.urls.regular,
                                                       priceDownload: priceDownload[resultsCell.user.username] ?? 0,
                                                       allImageArray: allImageArray,
                                                       resultCount: results.count,
                                                       buy: allImageArrayCell.buy
        )
    }
    
    func resultCount() -> Int {
        return results.count
    }
    
    func userName(row: Int) -> String {
        return results[row].user.username
    }
    
    func sizeImage(row: Int) -> SizeImage {
        return SizeImage.init(height: results[row].height,
                              width: results[row].width)
    }
    
    func price(name: String, row: Int) {
        //имитация отправки запроса цены и получение её с задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.priceDownload[name] = priceList[name] ?? 0
            if self.counter < self.results.count {
                self.counter += 1
            }
            if self.counter == self.results.count {
                self.delegate?.reloadCollectionView()
            }
        }
    }
    
    func purchises(row: Int) {
        allImageArray[row].buy = true
        delegate?.reloadItem(row: row)
    }
}
