//
//  MyCell.swift
//  IOSChatBot
//
//  Created by Raghuram on 13/06/22.
//

import UIKit


class CarouselCell: UICollectionViewCell {
    //MARK: - variables && objects
    static let identifier = "CarouselCell"
    static func nib() -> UINib{
        return UINib(nibName: "CarouselCell", bundle: nil)
    }

    let apiManager = ApiManager()
    //MARK: - IBOutlet && actions
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var buttonPressedLabel: UIButton!
    @IBAction func buttonPressed(_ sender: Any) {
        apiManager.post(endpoint:  "/conversations/\(ApiManager.cid)/activities", token: ApiManager.tokenVal!, body: ["type": "message", "from": [
            "id": HomeViewController.uuid,
            "name": HomeViewController.userName
        ], "text": titleLabel.text! as String])
    }
    //MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.borderWidth = 0.5
        buttonPressedLabel.layer.borderWidth = 0.5
        descriptionLabel.textColor = .gray
    }
   
    func configure(with viewModel: Attachments) {
        if let imageUrl = viewModel.content?.images?[0].url{
            let url = URL(string: imageUrl)
            DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async { [self] in
                            imageView?.image = UIImage(data: data!)
                        }
                    }
            titleLabel?.text = viewModel.content?.title
            descriptionLabel.text = viewModel.content?.subtitle
            buttonPressedLabel.setTitle(viewModel.content?.title, for: .normal)
        }
    }
}
