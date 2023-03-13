//
//  AsyncImageView.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit

class AsyncImageView: UIImageView {
    
    private let loading = ImageCache.shared

    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    var newImage: UIImage? {
        didSet {
            self.image = newImage
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configInit()
    }
    
    private func configInit() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
        addSubviews(activityIndicator)
        self.fillAnchor(self)
        activityIndicator.center(centerX: centerXAnchor,
                                 centerY: centerYAnchor)
    }
    
    private func startIndicator() {
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
    }
    
    private func stopIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        self.isUserInteractionEnabled = true
    }
     
    func loadImage(url: String, defaultImage: UIImage? = UIImage(named: Constant.Image.defaultImage)) {
        self.startIndicator()
        loading.loadImage(url) { [weak self] status in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch status {
                case .success(let image):
                    self.stopIndicator()
                    self.image = image
                case .failure(let error):
                    self.stopIndicator()
                    self.image = defaultImage
                    self.backgroundColor = UIColor.theme.lightGray?.withAlphaComponent(0.6)
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func fetchImage(imageURL: String?, defaultImage: UIImage? = nil) {
        if let imageURL = imageURL {
            loadImage(url: imageURL, defaultImage: defaultImage)
        } else {
            print("default image")
            self.image = defaultImage
        }
    }
    
}
