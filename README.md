# 📡 NetInspect SDK  

**NetInspect** is a lightweight iOS SDK for monitoring and debugging network requests.  

---

## ✨ Features  

- Detects current network status (WiFi, Cellular, or None).  
- Monitors connectivity changes with callbacks.  
- Logs all outgoing requests & incoming responses (method, URL, headers, body).  
- Optional UI inspector for viewing logs directly inside your app.  

---

## 📚 API Reference  

### `NetworkConnection`  

Monitors device network connection.  

| Property / Method | Type | Description |
|-------------------|------|-------------|
| `isConnected` | `Bool` | Whether device is connected to the internet. |
| `networkType` | `NetworkType` | Current network type (`.wifi`, `.cellular`, `.none`). |
| `isWiFi` | `Bool` | Convenience flag for WiFi connection. |
| `isCellular` | `Bool` | Convenience flag for Cellular connection. |
| `onStatusChange` | `((Bool, NetworkType) -> Void)?` | Callback when connection changes. |
| `startMonitoring()` | `Void` | Starts observing network status. |
| `stopMonitoring()` | `Void` | Stops observing network status. |

---

### `NetworkLogger`  

Logs HTTP/HTTPS requests and responses.  

| Method | Description |
|--------|-------------|
| `start(enableShakeViewer: Bool)` | Starts logging. If `enableShakeViewer` is `true`, users can shake device to open the log viewer. |
| `stop()` | Stops logging and clears listeners. |

---

## 🚀 Example Usage  

```swift
import NetInspect

// MARK: - Network Connection Monitoring
NetworkConnection.startMonitoring()

// Get current status
print("Connected: \(NetworkConnection.isConnected)")
print("Type: \(NetworkConnection.networkType)")

// Listen for changes
NetworkConnection.onStatusChange = { isConnected, type in
    print("📡 Status: \(isConnected ? "Online" : "Offline") via \(type)")
}

// MARK: - Network Logging
NetworkLogger.start(enableShakeViewer: true)

// Example request
let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
var request = URLRequest(url: url)
request.httpMethod = "POST"
request.httpBody = """
{
  "title": "foo",
  "body": "bar",
  "userId": 1
}
""".data(using: .utf8)

URLSession.shared.dataTask(with: request) { data, response, error in
    // NetInspect will log everything automatically
}.resume()
