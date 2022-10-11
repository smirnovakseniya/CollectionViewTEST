//
//  MainVC.swift
//  TESTCollectionVIew
//
//  Created by Kseniya Smirnova on 5.10.22.
//

import UIKit
import SnapKit

class MainVC: UIViewController {
    
    private var collectionView: UICollectionView?
//    private let errorLabel = CustomLabel()
    
    private let shadowView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.grayColor.rawValue
        return v
    }()
    
    //MARK: - Variables
    
    var model = MainVCModel()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Main"
        view.backgroundColor = .white
        
        model.delegate = self
       model.getImages()
        
        setCollectionView()
        setConstraints()
    }
    
    //MARK: - Functions
    
    func setCollectionView() {
        let layout = PinterestLayout()
        layout.delegate = self
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        self.collectionView = collectionView
        
        shadowView.addSubview(collectionView)
    }
    
    func setConstraints() {
        view.addSubview(shadowView)
//        shadowView.addSubview(errorLabel)
        
        self.shadowView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        self.collectionView?.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(5)
        }
//        self.errorLabel.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
//            make.left.right.equalToSuperview().inset(5)
//        }
    }
    var task: URLSessionDownloadTask!
}

//MARK: - Extension UICollectionView

extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.resultCount()
    }
    
    //MARK: - НАДО!!!!

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
            
            cell.configure(data: model.setCell(row: indexPath.row))
            
            if let cachedImage =  NetworkManager.shared.cache.object(forKey: indexPath.row as NSNumber) {
                 cell.cellImageView.image = cachedImage
            }
            
            cell.priceHandler = { [weak self] name in
                self?.model.price(name: name, row: indexPath.row)
            }
           
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if model.counter == model.results.count {
            if !model.allImageArray[indexPath.row].buy {
                IAPManager.shared.purchase(product: Product(rawValue: model.userName(row: indexPath.row))!) { [weak self] i in
                    self?.model.purchises(row: indexPath.row)
                }
            } else {
                let alert = UIAlertController(title: "Picture \"\(model.userName(row: indexPath.row))\" already purchased",
                                              message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }
        }
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 5
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + spacing * 2)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
}

extension MainVC: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let spacing: CGFloat = 5
        let coeff = CGFloat(model.sizeImage(row: indexPath.item).height) / CGFloat(model.sizeImage(row: indexPath.item).width)
        return (collectionView.frame.width / 2.0 - spacing * 2) * coeff
    }
}

extension MainVC: MainVCDelegate {
    func reloadItem(row: Int) {
        DispatchQueue.main.async {
            self.collectionView?.reloadItems(at: [IndexPath(row: row, section: 0)])
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}
