//
//  ViewController.swift
//  NetInspectIntegrated
//
//  Created by Lê Minh Hiếu on 28/8/25.
//

import Alamofire
import NetInspect
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkConnection.startMonitoring()
        NetworkLogger.start(enableShakeViewer: true)

        testURLSessionGET()
        testAlamofireGET()
        testURLSessionPOST()
        testAlamofirePOST()
    }

    func testURLSessionGET() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in }
        task.resume()
    }

    func testAlamofireGET() {
        AF.request("https://jsonplaceholder.typicode.com/todos/2").responseString { response in }
    }

    func testURLSessionPOST() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "title": "foo",
            "body": "bar",
            "userId": 1,
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in }
        task.resume()
    }

    func testAlamofirePOST() {
        let parameters: [String: Any] = [
            "title": "foo",
            "body": "bar",
            "userId": 2,
        ]

        AF.request("https://jsonplaceholder.typicode.com/posts",
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default).responseString { response in }
    }

}
