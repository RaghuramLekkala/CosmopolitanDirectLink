//
//  CarouselCellTableViewCell.swift
//  IOSChatBot
//
//  Created by Raghuram on 21/06/22.
//

import UIKit

class CarouselCellTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: - variables && objects
    static let identifier = "CarouselCellTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "CarouselCellTableViewCell", bundle: nil)
    }
    
    var viewModelData: [Attachments] = []
    var imageArray: [Attachments] = []
    var nonImageArray: [Attachments] = []
    var width: CGFloat?
    var height: CGFloat?
    //MARK: - IBOutlet && actions
    @IBOutlet weak var myCellCollectionView: UICollectionView!
    //MARK: - awakeFromNib
    override func awakeFromNib() {
        width = contentView.frame.size.width
        super.awakeFromNib()
        
        let podBundle = Bundle(for:CarouselCellTableViewCell.self)
            if let bundleURL = podBundle.url(forResource: "CosDirectLink", withExtension: "bundle") {
                if let bundle = Bundle(url: bundleURL) {
                    let cellNib = UINib(nibName: CarouselCell.identifier, bundle: bundle)
                    myCellCollectionView.register(cellNib, forCellWithReuseIdentifier: CarouselCell.identifier)
                } else {
                    assertionFailure("Could not load the bundle")
                }
                if let bundle = Bundle(url: bundleURL) {
                    let cellNib = UINib(nibName: DynamicButtonCollectionViewCell.identifier, bundle: bundle)
                    myCellCollectionView.register(cellNib, forCellWithReuseIdentifier: DynamicButtonCollectionViewCell.identifier)
                } else {
                    assertionFailure("Could not load the bundle")
                }
            } else {
                assertionFailure("Could not create a path to the bundle")
            }
        
//        myCellCollectionView.register(CarouselCell.nib(), forCellWithReuseIdentifier: CarouselCell.identifier)
//        myCellCollectionView.register(DynamicButtonCollectionViewCell.nib(), forCellWithReuseIdentifier: DynamicButtonCollectionViewCell.identifier)
        contentView.addSubview(myCellCollectionView)
        myCellCollectionView.dataSource = self
        myCellCollectionView.delegate = self
    }
    
    //MARK: - layout
    override func layoutSubviews() {
        super.layoutSubviews()
        myCellCollectionView.frame = contentView.bounds
    }
    
    func configure(with viewModel: Message) {
        switch viewModel.kind {
        case .attachments(let value):
            viewModelData = value!
            imageArray = viewModelData.filter{$0.content?.images != nil}
            nonImageArray = viewModelData.filter{$0.content?.images == nil}
            myCellCollectionView.reloadData()
            break
        default:
            break
        }
        
    }
    
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int = 0
        if (viewModelData[section].content?.images != nil){
            height =  width!/1.5
            count = imageArray.count
        }else{
            height = width!/2.5
            count = nonImageArray.count
        }
        return count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        width = contentView.frame.width
        if (viewModelData[indexPath.section].content?.images != nil) {
            
            guard let cellA = myCellCollectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier, for: indexPath) as? CarouselCell else {
                 fatalError()
             }
             cellA.configure(with: imageArray[indexPath.row])
             return cellA
        }else{
           
            guard let cellB = myCellCollectionView.dequeueReusableCell(withReuseIdentifier: DynamicButtonCollectionViewCell.identifier, for: indexPath) as? DynamicButtonCollectionViewCell else {
                fatalError()
            }
            cellB.configure(with: nonImageArray[indexPath.section])
            return cellB
        }  
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let height = height{
            return CGSize(width: contentView.frame.width - 20, height: height)
        }
        return CGSize(width: contentView.frame.width - 20, height:contentView.frame.width/1.5 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
