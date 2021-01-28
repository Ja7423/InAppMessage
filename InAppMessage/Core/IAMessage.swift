//
//  IAMessage.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/22.
//

import Foundation
import UIKit

public struct IAMessage {
    var title: String
    var body: String?
    var image: String
    var userInfo: [String: Any]?
}


// MARK: - IAMessageView
public typealias IAMessageClickHandler = (_ message: IAMessage) -> ()
public protocol IAMessageView where Self: UIView {
    func setMessage(_ message: IAMessage)
    func clickMessage(_ handler: IAMessageClickHandler)
}

public class IAMessageContext: NSObject {
    public let container: UIView
    public let messageView: IAMessageView
    
    init(container: UIView, messageView: IAMessageView) {
        self.container = container
        self.messageView = messageView
        super.init()
    }
}


// MARK: - IAMessageConfig
struct IAMessageConfig {
    
    var presentStyle: IANotifyPresentStyle = .top
    
    var duration: MessageDuration = .auto
}

public enum IANotifyPresentStyle {
    case unknown
    case top
    case bottom
}

enum MessageDuration {
    case auto
    case forever
    case seconds(_ seconds: TimeInterval)
}
