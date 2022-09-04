//
//  PostTableViewCellTests.swift
//  NanameueTests
//
//  Created by Frqnck  on 04/09/2022.
//

import UIKit
import XCTest
@testable import Nanameue

class PostTableViewCellTests: XCTestCase {
    
    func testSetupViewNoImage() {
        let tableView = TableViewControllerTest(nib: PostTableViewCell.nib, identifier: PostTableViewCell.identifier)
        let cell = tableView.createCell(indexPath: IndexPath(row: 0, section: 0)) as! PostTableViewCell
        let post = Post(content: "test")
        cell.setupCell(post: post) { _ in }
        XCTAssertEqual(cell.contentLabel.text, "test")
        XCTAssertNotEqual(cell.dateLabel.text, "")
        XCTAssertEqual(cell.imageViewHeightConstraint.constant, 0)
    }
    
    func testSetupViewWithImage() {
        let tableView = TableViewControllerTest(nib: PostTableViewCell.nib, identifier: PostTableViewCell.identifier)
        let cell = tableView.createCell(indexPath: IndexPath(row: 0, section: 0)) as! PostTableViewCell
        let post = Post(content: "test")
        post.setImageUrl(url: URL(fileURLWithPath: ""))
        cell.setupCell(post: post) { _ in}
        XCTAssertEqual(cell.contentLabel.text, "test")
        XCTAssertNotEqual(cell.dateLabel.text, "")
        XCTAssertNotEqual(cell.imageViewHeightConstraint.constant, 0)
        XCTAssertEqual(cell.imageViewHeightConstraint.constant, 128)
    }
    
    func testDeleteButtonImage() {
        let tableView = TableViewControllerTest(nib: PostTableViewCell.nib, identifier: PostTableViewCell.identifier)
        let cell = tableView.createCell(indexPath: IndexPath(row: 0, section: 0)) as! PostTableViewCell
        XCTAssertNotNil(cell.deleteButton.imageView)
        XCTAssertEqual(cell.deleteButton.title(for: .normal), "")
    }
    
    func testDeleteActionIsTrigger() {
        let tableView = TableViewControllerTest(nib: PostTableViewCell.nib, identifier: PostTableViewCell.identifier)
        let cell = tableView.createCell(indexPath: IndexPath(row: 0, section: 0)) as! PostTableViewCell
        let post = Post(content: "test")
        let expectation = self.expectation(description: #function)
        cell.setupCell(post: post) { _ in
            expectation.fulfill()
        }
        cell.deleteButton.sendActions(for: .touchUpInside)
        waitForExpectations(timeout: 0.5)
    }
}
