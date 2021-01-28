//
//  IAMessageService.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/22.
//

import UIKit

class IAMessageService: NSObject {
    
    static let shared = IAMessageService()
    
    private lazy var notifyViewController = IANotifyViewController()
    private var currentPresenter: IAMessagePresenter?
    private var hiddenPresenter: IAMessagePresenter?
    
    static func show(_ view: IAMessageView, config: IAMessageConfig) {
        shared.show(view, config: config)
    }
    
    static func hide() {
        shared.hide()
    }
    
    private func show(_ view: IAMessageView, config: IAMessageConfig) {
        let presenter = IAMessagePresenter(config: config)
        presenter.delegate = self
        
        hiddenPresenter = currentPresenter
        currentPresenter = presenter
        
        hide()
        presenter.show(view: view)
    }
    
    private func hide() {
        guard let presenter = hiddenPresenter else { return }
        presenter.hide()
    }
}

// MARK: - PresenterEventDelegate
extension IAMessageService: PresenterEventDelegate {
    func willShow(_ presenter: IAMessagePresenter) {
        
    }
    
    func didShow(_ presenter: IAMessagePresenter) {
        
    }
    
    func willHide(_ presenter: IAMessagePresenter) {
        
    }
    
    func didHide(_ presenter: IAMessagePresenter) {
        if currentPresenter === presenter {
            currentPresenter = nil
        }
        
        hiddenPresenter = nil
    }
}

extension IAMessageService {
    static let showNotifyNotification = Notification.Name(rawValue: "showNotifyNotification")
}

