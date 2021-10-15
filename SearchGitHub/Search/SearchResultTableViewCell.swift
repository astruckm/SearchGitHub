//
//  SearchResultTableViewCell.swift
//  SearchGitHub
//
//  Created by Andrew Struck-Marcell on 10/13/21.
//

import UIKit

struct SearchResultViewData {
    let name: String
}

class SearchResultTableViewCell: UITableViewCell, ReusableCell {
    typealias T = SearchResultViewData
    var viewData: SearchResultViewData? {
        willSet {
            self.textLabel?.text = newValue?.name
        }
    }
    
    
}
