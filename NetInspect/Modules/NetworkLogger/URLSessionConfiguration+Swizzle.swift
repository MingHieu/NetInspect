//
//  URLSessionConfiguration+Swizzle.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 28/8/25.
//

import Foundation

extension URLSessionConfiguration {

    static func swizzleLoggingConfig() {
        let swizzlePairs: [(Selector, Selector)] = [
            (#selector(getter: URLSessionConfiguration.default),
             #selector(URLSessionConfiguration.swizzled_default)),
            (#selector(getter: URLSessionConfiguration.ephemeral),
             #selector(URLSessionConfiguration.swizzled_ephemeral)),
        ]

        for (original, swizzled) in swizzlePairs {
            guard let origMethod = class_getClassMethod(URLSessionConfiguration.self, original),
                  let swzMethod = class_getClassMethod(URLSessionConfiguration.self, swizzled) else { continue }

            method_exchangeImplementations(origMethod, swzMethod)
        }
    }

    @objc class func swizzled_default() -> URLSessionConfiguration {
        let config = swizzled_default()
        config.injectLoggingIfNeeded()
        return config
    }

    @objc class func swizzled_ephemeral() -> URLSessionConfiguration {
        let config = swizzled_ephemeral()
        config.injectLoggingIfNeeded()
        return config
    }

    private func injectLoggingIfNeeded() {
        guard NetworkLogger.isEnabled,
              !(protocolClasses?.contains { $0 == LoggingURLProtocol.self } ?? false) else { return }

        protocolClasses = [LoggingURLProtocol.self] + (protocolClasses ?? [])
    }

}
