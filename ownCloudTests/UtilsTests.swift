//
//  UtilsTesting.swift
//  ownCloud
//
//  Created by Javier Gonzalez on 06/11/2018.
//  Copyright © 2018 ownCloud GmbH. All rights reserved.
//

import Foundation
import ownCloudSDK

@testable import ownCloud

class UtilsTests {

	static func deleteAllBookmarks() {

		if let bookmarks:[OCBookmark] = OCBookmarkManager.shared?.bookmarks as? [OCBookmark] {
			for bookmark:OCBookmark in bookmarks {
				OCCoreManager.shared.scheduleOfflineOperation({ (inBookmark, completionHandler) in
					if let bookmark = inBookmark {
						let vault : OCVault = OCVault(bookmark: bookmark)

						vault.erase(completionHandler: { (_, error) in
							DispatchQueue.main.async {
								if error == nil {
									OCBookmarkManager.shared.removeBookmark(bookmark)
								} else {
									print("Error deleting bookmarks")
								}
							}
						})
					}
				}, for: bookmark)
			}
		}

		OCBookmarkManager.shared.bookmarks.removeAllObjects()
	}

	static func removePasscode() {
		AppLockManager.shared.passcode = nil
		AppLockManager.shared.lockEnabled = false
		AppLockManager.shared.biometricalSecurityEnabled = false
		AppLockManager.shared.lockDelay = SecurityAskFrequency.always.rawValue
		AppLockManager.shared.dismissLockscreen(animated: false)
	}

	static func showNoServerMessageServerList() {
		let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
		appDelegate.serverListTableViewController?.updateNoServerMessageVisibility()
	}
}