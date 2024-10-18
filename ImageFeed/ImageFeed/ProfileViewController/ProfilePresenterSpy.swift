//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Давид Бекоев on 18.10.2024.
//
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var updateAvatarCalled: Bool = false

    func viewDidLoad() {
        view?.setProfileInfo(name: "TestName", login: "TestLogin", bio: "TestDescription")
    }

    func avatarURL() -> URL? {
        updateAvatarCalled = true
        return nil
    }

    func logout() {

    }
}
