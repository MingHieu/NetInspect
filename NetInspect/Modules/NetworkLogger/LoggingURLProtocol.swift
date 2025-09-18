//
//  LoggingURLProtocol.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 28/8/25.
//

import Foundation

class LoggingURLProtocol: URLProtocol {

    private var dataTask: URLSessionDataTask?
    private var startTime = Date()

    override class func canInit(with request: URLRequest) -> Bool {
        // Only intercept once per request, and only when enabled
        URLProtocol.property(forKey: "logged", in: request) == nil && NetworkLogger.isEnabled
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        let mutableRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
        // Mark request as logged to avoid double handling
        URLProtocol.setProperty(true, forKey: "logged", in: mutableRequest)

        logRequest(request)

        // Create a clean config (disable protocol injection to prevent recursion)
        let config = URLSessionConfiguration.default
        if let protocols = config.protocolClasses {
            config.protocolClasses = protocols.filter { $0 != LoggingURLProtocol.self }
        }

        dataTask = URLSession(configuration: config).dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ [NetInspect] Error: \(error)")
                self.client?.urlProtocol(self, didFailWithError: error)
            } else {
                if let data = data { self.client?.urlProtocol(self, didLoad: data) }
                if let response = response {
                    self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                    self.logResponse(data: data, response: response)
                }
                self.client?.urlProtocolDidFinishLoading(self)
            }

            // Save log entry
            let entry = NetworkLog(
                request: self.request,
                response: response,
                data: data,
                error: error,
                timestamp: self.startTime,
                duration: Date().timeIntervalSince(self.startTime)
            )
            NetworkLogger.addLog(entry)
        }
        dataTask?.resume()
    }

    override func stopLoading() { dataTask?.cancel() }

    // MARK: - Logging Helpers

    private func logRequest(_ request: URLRequest) {
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? ""
        print("🌐 [NetInspect] \(method) \(url)")

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("📋 [NetInspect] Headers: \(headers)")
        }

        if let body = request.bodyData, !body.isEmpty {
            let bodyStr = String(data: body, encoding: .utf8) ?? "binary (\(body.count) bytes)"
            print("📄 [NetInspect] Body: \(bodyStr)")
        }
    }

    private func logResponse(data: Data?, response: URLResponse?) {
        let duration = Date().timeIntervalSince(startTime)

        if let http = response as? HTTPURLResponse {
            let emoji = http.statusCode < 400 ? "✅" : "❌"
            let url = http.url?.absoluteString ?? ""
            print("\(emoji) [NetInspect] \(http.statusCode) \(url) (\(String(format: "%.2fs", duration)))")
        }

        if let data = data, !data.isEmpty {
            let bodyStr = String(data: data, encoding: .utf8) ?? "binary (\(data.count) bytes)"
            print("📦 [NetInspect] Response: \(bodyStr)\n")
        }
    }

}
