//
//  String+Extension.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 29/8/25.
//

import UIKit

extension String {
    
    func highlightedJSON() -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: self)

        // Base style
        let baseFont = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        let baseAttrs: [NSAttributedString.Key: Any] = [
            .font: baseFont,
            .foregroundColor: UIColor.label,
        ]
        attributed.addAttributes(baseAttrs, range: NSRange(location: 0, length: attributed.length))

        // Regex patterns
        let patterns: [(String, UIColor)] = [
            ("\".*?\"(?=\\s*:)", .systemBlue), // Keys
            ("\".*?\"", .systemGreen), // String values
            ("\\b(true|false|null)\\b", .systemPurple), // Booleans / null
            ("\\b\\d+(\\.\\d+)?\\b", .systemOrange), // Numbers
        ]

        for (pattern, color) in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: attributed.length))
                for match in matches {
                    attributed.addAttribute(.foregroundColor, value: color, range: match.range)
                }
            }
        }

        return attributed
    }
    
}
