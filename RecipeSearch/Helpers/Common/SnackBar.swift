//
//  SnackBar.swift
//  Nashmi
//
//  Created by Eslam on 12/23/18.
//  Copyright © 2018 youssef. All rights reserved.
//

import Foundation
import TTGSnackbar

class SnackBar {
    static let shared: SnackBar = SnackBar()
    
    
    fileprivate lazy var snackbar: TTGSnackbar = {
        return getSnackBar()
    }()
    
    
    
    func show(message: String, withColor color: UIColor = .black) {
        snackbar.duration = .middle
        snackbar.message = message
        snackbar.backgroundColor = color
        snackbar.show()
    }
    
    
    private func getSnackBar() -> TTGSnackbar {
        let snackbar = TTGSnackbar(message: "", duration: .long)
        snackbar.leftMargin = 0
        snackbar.messageTextFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        snackbar.rightMargin = 0
        snackbar.animationType = .slideFromTopBackToTop
        snackbar.messageTextAlign = .center
        snackbar.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 8, right: 0)
        snackbar.messageTextColor = .white
        snackbar.backgroundColor = .red
        return snackbar
    }
}
