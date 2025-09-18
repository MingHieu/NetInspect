//
//  Protocols.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 29/8/25.
//

public enum NetworkType {
    case wifi
    case cellular2G
    case cellular3G
    case cellular4G
    case cellular5G
    case cellularUnknown
    case ethernet
    case other
    case disconnected

    public var displayName: String {
        switch self {
        case .wifi: return "WiFi"
        case .cellular2G: return "2G"
        case .cellular3G: return "3G"
        case .cellular4G: return "4G/LTE"
        case .cellular5G: return "5G"
        case .cellularUnknown: return "Cellular"
        case .ethernet: return "Ethernet"
        case .other: return "Other"
        case .disconnected: return "Disconnected"
        }
    }

    public var emoji: String {
        switch self {
        case .wifi: return "📶"
        case .cellular2G: return "📱"
        case .cellular3G: return "📱"
        case .cellular4G: return "📱"
        case .cellular5G: return "🚀"
        case .cellularUnknown: return "📱"
        case .ethernet: return "🔌"
        case .other: return "🌐"
        case .disconnected: return "❌"
        }
    }
}

struct NetworkLog {
    let request: URLRequest
    let response: URLResponse?
    let data: Data?
    let error: Error?
    let timestamp: Date
    let duration: TimeInterval
}

enum RequestSection {
    case general
    case header
    case body

    var text: String {
        switch self {
        case .general: return "General"
        case .header: return "Header"
        case .body: return "Body"
        }
    }
}

enum RequestGeneralRow {
    case url
    case method
    case status
    case time
    case duration

    var text: String {
        switch self {
        case .url: return "URL"
        case .method: return "Method"
        case .status: return "Status"
        case .time: return "Time"
        case .duration: return "Duration"
        }
    }
}

public protocol NetworkConnectionProtocol {
    static var isConnected: Bool { get }
    static var networkType: NetworkType { get }
    static var isWiFi: Bool { get }
    static var isCellular: Bool { get }
    static var onStatusChange: ((Bool, NetworkType) -> Void)? { get set }

    static func startMonitoring()
    static func stopMonitoring()
}

public protocol NetworkLoggerProtocol {
    static func start(enableShakeViewer: Bool)
    static func stop()
}
