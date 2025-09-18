//
//  RequestTableViewCell.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 28/8/25.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var lbMethod: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbUrl: UILabel!
    @IBOutlet weak var viewColorStatusCode: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(_ log: NetworkLog) {
        lbMethod.text = log.request.httpMethod
        lbUrl.text = log.request.url?.absoluteString

        if let response = log.response as? HTTPURLResponse {
            let ok = response.statusCode < 400
            lbStatus.text = " • \(response.statusCode) \(ok ? "OK" : "Error")"
            viewColorStatusCode.backgroundColor = ok ? .green : .red
        }
    }

}
