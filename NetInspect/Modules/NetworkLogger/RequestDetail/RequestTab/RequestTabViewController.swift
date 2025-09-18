//
//  RequestTabViewController.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 29/8/25.
//

import UIKit

class RequestTabViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var log: NetworkLog!

    let sections: [RequestSection] = [.general, .header, .body]
    let generalRows: [RequestGeneralRow] = [.url, .method, .status, .time, .duration]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.registerCell(HeaderTableViewCell.self)
        tableView.registerCell(RequestDetailTableViewCell.self)
        tableView.registerCell(RequestBodyTableViewCell.self)
    }

}

// MARK: - UITableView

extension RequestTabViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .general: return generalRows.count
        case .header: return log.request.allHTTPHeaderFields?.count ?? 0
        case .body: return log.request.hasBody ? 1 : 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeue(HeaderTableViewCell.self)
        cell.selectionStyle = .none

        let section = sections[section]
        cell.setup(section.text)

        return cell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        switch section {
        case .general:
            let cell = tableView.dequeue(RequestDetailTableViewCell.self, for: indexPath)
            cell.selectionStyle = .none

            let row = generalRows[indexPath.row]
            var value = ""

            switch row {
            case .url:
                value = log.request.url?.absoluteString ?? ""

            case .method:
                value = log.request.httpMethod ?? ""

            case .status:
                if let response = log.response as? HTTPURLResponse {
                    let code = response.statusCode
                    value = code < 400 ? "\(code) OK" : "\(code) Error"
                }

            case .time:
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                value = formatter.string(from: log.timestamp)

            case .duration:
                value = String(format: "%.2fs", log.duration)
            }

            cell.setup(title: row.text, value: value)

            return cell

        case .header:
            let cell = tableView.dequeue(RequestDetailTableViewCell.self, for: indexPath)
            cell.selectionStyle = .none

            let headers = log.request.allHTTPHeaderFields ?? [:]
            let fields = headers.sorted { $0.key.lowercased() < $1.key.lowercased() }
            let field = fields[indexPath.row]
            cell.setup(title: field.key, value: field.value)

            return cell

        case .body:
            let cell = tableView.dequeue(RequestBodyTableViewCell.self, for: indexPath)
            cell.selectionStyle = .none

            if let body = log.request.bodyData, !body.isEmpty {
                cell.setup(body.prettyPrintedJSON() ?? "binary (\(body.count) bytes)")
            }

            return cell
        }
    }

}
