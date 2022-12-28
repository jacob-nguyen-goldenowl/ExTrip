//
//  RoomViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 27/12/2022.
//

import UIKit

class RoomViewController: UIViewController {

    var roomModel: RoomModel = RoomModel(room: 1,
                                         adults: 2,
                                         children: 0,
                                         infants: 0) 
    
    var doneHandler:((RoomModel) -> Void)?
    var initialValue: RoomModel?

    // MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Room & Guests"
        label.font = .poppins(style: .bold)
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.separatorStyle = .none
        table.register(RoomTableViewCell.self,
                       forCellReuseIdentifier: RoomTableViewCell.identifier)
        return table
    }()
    
    private let addRoomButton: UIButton = {
        let button = UIButton()
        let textOfButton = "Add another room"
        button.setTitle(textOfButton, for: .normal)
        button.setTitleColor(UIColor.theme.lightBlue ?? .blue, for: .normal)
        button.titleLabel?.font = .poppins(style: .medium)
        return button
    }()
    
    private lazy var doneButton = ETGradientButton(title: .done, style: .mysticBlue)

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureInitialState()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        view.frame.size.height = UIScreen.main.bounds.height - 15
        view.frame.origin.y =  15
        view.roundCorners(corners: [.topLeft, .topRight], radius: 25.0)
    }
    
    // MARK: Setup UI
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubviews(titleLabel,
                         tableView, 
                         addRoomButton,
                         doneButton)
        tableView.delegate = self
        tableView.dataSource  = self
        
        setupConstraintViews()
        doneButton.addTarget(self, action: #selector(handleDoneAction), for: .touchUpInside)
    }
    
    private func setupConstraintViews() {
        let padding: CGFloat = 20
        titleLabel.anchor(top: view.topAnchor, 
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          paddingTop: padding + 30,
                          paddingLeading: padding,
                          paddingTrailing: padding)
        titleLabel.setHeight(height: 30)
        
        tableView.anchor(top: titleLabel.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         paddingTop: padding,
                         paddingLeading: padding,
                         paddingTrailing: padding)
        tableView.setHeight(height: 500)
        
        doneButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          paddingBottom: 100,
                          paddingLeading: 30,
                          paddingTrailing: 30)
        doneButton.setHeight(height: 50)
    }

    private func configureInitialState() {
        roomModel = initialValue ?? RoomModel(room: 1, adults: 2, children: 0, infants: 0)
    }
    
    private func cancel() {
        dismiss(animated: true)
    }
    
}

extension RoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoomTableViewCell.identifier, for: indexPath) as? RoomTableViewCell else {
            return UITableViewCell()
        }
        let row = indexPath.row
        if row == 0 {
            cell.quantityGuests = roomModel.room
            cell.title = "Room"
            cell.getValue = { value in
                self.roomModel.room = value ?? 0
            }
        } else if row == 1{
            cell.quantityGuests = roomModel.adults
            cell.title = "Adult"
            cell.getValue = { value in 
                self.roomModel.adults = value ?? 0
            }
        } else if row == 2 {
            cell.title = "Children"
            cell.quantityGuests = roomModel.children
            cell.subTitle = "Ages 2 - 15"
            cell.getValue = { value in 
                self.roomModel.children = value ?? 0
            }
        } else {
            cell.title = "Infant"
            cell.quantityGuests = roomModel.infants
            cell.subTitle = "Under 2"
            cell.getValue = { value in 
                self.roomModel.infants = value ?? 0
            }
        }
        cell.selectionStyle = .none
        cell.indexPath = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
extension RoomViewController {
    @objc func handleDoneAction() {
        doneHandler?(roomModel)
        cancel()
    }
}
