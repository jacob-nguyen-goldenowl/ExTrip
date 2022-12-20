//
//  StretchyTableHeaderView.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 20/12/2022.
//

import UIKit

class StretchyTableHeaderView: UIView {
    
    // MARK: - Properties
    private lazy var headerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var cornerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = UIColor.theme.white ?? .white
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .poppins(style: .bold, size: 30)
        label.textColor = UIColor.theme.white ?? .white
        return label
    }()
    
    private let ratingView = RattingView(type: .gray)
    
    private var headerImageHeight = NSLayoutConstraint()
    private var headerImageBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupViewConstraits()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        addSubviews(containerView,
                    cornerView)
        containerView.addSubviews(headerImage,
                                  countryLabel,
                                  ratingView)
    }
    
    private func setupViewConstraits() {
        
        // Make constraint container view 
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor),
            widthAnchor.constraint(equalTo: containerView.widthAnchor)
        ])
        
        containerView.widthAnchor.constraint(equalTo: headerImage.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        // Make constraint subviews 
        countryLabel.center(centerX: headerImage.centerXAnchor,
                            centerY: headerImage.centerYAnchor,
                            paddingY: -20)
        countryLabel.setHeight(height: 30)
        
        ratingView.anchor(top: countryLabel.bottomAnchor, 
                          paddingTop: 8)
        ratingView.center(centerX: containerView.centerXAnchor)
        ratingView.setWidth(width: 65)
        ratingView.setHeight(height: 30)
        
        cornerView.anchor(bottom: bottomAnchor,
                          leading: leadingAnchor,
                          trailing: trailingAnchor)
        cornerView.setHeight(height: 40)
        
        // Make constraint header image 
        headerImage.translatesAutoresizingMaskIntoConstraints = false
        headerImageBottom = headerImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        headerImageBottom.isActive = true
        headerImageHeight = headerImage.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        headerImageHeight.isActive = true
    }
    
    // Adjust the size constraints to fit the frame when scrolling 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        headerImageBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        headerImageHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    } 
    
    func getDataForHeader(image: UIImage?,score: String?, title: String?) {
        headerImage.image = image ?? UIImage(named: "background")
        ratingView.score = score ?? "0.0"
        countryLabel.text = title?.uppercased() ?? "___"
    }
    
}
