//
//  String+Helpers.swift
//  Thuqey
//
//  Created by Eslam on 1/14/19.
//  Copyright © 2019 magdsoft. All rights reserved.
//

import UIKit

extension String {
    var url: URL? {
        return URL(string: self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed) ?? "")
    }
    
    var validUrlString: String {
        return self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed) ?? ""
    }
    
    var withoutSpaces: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

//MARK: - Helper methods
extension String {
    func display() {
        SnackBar.shared.show(message: self)
    }
}
