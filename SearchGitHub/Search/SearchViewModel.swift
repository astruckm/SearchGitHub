//
//  SearchViewModel.swift
//  SearchGitHub
//
//  Created by Andrew Struck-Marcell on 10/13/21.
//

import UIKit

class SearchViewModel {
    var repos: [Repo] = [/*Repo(repoName: "something", url: URL(string: "https://www.google.com")!), Repo(repoName: "something else", url: URL(string: "https://www.apple.com")!)*/] {
        willSet {
            self.reloadSearchResultsTableView?()
        }
    }
    var reloadSearchResultsTableView: (() -> Void)?
    var loadingRepos: (() -> Void)?
    var finishedLoading: (() -> Void)?
    let searchQueue = DispatchQueue(label: "searchQueue", qos: .userInteractive, attributes: .concurrent)
    var searchTask: DispatchWorkItem?
    
    func loadRepos(searchQuery: String) {
        self.searchTask?.cancel()
        self.loadingRepos?()
        
        let task = DispatchWorkItem { [weak self] in
            self?.loadReposTask(searchQuery)
        }
        self.searchTask = task
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
    }
    
    private func loadReposTask(_ searchQuery: String) {
        let search = GitHubSearchRepos(searchQuery: searchQuery)
        let client = GitHubClient()
        searchQueue.async { [weak self] in
            guard let self = self else { return }
            client.searchRepos(search) { result in
                switch result {
                case .success(let response):
                    self.repos = response.items.map {
                        Repo(repoName: $0.fullName,
                             url: URL(string: $0.htmlURL)) }
                    self.finishedLoading?()
                case .failure(let error):
                    print("error in result: \(error) \(error.localizedDescription)")
                    self.finishedLoading?()
                    
                }
            }
        }
    }
}
