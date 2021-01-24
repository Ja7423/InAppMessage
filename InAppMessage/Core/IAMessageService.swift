//
//  IAMessageService.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/22.
//

import UIKit

enum IANotifyPosition {
    case unknown
    case top
    case bottom
}

class IAMessageService: NSObject {
    
    static let shared = IAMessageService()
    private lazy var notifyViewController = IANotifyViewController()
    
    static func show(_ message: IAMessage, on view: IAMessageView = IANotifyView(), at position: IANotifyPosition = .top) {
        shared.show(message, on: view, at: position)
    }
    
    static func hide() {
        shared.hide()
    }
    
    private func show(_ message: IAMessage, on view: IAMessageView, at position: IANotifyPosition) {
        notifyViewController.show(message, on: view, at: position)
    }
    
    private func hide() {
        notifyViewController.hideCurrentMessage()
    }
}

extension IAMessageService {
    static let showNotifyNotification = Notification.Name(rawValue: "showNotifyNotification")
}

