//
//  ETCancelButton.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 13/03/2023.
//

import UIKit

protocol ETCancelButtonDelegate: AnyObject {
    func eTCancelButtonHandleCancelAction()
}

class ETCancelButton: UIView {
    
    weak var delegate: ETCancelButtonDelegate?
    
    // MARK: - Properties    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.sizeToFit()
        let image = UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.contentMode = .scaleAspectFit
        return button
    }()
    
        // MARK: - Initialization 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(cancelButton)
        cancelButton.fillAnchor(self)
        cancelButton.addTarget(self, action: #selector(handleCancelAction), for: .touchUpInside)
    }
    
    @objc func handleCancelAction() {
        delegate?.eTCancelButtonHandleCancelAction()
    }

}
