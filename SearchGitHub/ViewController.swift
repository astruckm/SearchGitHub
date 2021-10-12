//
//  ViewController.swift
//  SearchGitHub
//
//  Created by Andrew Struck-Marcell on 10/11/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let search = GitHubSearchRepos(searchQuery: "tetris+language:assembly")
        let client = GitHubClient()
        client.searchRepos(search) { result in
            switch result {
            case .success(let response): print(response.totalCount)
            case .failure(let error): print("error in result: ", error)
            }
        }
    }


}

