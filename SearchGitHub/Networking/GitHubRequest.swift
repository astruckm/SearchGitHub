//
//  GitHubRequest.swift
//  SearchGitHub
//
//  Created by Andrew Struck-Marcell on 10/12/21.
//

import Foundation

struct GitHubSearchRepos {
    let baseURL = "https://api.github.com"
    let path = "/search/repositories"
    var searchQuery: String
    var sortOption: GitHubSortOption?
    var isDescending: Bool?
    var resultsPerPage: UInt8?
    var numPages: UInt?
    
    func createRequest() -> URLRequest? {
        guard var components = URLComponents(string: baseURL) else { return nil }
        components.path = path
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "q", value: searchQuery))
        if let sortOption = sortOption {
            queryItems.append(URLQueryItem(name: "sort", value: sortOption.rawValue))
        }
        if let isDescending = isDescending {
            queryItems.append(URLQueryItem(name: "order", value: isDescending ? "desc" : "asc"))
        }
        if let resultsPerPage = resultsPerPage, let numPages = numPages {
            queryItems.append(URLQueryItem(name: "per_page", value: String(resultsPerPage)))
            queryItems.append(URLQueryItem(name: "page", value: String(numPages)))
        } else {
            queryItems.append(URLQueryItem(name: "per_page", value: "100"))
            queryItems.append(URLQueryItem(name: "page", value: "1"))
        }
        components.queryItems = queryItems
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }
}

enum GitHubSortOption: String, CaseIterable {
    case stars = "stars"
    case forks = "forks"
    case helpWantedIssues = "help-wanted-issues"
    case updated = "updated"
}
