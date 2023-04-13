//
//  OnboardingCollectionViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 08/12/2022.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "OnboardingCollectionViewCell"
    
    // MARK: - Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var tripLabel: UILabel = {
        let label = UILabel()
        label.text = "Ex.Trip"
        label.font = .poppins(style: .extra)
        label.textAlignment = .center
        label.textColor = UIColor.theme.black
        return label
    }()
    
    private lazy var wrapContentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = UIColor.theme.lightGray?.withAlphaComponent(0.8)
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.poppins(style: .bold)
        label.textAlignment = .center
        label.textColor = UIColor.theme.black
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.poppins(style: .light)
        label.textColor = UIColor.theme.black
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup sub views
    private func setupSubViews() {
        addSubviews(containerView)
        containerView.addSubviews(backgroundImage,
                                  wrapContentView,
                                  tripLabel)
        wrapContentView.addSubviews(titleLabel, 
                                    subtitleLabel)
        setupConstaintSubView() 
    }
    
    private func setupConstaintSubView() {
        let padding: CGFloat = 12
        
        containerView.anchor(top: safeAreaLayoutGuide.topAnchor,
                             bottom: safeAreaLayoutGuide.bottomAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor, 
                             paddingBottom: padding,
                             paddingLeading: padding,
                             paddingTrailing: padding)
        
        backgroundImage.fillAnchor(self)
        
        tripLabel.anchor(top: containerView.topAnchor,
                         bottom: wrapContentView.topAnchor,
                         leading: containerView.leadingAnchor,
                         trailing: containerView.trailingAnchor,
                         paddingTop: 100,
                         paddingBottom: 100)
        
        wrapContentView.anchor(bottom: containerView.bottomAnchor,
                               leading: containerView.leadingAnchor,
                               trailing: containerView.trailingAnchor)
        wrapContentView.setHeight(height: 350)
        
        titleLabel.anchor(top: wrapContentView.topAnchor,
                          leading: wrapContentView.leadingAnchor, 
                          trailing: wrapContentView.trailingAnchor,
                          paddingTop: 20)
        
        subtitleLabel.anchor(top: titleLabel.bottomAnchor,
                             leading: wrapContentView.leadingAnchor,
                             trailing: wrapContentView.trailingAnchor,
                             paddingTop: 10,
                             paddingLeading: 8,
                             paddingTrailing: 8)
    }
    
    // MARK: - Config data for onboarding
    func configOnboarding(_ data: OnboardingModel) {
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
        backgroundImage.image = UIImage(named: data.backgroundImage)
    }
}
