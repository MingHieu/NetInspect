//
//  RequestBodyTableViewCell.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 29/8/25.
//

import UIKit

class RequestBodyTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setup(_ text: String) {
        textView.attributedText = text.highlightedJSON()
    }

}
