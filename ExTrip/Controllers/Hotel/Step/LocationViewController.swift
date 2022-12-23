//
//  LocationViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 20/12/2022.
//

import UIKit

class LocationViewController: UIViewController {

    var doneHandler: ((String?) -> Void)?
    
    private var value: String?

    private var destinations: [String] = []
    private var filteredCountries: [String] = []

    private let iconPadding: CGFloat = 15
    private let iconHeight: CGFloat = 20
    
    // MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Search Your Destination"
        label.font = .poppins(style: .bold)
        return label
    }()
    
    private lazy var searchTextField = ETSearchTextField()
    private lazy var doneButton = ETGradientButton(title: .done, style: .mysticBlue)
    
    private lazy var resultTableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        mockData()
    }
    
    private func mockData() {
        destinations.append("Australia")
        destinations.append("India")
        destinations.append("South Africa")
        destinations.append("China")
        destinations.append("Japan")
        destinations.append("Canada")
        destinations.append("United Kingdom")
        destinations.append("Germary")
        destinations.append("USA")
        destinations.append("Laos")
        destinations.append("Thai Lan")
        destinations.append("Indonesia")
        destinations.append("New ZeaLand")
        destinations.append("Yemen")
        destinations.append("Saudi Arabia")
        destinations.append("Yemen")
    }
    
    override func updateViewConstraints() {
        self.view.frame.size.height = UIScreen.main.bounds.height - 15
        self.view.frame.origin.y =  15
        self.view.roundCorners(corners: [.topLeft, .topRight], radius: 25.0)
        super.updateViewConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        self.hideKeyboardWhenTappedAround() 
        view.addSubviews(titleLabel,
                         searchTextField,
                         resultTableView,
                         doneButton)
        
        searchTextField.delegate = self
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
        setupConstraintViews() 
        doneButton.addTarget(self, action: #selector(handlerdoneAction), for: .touchUpInside)
    }
    
    private func setupConstraintViews() {
        let padding: CGFloat = 15
        titleLabel.anchor(top: view.topAnchor, 
                          leading: view.leadingAnchor, 
                          trailing: view.trailingAnchor,
                          paddingTop: 50,
                          paddingLeading: padding,
                          paddingTrailing: padding)
        titleLabel.setHeight(height: 30)
        
        searchTextField.anchor(top: titleLabel.bottomAnchor,
                               leading: view.leadingAnchor, 
                               trailing: view.trailingAnchor,
                               paddingTop: padding,
                               paddingLeading: padding,
                               paddingTrailing: padding)
        searchTextField.setHeight(height: 50)
    
        doneButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          paddingBottom: 100,
                          paddingLeading: 30,
                          paddingTrailing: 30)
        doneButton.setHeight(height: 50)
        
        resultTableView.anchor(top: searchTextField.bottomAnchor,
                               bottom: doneButton.topAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               paddingTop: padding,
                               paddingLeading: padding,
                               paddingTrailing: padding)
    }
    
    // Filter
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchTextField.text = nil
        filter(for: nil)
        return true
    }
    
    func filter(for query: String?) {
        if query?.count == 0 {
            filteredCountries = destinations
        } else if let text = query {
            filteredCountries = destinations
                .filter { $0.localizedLowercase.contains(text.localizedLowercase) }
        }
        resultTableView.reloadData()
    }
    
    private func cancel() {
        dismiss(animated: true)
    }
    
}

// MARK: - UITextFieldDelegate
extension LocationViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let finalText = NSString(string: text).replacingOccurrences(of: text, with: string, range: range)
        filter(for: finalText)
        return true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = filteredCountries[indexPath.item]
        cell.textLabel?.text = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = filteredCountries[indexPath.item]
        self.value = item
        self.doneHandler?(item)
        cancel()
 
    }
}

// MARK: - Handle Action
extension LocationViewController {
    @objc func handlerdoneAction() {
        if let text = searchTextField.text {
            self.value = text
        }
        self.doneHandler?(value)
        cancel()
    }
}
