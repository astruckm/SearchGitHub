//
//  SearchViewModel.swift
//  SearchGitHub
//
//  Created by Andrew Struck-Marcell on 10/13/21.
//

import UIKit

class SearchViewModel {
    var repos: [Repo] = [] {
        willSet {
            self.reloadSuggestionsTableView?()
        }
    }
    var reloadSearchResultsTableView: (() -> Void)?
    var reloadSuggestionsTableView: (() -> Void)?
    
    func loadRepos(searchQuery: String) {
        let search = GitHubSearchRepos(searchQuery: searchQuery)
        let client = GitHubClient()
        client.searchRepos(search) { result in
            switch result {
            case .success(let response):
                print(response.totalCount)
                print(response.items[0..<10])
                let 
            case .failure(let error): print("error in result: ", error)
            }
        }
    }
    
    private func loadReposTask(searchQuery: String) {
        
    }
}
