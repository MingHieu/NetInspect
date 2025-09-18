//
//  RequestDetailTableViewCell.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 29/8/25.
//

import UIKit

class RequestDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(title: String, value: String) {
        lbTitle.text = title
        lbValue.text = value
    }

}
