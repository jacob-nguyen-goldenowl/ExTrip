//
//  FilterTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    static let mainIdentifier = "FilterTableViewCell"
    
    public var title: String? {
        didSet {
            headerTitle.text = title
        }
    }
    
    public var currentValue: ((Double) -> Void)?
    
    public lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .bold, size: 14)
        return label
    }()
    
    public lazy var showValue: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .regular, size: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textLabel?.font = .poppins(style: .light)
        detailTextLabel?.font = .poppins(style: .light)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
