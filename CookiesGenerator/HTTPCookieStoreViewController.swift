//
//  CookiesReaderViewController.swift
//  CookiesGenerator
//
//  Created by Stephen Yao on 27/3/20.
//  Copyright © 2020 silverbear. All rights reserved.
//

import UIKit

final class HTTPCookieStoreViewController: UITableViewController {
  
  var cookies: [HTTPCookie] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseID")
    
    let cookies = HTTPCookieStorage.shared.cookies!.compactMap { $0 }
    self.cookies = cookies    
    tableView.reloadData()
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
