//
//  NetworkLogger.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 28/8/25.
//

import Foundation

public class NetworkLogger {

    static var isEnabled = false
    private static var allowShakeViewer = false
    private static var logs = [NetworkLog]()
    private static let lock = NSLock()

    static func addLog(_ entry: NetworkLog) {
        lock.lock()
        defer { lock.unlock() }
        logs.insert(entry, at: 0)
    }

    static func allLogs() -> [NetworkLog] {
        lock.lock()
        defer { lock.unlock() }
        return logs
    }

    static func clearLogs() {
        lock.lock()
        defer { lock.unlock() }
        logs.removeAll()
    }

    static func handleShake() {
        guard allowShakeViewer else { return }

        ShakeDetector.presentViewer()
    }

}

extension NetworkLogger: NetworkLoggerProtocol {

    public static func start(enableShakeViewer: Bool = false) {
        guard !isEnabled else { return }

        isEnabled = true
        allowShakeViewer = enableShakeViewer

        URLProtocol.registerClass(LoggingURLProtocol.self)
        URLSessionConfiguration.swizzleLoggingConfig()
        print("🚀 [NetInspect] NetworkLogger started")
    }

    public static func stop() {
        isEnabled = false
        allowShakeViewer = false
        URLProtocol.unregisterClass(LoggingURLProtocol.self)
        print("🛑 [NetInspect] NetworkLogger stopped")
    }

}
