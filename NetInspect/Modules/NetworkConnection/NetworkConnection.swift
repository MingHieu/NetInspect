//
//  NetworkConnection.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 28/8/25.
//

import CoreTelephony
import Foundation
import Network

public class NetworkConnection {

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetInspect.NetworkConnection")
    private let telephonyInfo = CTTelephonyNetworkInfo()

    public private(set) static var isConnected: Bool = false

    public private(set) static var networkType: NetworkType = .disconnected {
        didSet {
            if networkType != oldValue {
                let isConnected = (networkType != .disconnected)
                NetworkConnection.isConnected = isConnected
                print("🌐 [NetInspect] Network changed: \(networkType.emoji) \(networkType.displayName) \(isConnected ? "✅" : "❌")")
                onStatusChange?(isConnected, networkType)
            }
        }
    }

    public static var onStatusChange: ((Bool, NetworkType) -> Void)?

    private static let shared = NetworkConnection()

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let networkType = self?.determineNetworkType(path: path) ?? .disconnected
            NetworkConnection.networkType = networkType
        }
        monitor.start(queue: queue)
        print("🚀 [NetInspect] NetworkConnection monitoring started")
    }

    private func determineNetworkType(path: NWPath) -> NetworkType {
        guard path.status == .satisfied else { return .disconnected }

        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return determineCellularType()
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else {
            return .other
        }
    }

    private func determineCellularType() -> NetworkType {
        // Try to get cellular technology from CTTelephonyNetworkInfo
        if #available(iOS 12.0, *) {
            // iOS 12+ supports multiple carriers
            guard let serviceCurrentRadioAccessTechnology = telephonyInfo.serviceCurrentRadioAccessTechnology else {
                return .cellularUnknown
            }

            // Get the first available carrier's technology
            for (_, technology) in serviceCurrentRadioAccessTechnology {
                return mapRadioAccessTechnology(technology)
            }
        } else {
            // iOS 11 and below
            if let technology = telephonyInfo.currentRadioAccessTechnology {
                return mapRadioAccessTechnology(technology)
            }
        }

        return .cellularUnknown
    }

    private func mapRadioAccessTechnology(_ technology: String) -> NetworkType {
        switch technology {
        case CTRadioAccessTechnologyGPRS,
             CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyCDMA1x:
            return .cellular2G

        case CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD:
            return .cellular3G

        case CTRadioAccessTechnologyLTE:
            return .cellular4G

        default:
            // Check for 5G (iOS 14+)
            if #available(iOS 14.1, *) {
                switch technology {
                case CTRadioAccessTechnologyNRNSA,
                     CTRadioAccessTechnologyNR:
                    return .cellular5G
                default:
                    break
                }
            }
            return .cellularUnknown
        }
    }

}


extension NetworkConnection: NetworkConnectionProtocol {

    public static func startMonitoring() {
        _ = shared
    }

    public static func stopMonitoring() {
        shared.monitor.cancel()
        print("🛑 [NetInspect] NetworkConnection monitoring stopped")
    }

    public static var isWiFi: Bool {
        return networkType == .wifi
    }

    public static var isCellular: Bool {
        switch networkType {
        case .cellular2G, .cellular3G, .cellular4G, .cellular5G, .cellularUnknown:
            return true
        default:
            return false
        }
    }

}
