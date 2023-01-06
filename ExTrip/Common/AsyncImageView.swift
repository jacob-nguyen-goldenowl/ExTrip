//
//  AsyncImageView.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit

class AsyncImageView: UIView {
    
    private let loading = ImageCache.shared
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    
    var newImage: UIImage? {
        didSet {
            imageView.image = newImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configInit() {
        clipsToBounds = true
        addSubviews(imageView, 
                    activityIndicator)
        imageView.fillAnchor(self)
        activityIndicator.center(centerX: centerXAnchor,
                                 centerY: centerYAnchor)
    }
    
    private func startIndicator() {
        activityIndicator.startAnimating()
        imageView.isUserInteractionEnabled = false
    }
    
    private func stopIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        imageView.isUserInteractionEnabled = true
    }
     
    func loadImage(url: String, defaultImage: UIImage? = UIImage(named: "background")) {
        self.startIndicator()
        loading.loadImage(url) { [weak self] status in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch status {
                    case .success(let image):
                        self.stopIndicator()
                        self.imageView.image = image
                    case .failure(let error):
                        self.stopIndicator()
                        self.imageView.image = defaultImage
                        print(error.localizedDescription)
                }
            }
        }
    }
    
}
