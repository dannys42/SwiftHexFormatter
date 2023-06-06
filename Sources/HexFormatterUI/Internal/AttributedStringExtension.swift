//
//  AttributedStringExtension.swift
//  
//
//  Created by Danny Sung on 5/26/23.
//

import Foundation

internal extension Array where Element == AttributedString {
    func joined(separator: AttributedString?=nil) -> AttributedString {
        var string = AttributedString()

        for (count, element) in self.enumerated() {
            let isLast = (count >= self.count-1)

            string.append(element)
            if !isLast, let separator {
                string.append(separator)
            }
        }

        return string
    }
}
