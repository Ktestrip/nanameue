//
//  CreatePostViewControllerTests.swift
//  NanameueTests
//
//  Created by Frqnck  on 03/09/2022.
//

import Foundation
@testable import Nanameue
import XCTest

class CreatePostViewControllerTests: XCTestCase {
    
    private func setupView() -> CreatePostViewController {
        let vc = ViewProvider.getViewController(view: .createPostViewController(onPostCreated: { _ in }))
        //to trigger view will appear on vc, just add it to a view
        let view = UIView()
        view.addSubview(vc.view)
        return vc as! CreatePostViewController
    }
    
    func testUISetup() {
        let vc = self.setupView()
      
        XCTAssertEqual(vc.sharePostButton.title(for: .normal), "create_share_post".translate)
        XCTAssertEqual(vc.sharePostButton.backgroundColor,  AssetsColor.mainColorDark)
        XCTAssertEqual(vc.openPhotoButton.title(for: .normal), "create_add_picture".translate)
        XCTAssertEqual(vc.openPhotoButton.backgroundColor,  AssetsColor.mainColorDark)
        XCTAssertEqual(vc.textViewContainer.backgroundColor,  AssetsColor.mainColorDark)
        XCTAssertEqual(vc.imageContainerHeight.constant, 0)
    }
    
    func testShareButtonIsDisable() {
        let vc = self.setupView()
        
        XCTAssertFalse(vc.sharePostButton.isEnabled)
    }
    
    func testShareButtonIsEnableIfTextIsInput() {
        let vc = self.setupView()
        vc.postTextView.text = "1"
        vc.textViewDidChange(vc.postTextView)
        
        XCTAssertTrue(vc.sharePostButton.isEnabled)
    }
    
    func testShareButtonIsDisableIfTextIsInputIsEmpty() {
        let vc = self.setupView()
        vc.postTextView.text = "1"
        vc.textViewDidChange(vc.postTextView)
        
        XCTAssertTrue(vc.sharePostButton.isEnabled)
        
        vc.postTextView.text = ""
        vc.textViewDidChange(vc.postTextView)
        
        XCTAssertFalse(vc.sharePostButton.isEnabled)
    }
    
    func testShareButtonIsDisableIfNoImage() {
        let vc = self.setupView()
        vc.postImageView.image = nil
        
        XCTAssertFalse(vc.sharePostButton.isEnabled)
    }
    
    func testShareButtonIsEnableIfImage() {
        let vc = self.setupView()
        vc.imagePickerController(UIImagePickerController(), didFinishPickingMediaWithInfo: [UIImagePickerController.InfoKey.originalImage: UIImage()])
        
        XCTAssertTrue(vc.sharePostButton.isEnabled)
    }
    
    func testShareButtonIsEnableIfImageAndText() {
        let vc = self.setupView()
        vc.postTextView.text = "1"
        vc.textViewDidChange(vc.postTextView)
        vc.postImageView.image = UIImage()
        
        XCTAssertTrue(vc.sharePostButton.isEnabled)
    }
    
    func testAddingImageDoesTriggerConstraintsChange() {
        let vc = self.setupView()
        let originConstant = vc.imageContainerHeight.constant
        vc.imagePickerController(UIImagePickerController(), didFinishPickingMediaWithInfo: [UIImagePickerController.InfoKey.originalImage: UIImage()])
        
        XCTAssertNotEqual(originConstant, vc.imageContainerHeight.constant)
    }
    
    func testCloseButtonIsAddedToView() {
        let vc = self.setupView()
        let numberOfView = vc.view.subviews.count
        vc.imagePickerController(UIImagePickerController(), didFinishPickingMediaWithInfo: [UIImagePickerController.InfoKey.originalImage: UIImage()])
    
        XCTAssertNotEqual(numberOfView, vc.view.subviews.count)
    }
    
    func testCloseButtonTapRemoveImage() {
        let vc = self.setupView()
        let numberOfView = vc.view.subviews.count
        vc.imagePickerController(UIImagePickerController(), didFinishPickingMediaWithInfo: [UIImagePickerController.InfoKey.originalImage: UIImage()])
        
        XCTAssertNotEqual(numberOfView, vc.view.subviews.count)
        XCTAssertNotNil(vc.postImageView.image)
        XCTAssertNotEqual(vc.imageContainerHeight.constant, 0)
        
        let button = vc.view.subviews.last! as! UIButton // lastly added view is our UIButton
        button.sendActions(for: .touchUpInside)
        
        // number of subview should be back as original since button has been remove
        XCTAssertEqual(numberOfView, vc.view.subviews.count)
        XCTAssertNil(vc.postImageView.image)
        XCTAssertEqual(vc.imageContainerHeight.constant, 0)
    }
    
    func testCreatePostTriggerCallback() {
        let vc = self.setupView()
        let post = Post(content: "test post")
        let mock = PostProviderMock()
        vc.postProvider = mock
        mock.postThatShouldBeReturn = post
        
        let expectation = self.expectation(description: #function)
        vc.onPostCreated = { returnedPost in
            expectation.fulfill()
            XCTAssertEqual(returnedPost.content, post.content)
        }
        vc.postTextView.text = "only to match criteria to unlock share post possibility"
        vc.textViewDidChange(vc.postTextView)
        vc.sharePostButton.sendActions(for: .touchUpInside)
        waitForExpectations(timeout: 0.5)
    }
    
    func testNoMoreTexButImageShareShouldBeEnable() {
        let vc = self.setupView()
        vc.postTextView.text = "only to match criteria to unlock share post possibility"
        vc.textViewDidChange(vc.postTextView)
        vc.postImageView.image = UIImage()
        XCTAssertTrue(vc.sharePostButton.isEnabled)
        vc.postTextView.text = ""
        vc.textViewDidChange(vc.postTextView)
        XCTAssertTrue(vc.sharePostButton.isEnabled)
    }
    
    func testNoMoreTexNoMoreImageShareShouldBeDisable() {
        let vc = self.setupView()
        vc.postTextView.text = "only to match criteria to unlock share post possibility"
        vc.textViewDidChange(vc.postTextView)
        vc.imagePickerController(UIImagePickerController(), didFinishPickingMediaWithInfo: [UIImagePickerController.InfoKey.originalImage: UIImage()])
        XCTAssertTrue(vc.sharePostButton.isEnabled)
        
        vc.postTextView.text = ""
        vc.textViewDidChange(vc.postTextView)
        //only text has been remove, we're still allow to post
        XCTAssertTrue(vc.sharePostButton.isEnabled)
        
        let button = vc.view.subviews.last! as! UIButton // lastly added view is our UIButton
        button.sendActions(for: .touchUpInside)
        
        //sending action to the button did remove the picture, button shouldn't be enable anymore
        XCTAssertFalse(vc.sharePostButton.isEnabled)
    }
}
