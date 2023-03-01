//
//  PaymentViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 28/02/2023.
//

import UIKit

private struct PaymentModel {
    let lblSection: String?
    let lblCell: [CellModel]?
    
    init(lblSection: String?, lblCell: [CellModel]?) {
        self.lblSection = lblSection
        self.lblCell = lblCell
    }
}

private struct CellModel {
    let title: String?
    let cardImage: UIImage?
}

class PaymentViewController: UIViewController {

    private var paymentData = [PaymentModel]()
    private var bookingData: BookingModel?
    private var roomData: RoomModel?

    private lazy var loadingView = LottieView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .white
        return table
    }()
    
    private lazy var usePaymentMethod = ETGradientButton(title: .paymentMethod, style: .mysticBlue)
    
        // Initialization constructor
    init(data: BookingModel?, room: RoomModel?) {
        self.bookingData = data
        self.roomData = room
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        setupNavigationBar()
        setDataForTableView()
        setupViews()
        regiterCell()
        setupAction()
    }
    
    private func setupNavigationBar() {
        navigationController?.configBackButton()
        title = "PAYMENT METHODS"
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView,
                         usePaymentMethod)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstaintsView()
    }
    
    private func setupConstaintsView() { 
        let padding: CGFloat = 50
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
        
        usePaymentMethod.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor, 
                                paddingBottom: padding,
                                paddingLeading: padding, 
                                paddingTrailing: padding)
        usePaymentMethod.setHeight(height: 50)
    }
    
    private func setupStarLoading() {
        view.addSubview(loadingView)
        loadingView.fillAnchor(view)
        loadingView.startAnimating()
    }

    private func regiterCell() {
        tableView.register(PaymentTableViewCell.self,
                           forCellReuseIdentifier: PaymentTableViewCell.identifier)
    }
    
    private func setDataForTableView() {
        paymentData.append(PaymentModel(lblSection: "my payment methods",
                                        lblCell: [CellModel(title: "apple pay",
                                                            cardImage: UIImage(named: "applepay")),
                                                  CellModel(title: "...123",
                                                            cardImage: UIImage(named: "mastercard"))]))
                                                                                         
        paymentData.append(PaymentModel(lblSection: "add payment method",
                                        lblCell: [CellModel(title: "add credit/debit card",
                                                            cardImage: UIImage(named: "credit-card")),
                                                  CellModel(title: "paypal",
                                                            cardImage: UIImage(named: "paypal")),
                                                  CellModel(title: "pace",
                                                            cardImage: UIImage(named: "visa"))]))
    }
    
    private func setupAction() {
        usePaymentMethod.addTarget(self, action: #selector(handleUsePaymentAction), for: .touchUpInside)
    }
    
    @objc func handleUsePaymentAction() {
        setupStarLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.loadingView.stopAnimating()
            let vc = ConfirmPaymentViewController(data: self?.bookingData, room: self?.roomData)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return paymentData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentData[section].lblCell?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.identifier, 
                                                       for: indexPath) as? PaymentTableViewCell else { return UITableViewCell() }
        cell.accessoryType = .disclosureIndicator

        let item = indexPath.item
        let cardImage = paymentData[indexPath.section].lblCell?[item].cardImage
        let title = paymentData[indexPath.section].lblCell?[item].title
        
        if indexPath.section == 0 {
            if item == 0 {
                cell.isCardDefault = true
                cell.accessoryType = .none
            }
        }
        
        cell.cardImage = cardImage
        cell.cardTitle = title
        cell.backgroundColor = .tertiarySystemFill
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titleHeader = paymentData[section].lblSection
        return titleHeader
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
