//
//  EditProfileTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 02/03/2023.
//

import UIKit

protocol EditProfileTableViewCellDelegate: AnyObject {
    func editProfileTableViewCellDelegateHandleChangeImage()
}

class EditProfileTableViewCell: UITableViewCell {
    
    static let identifier = "EditProfileTableViewCell"
    
    weak var delegate: EditProfileTableViewCellDelegate? 
    
    private let avatarSize: CGFloat = 65
    private let pencilSize: CGFloat = 20
    private let padding: CGFloat = 10
    
    private let editImage = UIImage(systemName: "pencil.circle.fill")
    
    private lazy var containerView = UIView()
    
    private lazy var avatarImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    
    private lazy var editImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        imageView.image = editImage?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        return imageView
    }()
    
        // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView() {
        contentView.addSubview(containerView)
        containerView.addSubviews(avatarImageView, 
                                  editImageView)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        containerView.setWidth(width: avatarSize)
        containerView.setHeight(height: avatarSize)
        containerView.anchor(leading: leadingAnchor,
                             paddingLeading: padding)
        containerView.center(centerY: centerYAnchor)
        
        avatarImageView.fillAnchor(containerView)
        avatarImageView.layer.cornerRadius = avatarSize/2
        
        editImageView.anchor(bottom: containerView.bottomAnchor,
                             trailing: containerView.trailingAnchor)
        editImageView.setWidth(width: pencilSize)
        editImageView.setHeight(height: pencilSize)
    }
    
    private func setupAction() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleChangeImageAction(tapGestureRecognizer:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleChangeImageAction(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate?.editProfileTableViewCellDelegateHandleChangeImage()
    }
    
}
