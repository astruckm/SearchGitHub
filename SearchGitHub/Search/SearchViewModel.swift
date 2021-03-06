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
            self.reloadSearchResultsTableView?()
        }
    }
    var reloadSearchResultsTableView: (() -> Void)?
    var loadingRepos: (() -> Void)?
    var finishedLoading: (() -> Void)?
    let searchQueue = DispatchQueue(label: "searchQueue", qos: .userInteractive, attributes: .concurrent)
    var searchTask: DispatchWorkItem?
    var shouldCancelTask: Bool = false // Block the comletion of a cancelled searchTask
    let throttleInterval: TimeInterval = 0.5 // in seconds
    
    func loadRepos(searchQuery: String) {
        self.searchTask?.cancel()
        self.loadingRepos?()
        
        let task = DispatchWorkItem { [weak self] in
            self?.loadReposTask(searchQuery)
        }
        self.searchTask = task
        
        searchQueue.asyncAfter(deadline: .now() + throttleInterval, execute: task)
    }
    
    private func loadReposTask(_ searchQuery: String) {
        let search = GitHubSearchRepos(searchQuery: searchQuery)
        let client = GitHubClient()
        shouldCancelTask = false
        client.searchRepos(search) { [weak self] result in
            guard let self = self else { return }
            guard !self.shouldCancelTask else { return }
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
    
    func clearData() {
        self.finishedLoading?()
        self.repos = []
        self.shouldCancelTask = true
        self.searchTask?.cancel()
    }
}
