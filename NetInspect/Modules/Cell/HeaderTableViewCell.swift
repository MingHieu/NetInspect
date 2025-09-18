//
//  HeaderTableViewCell.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 29/8/25.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func setup(_ text: String) {
        lbTitle.text = text
    }

}
