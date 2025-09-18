//
//  Data+Extension.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 29/8/25.
//

extension Data {

    init(reading input: InputStream) {
        self.init()
        input.open()
        defer { input.close() }

        let bufferSize = 1024
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        defer { buffer.deallocate() }

        while input.hasBytesAvailable {
            let read = input.read(buffer, maxLength: bufferSize)
            if read > 0 {
                append(buffer, count: read)
            } else {
                break
            }
        }
    }

    func prettyPrintedJSON() -> String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let prettyData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
              let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            return nil
        }

        return prettyString
    }

}
