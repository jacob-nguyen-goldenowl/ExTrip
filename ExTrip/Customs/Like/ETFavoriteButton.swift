//
//  ETFavouriteButton.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 03/02/2023.
//

import UIKit

class ETFavoriteButton: UIButton {
    
    // Images
    let likedImage = UIImage(named: "favorite.fill")
    let likeImage = UIImage(named: "favorite")
    let likeColor = UIColor.theme.red ?? .red
    let unlikeColor = UIColor.theme.lightGray ?? .gray

    private lazy var starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.changeColorImage(image: likeImage, color: unlikeColor)
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        return imageView
    }()
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                starImage.changeColorImage(image: likedImage, color: likeColor)
                createAnimationWhenSelectItem(starImage)
            } else {
                starImage.changeColorImage(image: likeImage, color: unlikeColor)
                createAnimationWhenSelectItem(starImage)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(starImage)
        addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        isChecked = false
    }
    
    func createAnimationWhenSelectItem(_ item: UIImageView) {
        let timeInterval: TimeInterval = 0.6
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.6) {
            item.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
        }
        propertyAnimator.addAnimations({item.transform = CGAffineTransform.identity }, delayFactor: timeInterval)
        propertyAnimator.startAnimation()
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
