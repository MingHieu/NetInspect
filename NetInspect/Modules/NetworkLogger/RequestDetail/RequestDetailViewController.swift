//
//  RequestDetailViewController.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 28/8/25.
//

import UIKit

class RequestDetailViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var pageVCContainer: UIView!
    
    var log: NetworkLog!

    private var pageVC: UIPageViewController!
    private var pages: [UIViewController] = []
    private var activePage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = log.request.url {
            var components = url.pathComponents
            components.removeAll { c in
                c == "/" || c.lowercased() == "api" || c.lowercased().hasPrefix("v")
            }
            let titlePath = "/" + components.joined(separator: "/")
            let method = log.request.httpMethod ?? ""
            self.title = "\(method) \(titlePath)"
        }

        pageVC = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageVC.dataSource = self
        pageVC.delegate = self

        addChild(pageVC)
        pageVCContainer.addSubview(pageVC.view)
        pageVC.view.frame = pageVCContainer.bounds
        pageVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageVC.didMove(toParent: self)

        let requestTab = RequestTabViewController.fromNib()
        requestTab.log = log

        let responseTab = ResponseTabViewController.fromNib()
        responseTab.log = log

        pages = [requestTab, responseTab]
        pageVC.setViewControllers([pages[activePage]], direction: .forward, animated: false)
    }

    @IBAction func segmentChanged(_ sender: Any) {
        let index = segmentedControl.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection = (index < activePage) ? .reverse : .forward
        activePage = index
        pageVC.setViewControllers([pages[activePage]], direction: direction, animated: true)
    }
    
    @IBAction func copyCurlAction(_ sender: Any) {
        guard let request = log?.request else { return }

        var components = ["curl"]

        // Method
        if request.httpMethod != "GET" {
            components.append("-X \(request.httpMethod ?? "GET")")
        }

        // Headers
        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers {
                components.append("-H '\(key): \(value)'")
            }
        }

        // Body
        if let body = request.bodyData,
           let bodyString = String(data: body, encoding: .utf8)
        {
            components.append("--data '\(bodyString)'")
        }

        // URL
        if let url = request.url?.absoluteString {
            components.append("'\(url)'")
        }

        let curl = components.joined(separator: " \\\n  ")
        UIPasteboard.general.string = curl
        print("Copied cURL: \n\(curl)")
        
        let alert = UIAlertController(title: nil, message: "Copy cURL success", preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func copyResponseAction(_ sender: Any) {
        if let data = log?.data,
           let text = String(data: data, encoding: .utf8)
        {
            UIPasteboard.general.string = text
            print("Copied response body")
        } else if let error = log?.error {
            UIPasteboard.general.string = error.localizedDescription
            print("Copied error")
        } else {
            UIPasteboard.general.string = "No response data"
        }
        
        let alert = UIAlertController(title: nil, message: "Copy response success", preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }

}

// MARK: - UIPageViewController

extension RequestDetailViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool)
    {
        if completed, let currentVC = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: currentVC)
        {
            segmentedControl.selectedSegmentIndex = index
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }

        activePage = index - 1
        return pages[activePage]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }

        activePage = index + 1
        return pages[activePage]
    }
}
