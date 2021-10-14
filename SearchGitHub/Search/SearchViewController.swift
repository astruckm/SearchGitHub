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
        textField.placeholder = "Search GitHub repos"
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.cornerRadius = 8
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
        tableView.backgroundColor = .clear
        return tableView
    }()
    lazy var suggestionsTableView: SearchSuggestionsTableView = {
        let suggestionsTV = SearchSuggestionsTableView()
        suggestionsTV.translatesAutoresizingMaskIntoConstraints = false
        return suggestionsTV
    }()
    lazy var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray4
        
        searchResultsTableView.reloadData()
        
        setupViewModel()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    private func setupViewModel() {
        viewModel.loadRepos(searchQuery: "tetris+language:assembly")
        viewModel.reloadSearchResultsTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.searchResultsTableView.reloadData()
            }
        }
        viewModel.reloadSuggestionsTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.suggestionsTableView.reloadData()
            }
        }
    }
    
    private func setupSubviews() {
        
        let margins = view.layoutMarginsGuide
        
        view.addSubview(searchTextField)
        view.addSubview(searchResultsTableView)
        view.addSubview(suggestionsTableView)
        
        suggestionsTableView.isHidden = true
        
        NSLayoutConstraint.activate([
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            searchTextField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 12),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            searchResultsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchResultsTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            searchResultsTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 12),
            searchResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            suggestionsTableView.centerXAnchor.constraint(equalTo: searchTextField.centerXAnchor),
            suggestionsTableView.widthAnchor.constraint(equalTo: searchTextField.widthAnchor),
            suggestionsTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 0),
            suggestionsTableView.heightAnchor.constraint(equalToConstant: 0)
        ])
        
        view.bringSubviewToFront(searchResultsTableView)
    }
    
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        viewModel.loadRepos(searchQuery: text)
        suggestionsTableView.isHidden = true
        suggestionsTableView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        return true
    }
    
    }

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseIdentifier, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
        cell.viewData = SearchResultViewData(name: String(indexPath.row))
        cell.backgroundColor = .systemPink
        
        return cell
    }
    
    
}

