//
//  CreateBookmarkTests.swift
//  ownCloudTests
//
//  Created by Javier Gonzalez on 23/10/2018.
//  Copyright © 2018 ownCloud GmbH. All rights reserved.
//

import XCTest
import EarlGrey
import ownCloudSDK
import ownCloudMocking

@testable import ownCloud

class CreateBookmarkTests: XCTestCase {

	public typealias OCMPrepareForSetupCompletionHandler = @convention(block)
		(_ issue: OCConnectionIssue, _ suggestedURL: NSURL, _ supportedMethods: [OCAuthenticationMethodIdentifier], _ preferredAuthenticationMethods: [OCAuthenticationMethodIdentifier]) -> Void

	public typealias OCMPrepareForSetup = @convention(block)
		(_ options: NSDictionary, _ completionHandler: OCMPrepareForSetupCompletionHandler) -> Void

	public typealias OCMGenerateAuthenticationDataWithMethodCompletionHandler = @convention(block)
		(_ error: NSError?, _ authenticationMethodIdentifier: OCAuthenticationMethodIdentifier, _ authenticationData: NSData?) -> Void

	public typealias OCMGenerateAuthenticationDataWithMethod = @convention(block)
		(_ methodIdentifier: OCAuthenticationMethodIdentifier, _ options: OCAuthenticationMethodBookmarkAuthenticationDataGenerationOptions, _ completionHandler: OCMGenerateAuthenticationDataWithMethodCompletionHandler) -> Void

	override func setUp() {
		super.setUp()
		UtilsTests.deleteAllBookmarks()
		UtilsTests.showNoServerMessageServerList()
	}

	override func tearDown() {
		super.tearDown()
	}

	func testCheckURLServerBasicAuth () {

		let mockUrlServer = "http://mocked.owncloud.server.com"
		let authMethods: [OCAuthenticationMethodIdentifier] = [OCAuthenticationMethodBasicAuthIdentifier as NSString,
															   OCAuthenticationMethodOAuth2Identifier as NSString]
		let issue: OCConnectionIssue = OCConnectionIssue(forError: NSError(domain: "mocked.owncloud.server.com", code: 1033, userInfo: [NSLocalizedDescriptionKey: "Error description"]), level: .warning, issueHandler: nil)

		//Mock
		mockOCConnctionPrepareForSetup(mockUrlServer: mockUrlServer, authMethods: authMethods, issue: issue)

		//Actions
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("addServer")).perform(grey_tap())
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-url-url")).perform(grey_replaceText(mockUrlServer))
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-continue-continue")).perform(grey_tap())
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("approve-button")).perform(grey_tap())

		//Assert
		let isServerChecked = GREYCondition(name: "Wait for server is checked", block: {
			var error: NSError?

			EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-url-url")).assert(grey_sufficientlyVisible(), error: &error)
			EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-credentials-username")).assert(grey_sufficientlyVisible(), error: &error)
			EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-credentials-password")).assert(grey_sufficientlyVisible(), error: &error)

			return error == nil
		}).wait(withTimeout: 5.0, pollInterval: 0.5)

		GREYAssertTrue(isServerChecked, reason: "Failed check the server")

		//Reset status
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("cancel")).perform(grey_tap())
	}

	func testCheckURLServerOauth2 () {

		let mockUrlServer = "http://mocked.owncloud.server.com"
		let authMethods: [OCAuthenticationMethodIdentifier] = [OCAuthenticationMethodOAuth2Identifier as NSString,
															   OCAuthenticationMethodBasicAuthIdentifier as NSString]
		let issue: OCConnectionIssue = OCConnectionIssue(forError: NSError(domain: "mocked.owncloud.server.com", code: 1033, userInfo: [NSLocalizedDescriptionKey: "Error description"]), level: .warning, issueHandler: nil)

		//Mock
		mockOCConnctionPrepareForSetup(mockUrlServer: mockUrlServer, authMethods: authMethods, issue: issue)

		//Actions
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("addServer")).perform(grey_tap())
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-url-url")).perform(grey_replaceText(mockUrlServer))
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-continue-continue")).perform(grey_tap())
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("approve-button")).perform(grey_tap())

		//Assert
		let isServerChecked = GREYCondition(name: "Wait for server is checked", block: {
			var error: NSError?

			EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-url-url")).assert(grey_sufficientlyVisible(), error: &error)
			EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-credentials-username")).assert(grey_notVisible(), error: &error)
			EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-credentials-password")).assert(grey_notVisible(), error: &error)

			return error == nil
		}).wait(withTimeout: 5.0, pollInterval: 0.5)

		GREYAssertTrue(isServerChecked, reason: "Failed check the server")

		//Reset status
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("cancel")).perform(grey_tap())
	}

	func testBasicAuthLoginRightCredentials () {

		let mockUrlServer = "http://mocked.owncloud.server.com"
		let userName = "test"
		let password = "test"
		let authMethods: [OCAuthenticationMethodIdentifier] = [OCAuthenticationMethodBasicAuthIdentifier as NSString,
															   OCAuthenticationMethodOAuth2Identifier as NSString]
		let issue: OCConnectionIssue = OCConnectionIssue(forError: NSError(domain: "mocked.owncloud.server.com", code: 1033, userInfo: [NSLocalizedDescriptionKey: "Error description"]), level: .warning, issueHandler: nil)

		//Mock
		mockOCConnctionPrepareForSetup(mockUrlServer: mockUrlServer, authMethods: authMethods, issue: issue)
		mockOCConnectionGenerateAuthenticationDataWithMethodBasic()

		//Actions
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("addServer")).perform(grey_tap())
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-url-url")).perform(grey_replaceText(mockUrlServer))
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-continue-continue")).perform(grey_tap())
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("approve-button")).perform(grey_tap())
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-credentials-username")).perform(grey_replaceText(userName))
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-credentials-password")).perform(grey_replaceText(password))
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-continue-continue")).perform(grey_tap())

		//Assert
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("server-bookmark-cell")).assert(grey_sufficientlyVisible())
	}

	func testOauth2LoginRightCredentials () {

		let mockUrlServer = "http://mocked.owncloud.server.com"
		let authMethods: [OCAuthenticationMethodIdentifier] = [OCAuthenticationMethodOAuth2Identifier as NSString,
															   OCAuthenticationMethodBasicAuthIdentifier as NSString]
		let issue: OCConnectionIssue = OCConnectionIssue(forError: NSError(domain: "mocked.owncloud.server.com", code: 1033, userInfo: [NSLocalizedDescriptionKey: "Error description"]), level: .warning, issueHandler: nil)

		//Mock
		mockOCConnctionPrepareForSetup(mockUrlServer: mockUrlServer, authMethods: authMethods, issue: issue)
		mockOCConnectionGenerateAuthenticationDataWithMethodBasic()

		//Actions
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("addServer")).perform(grey_tap())
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-url-url")).perform(grey_replaceText(mockUrlServer))
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-continue-continue")).perform(grey_tap())
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("approve-button")).perform(grey_tap())
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("row-continue-continue")).perform(grey_tap())

		//Assert
		EarlGrey.select(elementWithMatcher: grey_accessibilityID("server-bookmark-cell")).assert(grey_sufficientlyVisible())
	}

	// MARK: - Mocks
	func mockOCConnctionPrepareForSetup(mockUrlServer: String, authMethods: [OCAuthenticationMethodIdentifier], issue: OCConnectionIssue) {
		let completionHandlerBlock : OCMPrepareForSetup = {
			(dict, mockedBlock) in
			let url: NSURL = NSURL(fileURLWithPath: mockUrlServer)
			mockedBlock(issue, url, authMethods, authMethods)
		}

		OCMockManager.shared.addMocking(blocks:
			[OCMockLocation.ocConnectionPrepareForSetupWithOptions: completionHandlerBlock])
	}

	func mockOCConnectionGenerateAuthenticationDataWithMethodBasic() {
		let completionHandlerBlock : OCMGenerateAuthenticationDataWithMethod = {
			(methodIdentifier, options, mockedBlock) in

			let error:NSError? = nil
			let authenticationMethodIdentifier = OCAuthenticationMethodBasicAuthIdentifier as NSString

			let dictionary:Dictionary = ["BasicAuthString" : "Basic YWRtaW46YWRtaW4=",
										 "passphrase" : "admin",
										 "username" : "admin"]
			var data: Data? = nil
			do {
				data = try PropertyListSerialization.data(fromPropertyList: dictionary, format: .binary, options: 0)
			} catch {
				return
			}

			mockedBlock(error, authenticationMethodIdentifier, data! as NSData)
		}

		OCMockManager.shared.addMocking(blocks:
			[OCMockLocation.ocConnectionGenerateAuthenticationDataWithMethod: completionHandlerBlock])
	}
}