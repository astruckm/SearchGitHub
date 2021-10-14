//
//  UITextField+Extensions.swift
//  SearchGitHub
//
//  Created by Andrew Struck-Marcell on 10/13/21.
//

import UIKit

extension UITextField {
    func addSpaceBeforeText() {
        let leftView = UIView(frame: CGRect(x: 10, y: 0, width: 7, height: 26))
        leftView.backgroundColor = .clear
        self.leftView = leftView
        self.leftViewMode = .always
        self.contentVerticalAlignment = .center
    }
}
