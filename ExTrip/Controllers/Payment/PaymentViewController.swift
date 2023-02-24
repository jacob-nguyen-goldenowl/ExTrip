//
//  PaymentViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 23/02/2023.
//

import UIKit

struct PaymentModel {
    let lblSection: String?
    let lblCell: [String]?
    
    init(lblSection: String?, lblCell: [String]?) {
        self.lblSection = lblSection
        self.lblCell = lblCell
    }
}

class PaymentViewController: UIViewController {
    
    private var dataTableView = [PaymentModel]()
    
    

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.showsVerticalScrollIndicator = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return table
    }()
    
    init(booking: BookingModel) {
        print("Booking info: \(booking)")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        regiterCell()
        setupDataForTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBinder()
    }
    
    private func setupDataForTableView() {
        dataTableView.append(PaymentModel.init(lblSection: "my payment methods", lblCell: ["apple pay", "....1234"]))
        dataTableView.append(PaymentModel.init(lblSection: "add payment method", lblCell: ["add credit/debit card", "paypal", "Pace"]))
    }
    
    private func setupNavigationBar() {
        title = "Review and Book"
        navigationController?.configBackButton()
    }
    
    private func regiterCell() {
        tableView.register(PaymentTableViewCell.self,
                           forCellReuseIdentifier: PaymentTableViewCell.identifier)
    }
    
    private func setupBinder() {}
    
    // MARK: - Setup UI
    private func setupViews() {
        view.addSubviews(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstaintsView()
    }
    
    private func setupConstaintsView() {  
        tableView.anchor(top: view.topAnchor, 
                         bottom: view.bottomAnchor, 
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
    }
}

    // MARK: - UITableViewDelegate, UITableViewDataSource
extension PaymentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataTableView.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataTableView[section].lblSection
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTableView[section].lblCell?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.identifier, for: indexPath) as! PaymentTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.paymentTitle = dataTableView[indexPath.section].lblCell?[indexPath.row]

        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.rightTitle = "DEFAULT"
                cell.accessoryType = .none
            }
        }
        return cell
    }
}
