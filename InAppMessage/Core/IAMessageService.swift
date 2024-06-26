//
//  IAMessageService.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/22.
//

import UIKit

class IAMessageService: NSObject {
    static let shared = IAMessageService()

    private var currentPresenter: IAMessagePresenter?

    static func show(_ view: IAMessageView, config: IAMessageConfig) {
        shared.show(view, config: config)
    }

    static func hide() {
        shared.hide()
    }

    private func show(_ view: IAMessageView, config: IAMessageConfig) {
        hide()

        let presenter = IAMessagePresenter(config: config)
        presenter.delegate = self
        presenter.show(view: view)

        currentPresenter = presenter
    }

    private func hide() {
        guard let currentPresenter else { return }
        currentPresenter.hide()
    }
}

// MARK: - PresenterEventDelegate

extension IAMessageService: PresenterEventDelegate {
    func willShow(_: IAMessagePresenter) {}

    func didShow(_: IAMessagePresenter) {}

    func willHidden(_: IAMessagePresenter) {}

    func didHidden(_ presenter: IAMessagePresenter) {
        if currentPresenter === presenter {
            currentPresenter = nil
        }
    }
}

extension IAMessageService {
    static let showNotifyNotification = Notification.Name(rawValue: "showNotifyNotification")
}
