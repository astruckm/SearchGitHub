//
//  APIError.swift
//  SearchGitHub
//
//  Created by Andrew Struck-Marcell on 10/14/21.
//

import Foundation

enum APIError: Error {
    case fetchError(Error)
    case badServerResponse(Int)
    case decodingError(Error)
    case noData(String)
}
