//
//  ProfileViewTests.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 18.10.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testAvatarUpdateCalled() {
        let profileViewController = ProfileViewController()
        let profilePresenterSpy = ProfilePresenterSpy()
        profilePresenterSpy.view = profileViewController
        profileViewController.presenter = profilePresenterSpy

        _ = profileViewController.view
        XCTAssertTrue(profilePresenterSpy.updateAvatarCalled)
    }

    func testProfileInfoIsSet() {
        let profileViewController = ProfileViewController()
        let profilePresenterSpy = ProfilePresenterSpy()
        profilePresenterSpy.view = profileViewController
        profileViewController.presenter = profilePresenterSpy

        _ = profileViewController.view
        XCTAssertEqual(profileViewController.nameLabel.text, "TestName")
        XCTAssertEqual(profileViewController.loginNameLabel.text, "TestLogin")
        XCTAssertEqual(profileViewController.descriptionLabel.text, "TestDescription")
    }
}


