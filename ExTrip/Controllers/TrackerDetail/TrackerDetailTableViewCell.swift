//
//  TrackerDetailTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 21/03/2023.
//

import UIKit

class TrackerDetailTableViewCell: UITableViewCell {

    static let identifier = "TrackerDetailTableViewCell"
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var isHighLight: Bool = false {
        didSet {
            titleLabel.font = .poppins(style: .bold, size: 14)
        }
    }

    private lazy var titleLabel = ETLabel(style: .small, size: 14)

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.font = .poppins(style: .bold, size: 14)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let padding: CGFloat = 20
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, 
                          bottom: bottomAnchor,
                          trailing: trailingAnchor, 
                          paddingTop: padding, 
                          paddingBottom: padding,
                          paddingTrailing: padding)
    }
}
