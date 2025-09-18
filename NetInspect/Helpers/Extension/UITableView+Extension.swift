//
//  UITableView+Extension.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 30/8/25.
//

import UIKit

extension UITableView {

    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        let identifier = String(describing: type)
        let nib = UINib(nibName: identifier, bundle: Bundle(for: type))
        register(nib, forCellReuseIdentifier: identifier)
    }

    func dequeue<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type)
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }

    func dequeue<T: UITableViewCell>(_ type: T.Type = T.self) -> T {
        let identifier = String(describing: type)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }

}
