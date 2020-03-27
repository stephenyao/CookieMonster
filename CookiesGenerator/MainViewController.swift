//
//  ViewController.swift
//  CookiesGenerator
//
//  Created by Stephen Yao on 27/3/20.
//  Copyright © 2020 silverbear. All rights reserved.
//

import UIKit
import WebKit

class MainViewController: UIViewController, WKHTTPCookieStoreObserver {

  @IBOutlet var webview: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let request = URLRequest(url: URL(string: "https://www.google.com")!)
    webview.load(request)
    WKWebsiteDataStore.default().httpCookieStore.add(self)
  }
  
  
  @IBAction func generateCookieButtonTapped(_ sender: Any) {
    let cookie = HTTPCookie(properties: [
      HTTPCookiePropertyKey.domain: "https://www.foo.com.au",
      HTTPCookiePropertyKey.expires: Date.distantFuture,
      HTTPCookiePropertyKey.value: "1234",
      HTTPCookiePropertyKey.path: "/",
      HTTPCookiePropertyKey.secure: true,
      HTTPCookiePropertyKey.name: "footok`"
    ])
    
    HTTPCookieStorage.shared.setCookie(cookie!)
  }
  
  @IBAction func deleteAllCookiesButtonTapped(_ sender: Any) {
    HTTPCookieStorage.shared.cookies?.forEach {
      HTTPCookieStorage.shared.deleteCookie($0)
    }
    
    WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
      cookies.forEach { cookie in
        WKWebsiteDataStore.default().httpCookieStore.delete(cookie, completionHandler: nil)
      }
    }
  }
  
  @IBAction func printCookiesButtonTapped(_ sender: Any) {
    print("===========printing cookies")
    WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
      cookies.forEach { cookie in
        print("cookie: \(cookie.name), domain:\(cookie.domain), value: \(cookie.value), cookiePath: \(cookie.path), cookieSecure: \(cookie.isSecure), expiry: \(String(describing: cookie.expiresDate))")
      }
    }
  }
  
  @IBAction func syncCookiesButtonTapped(_ sender: Any) {
    let cookies = HTTPCookieStorage.shared.cookies!.compactMap { $0 }
    cookies.forEach { cookie in
      WKWebsiteDataStore.default().httpCookieStore.setCookie(cookie) {
        print("cookie \(cookie.name) has been synced!")
      }
    }
  }

  @IBAction func loadWebviewURLButtonTapped(_ sender: Any) {
    let alert = UIAlertController(title: "URL input", message: nil, preferredStyle: .alert)
    alert.addTextField { (textField) in
      textField.text = "https://www."
    }
    
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let ok = UIAlertAction(title: "OK", style: .default) { (action) in
      guard
        let textField = alert.textFields?.first,
        let text = textField.text,
        let url = URL(string: text) else {
        return
      }
      self.webview.load(URLRequest(url: url))
    }
    
    alert.addAction(cancel)
    alert.addAction(ok)
    present(alert, animated: true, completion: nil)
  }
  
  func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
    print("***************cookies did change!")
    cookieStore.getAllCookies { cookies in
      cookies.forEach { cookie in
        print("cookie: \(cookie.name), domain:\(cookie.domain), value: \(cookie.value), cookiePath: \(cookie.path), cookieSecure: \(cookie.isSecure), expiry: \(String(describing: cookie.expiresDate))")
      }
    }
  }
}

