//
//  MainVC.swift
//  TESTCollectionVIew
//
//  Created by Kseniya Smirnova on 5.10.22.
//

import UIKit
import SnapKit

class MainVC: UIViewController {
    
    //MARK: - Variables
    
    private var collectionView: UICollectionView?
    private let errorLabel = CustomLabel()
    
    private let shadowView: UIView = {
        let v = UIView()
        v.backgroundColor = Colors.grayColor.rawValue
        return v
    }()
    
    private var model = MainVCModel()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.delegate = self
        model.getImages()
        
        setUI()
        setCollectionView()
        setConstraints()
    }
    
    //MARK: - Functions
    
    func setUI() {
        navigationItem.title = "Main"
        view.backgroundColor = .white
        
        view.addSubview(shadowView)
        shadowView.addSubview(errorLabel)
    }
    
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
        self.shadowView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalToSuperview()
        }
        self.collectionView?.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(5)
        }
        self.errorLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(5)
        }
    }
}

//MARK: - Extension UICollectionView

extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.resultsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(model.setCell(row: indexPath.row))
        cell.priceHandler = { [weak self] (name) in
            self?.model.price(name: name, row: indexPath.row)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !model.purchased(indexPath.row) else { return }
        let alert = UIAlertController(title: "Picture \"\(model.userName(indexPath.row))\" already purchased",
                                      message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
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
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat {
        let spacing: CGFloat = 5
        let ratio = CGFloat(model.imageSize(indexPath.item).height) / CGFloat(model.imageSize(indexPath.item).width)
        return (collectionView.frame.width / 2.0 - spacing * 2) * ratio
    }
}

//MARK: - Extension MainVC

extension MainVC: MainVCDelegate {
    func errorMessage(_ text: String) {
        errorLabel.text = text
    }
    
    func reloadItem(_ row: Int) {
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
