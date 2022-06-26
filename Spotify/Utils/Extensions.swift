//
//  Extensions.swift
//  Spotify
//
//  Created by MAC on 14/06/2022.
//

import Foundation
import UIKit

extension UIView {
    public var width:CGFloat {
        return self.frame.size.width
    }
    
    public var height:CGFloat {
        return self.frame.size.height
    }
    
    public var top :CGFloat{
        return self.frame.origin.y
    }
    
    public var bottom:CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    public var left:CGFloat {
        return self.frame.origin.x
    }
    
    public var right :CGFloat{
        return self.frame.origin.x + self.frame.size.width
    }
}

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateForamtter = DateFormatter()
        dateForamtter.dateFormat = "YYYY-MM-dd"
        return dateForamtter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let dateForamtter = DateFormatter()
        dateForamtter.dateStyle = .medium
        return dateForamtter
    }()
}

extension String {
    static func formattedDate(dateString: String) -> String {
        guard let date = DateFormatter.dateFormatter.date(from: dateString) else {
            return dateString
        }
        
        return DateFormatter.displayDateFormatter.string(from: date)
    }
}
