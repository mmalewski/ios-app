//
//  ownCloudTests.swift
//  ownCloudTests
//
//  Created by Pablo Carrascal on 07/03/2018.
//  Copyright © 2018 ownCloud. All rights reserved.
//

import XCTest
import EarlGrey
import ownCloudSDK
import ownCloudMocking

@testable import ownCloud

class OwnCloudTests: XCTestCase {

    override func setUp() {
        super.setUp()
		UtilsTests.deleteAllBookmarks()
		UtilsTests.showNoServerMessageServerList()
		OCMockManager.shared.removeAllMockingBlocks()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /*
     * Passed if: "Add Server" button is enabled
     */
    func testAddServerButtonIsEnabled() {
        EarlGrey.select(elementWithMatcher: grey_accessibilityID("addServer")).assert(with: grey_enabled())
    }

    func testClickOnTheButtonAndNothingHappens() {
        EarlGrey.select(elementWithMatcher: grey_accessibilityID("addServer")).perform(grey_tap())
        EarlGrey.select(elementWithMatcher: grey_accessibilityID("cancel")).perform(grey_tap())
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

	public typealias OCMockMockTestClassReturnsBool = @convention(block) () -> Bool

	func testMocking () {

		let mockTest = OCMockTestClass()

		XCTAssert(OCMockTestClass.returnsTrue()==true)
		XCTAssert(mockTest.returnsFalse()==false)

		let returnTrueBlock : OCMockMockTestClassReturnsBool = {return false}
		let returnFalseBlock : OCMockMockTestClassReturnsBool = {return true}

		OCMockManager.shared.addMocking(blocks:
			[OCMockLocation.mockTestClassReturnsTrue: returnTrueBlock,
			 OCMockLocation.mockTestClassReturnsFalse: returnFalseBlock])

		XCTAssert(OCMockTestClass.returnsTrue()==false)
		XCTAssert(mockTest.returnsFalse()==true)
	}
}
