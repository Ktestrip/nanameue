//
//  TableViewControllerTest.swift
//  NanameueTests
//
//  Created by Frqnck  on 04/09/2022.
//

import Foundation
import UIKit
@testable import Nanameue

class TableViewControllerTest: UITableViewController {
    
    private var dataSource = TableViewDataSource()
    private var delegate = TableViewDelegate()
    
    init(nib: UINib, identifier: String) {
        super.init(style: .grouped)
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
        self.tableView.register(nib, forCellReuseIdentifier: identifier)
        dataSource.identifier = identifier
        self.tableView.delegate = delegate
        self.tableView.dataSource = dataSource
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCell(indexPath: IndexPath) -> UITableViewCell {
        let cell = dataSource.tableView(tableView, cellForRowAt: indexPath)
        return cell
    }
}

private class TableViewDataSource: NSObject, UITableViewDataSource {
    var identifier: String?
    var items = 1
    
    override init() {
        super.init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier!,
                                                 for: indexPath)
        return cell
    }
}

private class TableViewDelegate: NSObject, UITableViewDelegate {
    
}
