//
//  UIViewController+Extension.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 30/8/25.
//

import UIKit

extension UIViewController {

    static func fromNib() -> Self {
        let bundle = Bundle(for: Self.self)
        return Self(nibName: String(describing: Self.self), bundle: bundle)
    }

}
