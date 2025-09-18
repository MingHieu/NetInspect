//
//  ShakeDetector.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 28/8/25.
//

import UIKit

class ShakeDetector {

    private static var isPresenting = false

    static func presentViewer() {
        guard !isPresenting, let topVC = topViewController() else { return }

        isPresenting = true

        let vc = RequestViewController.fromNib()
        vc.onDismiss = { isPresenting = false }

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        topVC.present(nav, animated: true)
    }

    private static func topViewController(_ root: UIViewController? = UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController) -> UIViewController? {
        switch root {
        case let nav as UINavigationController: return topViewController(nav.visibleViewController)
        case let tab as UITabBarController: return topViewController(tab.selectedViewController)
        case let vc where vc?.presentedViewController != nil: return topViewController(vc?.presentedViewController)
        default: return root
        }
    }

}

extension UIWindow {

    @objc override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        if motion == .motionShake {
            NetworkLogger.handleShake()
        }
    }

}
