//
//  WKHTTPCookieStoreViewController.swift
//  CookieMonster
//
//  Created by Stephen Yao on 28/3/20.
//  Copyright © 2020 silverbear. All rights reserved.
//

import UIKit
import WebKit

final class WKHTTPCookieStoreViewController: UITableViewController {
  
  var cookies: [HTTPCookie] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseID")
    
    WKWebsiteDataStore.default().httpCookieStore.getAllCookies {
      self.cookies = $0
      self.tableView.reloadData()
    }
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cookies.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cookie = cookies[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseID")
    cell?.textLabel?.text = "\(cookie.name): \(cookie.domain)/\(cookie.path), value: \(cookie.value)"
    
    return cell!
  }
  
  @IBAction func closeButtonTapped(_ sender: Any) {
    self.presentingViewController?.dismiss(animated: true, completion: nil)
  }
}
