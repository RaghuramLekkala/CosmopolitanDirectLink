//
//  QuickReplyTableViewCell.swift
//  IOSChatBot
//
//  Created by Raghuram on 21/06/22.
//

import UIKit

class QuickReplyTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var actions:[Actions]?
    
    //MARK: - variables && objects
    static let identifier = "QuickReplyTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "QuickReplyTableViewCell", bundle: nil)
    }
    
    weak var delegate: ChatViewControllerDelegate?
    
    //MARK: - IBOutlet
    @IBOutlet weak var quickReplyCollectionView: UICollectionView!
    //MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let podBundle = Bundle(for:QuickReplyTableViewCell.self)
        if let bundleURL = podBundle.url(forResource: "CosDirectLink", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let cellNib = UINib(nibName: QuickReplyCollectionViewCell.identifier, bundle: bundle)
                quickReplyCollectionView.register(cellNib, forCellWithReuseIdentifier: QuickReplyCollectionViewCell.identifier)
            } else {
                assertionFailure("Could not load the bundle")
            }
        } else {
            assertionFailure("Could not create a path to the bundle")
        }
        
//        quickReplyCollectionView.register(QuickReplyCollectionViewCell.nib(), forCellWithReuseIdentifier: QuickReplyCollectionViewCell.identifier)
        quickReplyCollectionView.dataSource = self
        quickReplyCollectionView.delegate = self
        contentView.addSubview(quickReplyCollectionView)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
//    func configure(with action: [[Actions]]) {
//        actions = HomeViewController.actions[HomeViewController.actions.endIndex - 1 ]
//        quickReplyCollectionView.reloadData()
//    }
    func configure(with action: Message) {
        switch action.kind {
        case .actions(let value):
            actions = value!
            quickReplyCollectionView.reloadData()
            break
        default:
            break
        }
        
    }
    
    //MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellB = quickReplyCollectionView.dequeueReusableCell(withReuseIdentifier: QuickReplyCollectionViewCell.identifier, for: indexPath) as? QuickReplyCollectionViewCell else {
            fatalError()
        }
        cellB.delegate = delegate
        cellB.configure(with: actions![indexPath.item])
        return cellB
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = contentView.frame.size.width/4
        return CGSize(width: width, height:30 )
    }
    
}
