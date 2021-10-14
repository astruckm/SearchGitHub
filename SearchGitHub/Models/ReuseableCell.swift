//
//  ReuseableCell.swift
//  SearchGitHub
//
//  Created by Andrew Struck-Marcell on 10/13/21.
//

import Foundation

protocol ReusableCell {
    associatedtype T
    var viewData: T? { get set }
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        String(describing: String(describing: self))
    }
}
