//
//  URLRequest+Extension.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 30/8/25.
//

import Foundation

extension URLRequest {

    var bodyData: Data? {
        if let body = httpBody {
            return body
        } else if let stream = httpBodyStream {
            return Data(reading: stream)
        }
        return nil
    }

    var hasBody: Bool {
        return !(bodyData?.isEmpty ?? true)
    }

}
