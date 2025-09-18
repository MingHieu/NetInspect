//
//  RequestViewController.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 28/8/25.
//

import UIKit

class RequestViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var onDismiss: (() -> Void)?

    let logs = NetworkLogger.allLogs()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Requests"

        tableView.registerCell(RequestTableViewCell.self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        onDismiss?()
    }

}

// MARK: - UITableView
extension RequestViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        logs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(RequestTableViewCell.self, for: indexPath)
        cell.selectionStyle = .none

        let log = logs[indexPath.row]
        cell.setup(log)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let log = logs[indexPath.row]
        let vc = RequestDetailViewController.fromNib()
        vc.log = log
        navigationController?.pushViewController(vc, animated: true)
    }

}
