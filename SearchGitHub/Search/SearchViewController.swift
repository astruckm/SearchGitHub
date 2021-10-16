//
//  SearchViewController.swift
//  SearchGitHub
//
//  Created by Andrew Struck-Marcell on 10/11/21.
//

import UIKit

class SearchViewController: UIViewController {
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.placeholder = "Search GitHub repos"
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.cornerRadius = 8
        textField.clearButtonMode = .whileEditing
        textField.addSpaceBeforeText()
        return textField
    }()
    lazy var searchResultsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var viewModel = SearchViewModel()
    var keyboardHeight: CGFloat = 254 // The height on iPod touch simulator (i.e. probable smallest height)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        searchResultsTableView.reloadData()
        
        setupViewModel()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setupViewModel() {
        viewModel.reloadSearchResultsTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.searchResultsTableView.reloadData()
            }
        }
        viewModel.loadingRepos = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.isHidden = false
                self?.activityIndicator.startAnimating()
            }
        }
        viewModel.finishedLoading = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }

    }
    
    private func setupSubviews() {
        let margins = view.layoutMarginsGuide
        
        view.addSubview(searchTextField)
        view.addSubview(searchResultsTableView)
        view.addSubview(activityIndicator)
        
        let searchTextFieldHeight: CGFloat = 40
        let searchTextFieldTopMargin: CGFloat = 24
        let searchTextFieldBottomMargin: CGFloat = 18
        var activityIndicatorYPositionFromTop: CGFloat {
            let topAreaHeight = (searchTextFieldHeight + searchTextFieldTopMargin + searchTextFieldBottomMargin)
            let keyboardShowingTableViewHeight = view.bounds.height - topAreaHeight - keyboardHeight
            return topAreaHeight + (keyboardShowingTableViewHeight / 2)
        }
                
        NSLayoutConstraint.activate([
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.widthAnchor.constraint(equalTo: view.widthAnchor,
                                                   multiplier: 0.9),
            searchTextField.topAnchor.constraint(equalTo: margins.topAnchor,
                                                 constant: searchTextFieldTopMargin),
            searchTextField.heightAnchor.constraint(equalToConstant: searchTextFieldHeight),
            
            searchResultsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchResultsTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            searchResultsTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor,
                                                        constant: searchTextFieldBottomMargin),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.topAnchor,
                                                       constant: activityIndicatorYPositionFromTop),
            activityIndicator.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        view.bringSubviewToFront(searchResultsTableView)
        view.bringSubviewToFront(activityIndicator)
    }
    
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textField.text else { return true }
        viewModel.loadRepos(searchQuery: text)
        return true
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.clearData()
        return true
    }
    
    // Implement incremental search here by loading repos on each keyboard tap
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        viewModel.loadRepos(searchQuery: text)
        return true
    }
}

// Using UITableViewDataSource instead of UITableViewDiffableDataSource in case support for < iOS 13 is required
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseIdentifier, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        let item = viewModel.repos[indexPath.row]
        cell.viewData = SearchResultViewData(name: item.repoName)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.repos[indexPath.row]
        if let url = item.url {
            UIApplication.shared.open(url)
        }
    }
    
}

extension SearchViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.keyboardHeight = keyboardFrame.height
        }
    }
}

