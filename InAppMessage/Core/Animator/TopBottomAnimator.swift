//
//  TopBottomAnimator.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/24.
//

import Foundation
import UIKit

class TopBottomAnimator: NSObject, IAAnimator {
    
    private var config: IAMessageConfig
    private let animationDuration: TimeInterval = 0.5
    private var messageTime: TimeInterval {
        get {
            switch config.duration {
            case .auto:
                return 5.0
            case .forever:
                return 0
            case .seconds(let seconds):
                return seconds
            }
        }
    }
    
    deinit {
        print("TopBottomAnimator deinit")
    }
    
    init(config: IAMessageConfig) {
        self.config = config
        super.init()
    }
    
    func show(context: IAMessageContext, completion: @escaping AnimationCompletion) {
        layoutMessage(context: context)
        hideMessageContext(context: context)

        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            context.messageView.transform = .identity
        }, completion: completion)
    }
    
    func hide(context: IAMessageContext, completion: @escaping AnimationCompletion) {
        let messageView = context.messageView
        UIView.animate(withDuration: animationDuration,
                       animations: { [weak self] in
                        
                        guard let strongSelf = self else { return }
                        strongSelf.hideMessageContext(context: context)
                        
                       },
                       completion:{
                        messageView.removeFromSuperview()
                        completion($0)
                       })
    }
    
    private func layoutMessage(context: IAMessageContext) {
        let container = context.container
        let messageView = context.messageView
        container.addSubview(messageView)
        messageView.frame = CGRect(origin: .zero, size: messageView.sizeThatFits(container.bounds.size))
        
        switch config.presentStyle {
        case .top:
            let y = UIApplication.shared.safeAreaInsets.top
            messageView.frame.origin.y = y
        case .bottom:
            let y = container.frame.height - messageView.frame.height - UIApplication.shared.safeAreaInsets.bottom
            messageView.frame.origin.y = y
        default: break
        }
    }
    
    private func hideMessageContext(context: IAMessageContext) {
        let messageView = context.messageView
        
        switch config.presentStyle {
        case .top:
            let y = messageView.frame.size.height + UIApplication.shared.safeAreaInsets.top
            messageView.transform = CGAffineTransform(translationX: 0,
                                                      y: -y)
        case .bottom:
            let y =  messageView.frame.height + UIApplication.shared.safeAreaInsets.bottom
            messageView.transform = CGAffineTransform(translationX: 0,
                                                      y: y)
        default: break
        }
    }
}
