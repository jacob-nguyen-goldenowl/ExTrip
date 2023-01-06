//
//  HotelViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit

class HotelViewController: UIViewController {
    
    private var hotels: [HotelModel] = []

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(HotelTableViewCell.self,
                       forCellReuseIdentifier: HotelTableViewCell.identifier)
        table.bouncesZoom = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.bounces = false
        return table
    }()
    
    convenience init(_ data: [HotelModel]) {
        self.init()
        self.hotels = data
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.fillAnchor(view)
    }
    
    private func setupNavigation() {
        navigationController?.configBackButton()
        
        let filterButton = UIButton(type: .custom)
        let image = UIImage(named: "slider")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        filterButton.setImage(tintedImage, for: .normal)
        filterButton.tintColor = UIColor.theme.lightBlue ?? .blue
        filterButton.addTarget(self, action: #selector(handleFilterButton), for: .touchUpInside)
        let item = UIBarButtonItem(customView: filterButton)
        
        self.navigationItem.setRightBarButton(item, animated: true)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HotelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelTableViewCell.identifier,
                                                       for: indexPath) as? HotelTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let data = hotels[indexPath.row]
        cell.cofigureHotel(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension HotelViewController {
    @objc func handleFilterButton() {
        let vc = FilterViewController()
        vc.title = "filters".uppercased()
        navigationController?.pushViewController(vc, animated: true)
    }
}
