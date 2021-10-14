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
    
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
