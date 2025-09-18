//
//  ResponseTabViewController.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 29/8/25.
//

import UIKit

class ResponseTabViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    var log: NetworkLog!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let attributed = log.data?.prettyPrintedJSON()?.highlightedJSON() {
            textView.attributedText = attributed
        } else {
            textView.text = "Invalid JSON"
        }
    }

}
