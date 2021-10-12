//
//  GitHubClient.swift
//  SearchGitHub
//
//  Created by Andrew Struck-Marcell on 10/12/21.
//

import Foundation

class GitHubClient {
    func searchRepos(_ search: GitHubSearchRepos, completion: @escaping ((Result<SearchReposResponse, Error>) -> Void)) {
        guard let request = search.createRequest() else { return }
        print(request.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("error: ", error.localizedDescription)
            }
            print(response)
            guard let data = data else { print("no data"); return }
            do {
                let response = try self.decode(data)
                completion(.success(response))
            } catch {
                print("decoding error: ", error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func decode(_ data: Data) throws -> SearchReposResponse {
        return try JSONDecoder().decode(SearchReposResponse.self, from: data)
    }
}
