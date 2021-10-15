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
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 15
        config.httpAdditionalHeaders = ["Accept": "application/vnd.github.v3+json"]
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(APIError.fetchError(error)))
            }
            if let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode, (statusCode < 200 || statusCode >= 300) {
                completion(.failure(APIError.badServerResponse(statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(APIError.noData("No data fetched")))
                return
            }
            do {
                let response = try self.decode(data)
                completion(.success(response))
            } catch {
                print("decoding error: ", error.localizedDescription)
                completion(.failure(APIError.decodingError(error)))
            }
        }
        task.resume()
    }
    
    func decode(_ data: Data) throws -> SearchReposResponse {
        return try JSONDecoder().decode(SearchReposResponse.self, from: data)
    }
}
