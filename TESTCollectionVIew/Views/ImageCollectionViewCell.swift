//
//  ImageCollectionViewCell.swift
//  TESTCollectionVIew
//
//  Created by Kseniya Smirnova on 5.10.22.
//

import UIKit
import SnapKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    struct ResultCell {
        let row: Int
        var counter: Int
        let results: [Result]
        let result: Result
        let name: String
        let urlString: String
        var priceDownload: Double
        var allImageArray: [Image]
        let resultCount: Int
        var paid: Bool
    }
    
    //MARK: - Variables
    
    static let identifier = "ImageCollectionViewCell"
    
    private let borderLayer = CAShapeLayer()
    
    var priceHandler: ((String) -> Void)?
    
    private let bgView = UIView()
    private let borderBackView = UIView()
    
    private let cellLabel = CustomLabel()
    private let priceLabel = CustomLabel()
    private let cellImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 10
        return iv
    }()
    private let priceView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        v.alpha = 0
        return v
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
        cellLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(5)
        }
        priceView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(-5)
            make.height.equalTo(20)
        }
        priceLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        contentView.addSubview(borderBackView)
        contentView.addSubview(cellLabel)
        contentView.addSubview(bgView)
        
        bgView.addSubview(cellImageView)
        bgView.addSubview(priceView)
        
        priceView.addSubview(priceLabel)
        
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.lineDashPattern = [4, 4]
        borderLayer.fillColor = nil
        borderBackView.layer.addSublayer(borderLayer)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        borderLayer.frame = self.bounds
        borderLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 10).cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellImageView.frame = contentView.bounds
        bgView.frame = contentView.bounds
        borderBackView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.image = nil
    }
    
    //MARK: - Functions
    
    func configure(_ data: ResultCell) {
        cellLabel.text = data.name
        tag = data.row
        if data.counter != data.resultCount {
            if let cachedImage = NetworkManager.shared.cache.object(forKey: data.row as NSNumber) {
                cellImageView.image = cachedImage
                priceHandler?(data.name)
                setImageCell()
            } else {
                NetworkManager.shared.downloadImage(urlString: data.urlString, row: data.row) { [weak self] (row, image) in
                    if self?.tag == row {
                        self?.cellImageView.image = image
                        self?.priceHandler?(data.name)
                        self?.setImageCell()
                    }
                }
            }
        } else {
            if data.paid {
                priceView.backgroundColor = Colors.greenColor.rawValue
                priceView.alpha = 1
                priceLabel.text = "✓"
                priceLabel.textColor = .white
            } else {
                setPriceCell(price: data.priceDownload)
            }
            if let cachedImage = NetworkManager.shared.cache.object(forKey: data.row as NSNumber) {
                cellImageView.image = cachedImage
            }
        }
    }
    
    func setImageCell() {
        bgView.alpha = 1
        cellLabel.alpha = 0
        borderBackView.alpha = 0
    }
    
    func setPriceCell(price: Double) {
        setImageCell()
        if price == 0 {
            priceLabel.text = "FREE"
            priceView.backgroundColor = .white
            priceLabel.textColor = Colors.greenColor.rawValue
        } else {
            priceLabel.text = "$ " + String(price)
            priceView.backgroundColor = Colors.yellowColor.rawValue
            priceLabel.textColor = .red
        }
        priceView.alpha = 1
    }
}
