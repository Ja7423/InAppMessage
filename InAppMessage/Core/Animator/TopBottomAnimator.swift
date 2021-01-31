//
//  TopBottomAnimator.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/24.
//

import Foundation
import UIKit

class TopBottomAnimator: NSObject, IAAnimator {
    
    weak var delegate: IAAnimatorDelegate?
    
    private let config: IAMessageConfig
    private let animationDuration: TimeInterval = 0.5
    
    /// 保留message的時間
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
    
    /// 最低要隱藏messageView的拖移範圍
    private let hiddenPercent: CGFloat = 0.4
    
    /// 最低要隱藏messageView的拖移速度
    private let minCloseSpeed: CGFloat = 250.0
    
    /// 拖移速度
    private var closeSpeed: CGFloat = 0.0
    
    /// 拖移的Y座標
    private var translationY: CGFloat = 0.0
    
    /// frame 的 Y 座標
    private var originY: CGFloat {
        get {
            switch config.presentStyle {
            case .top:
                return UIApplication.shared.safeAreaInsets.top
            case .bottom:
                if let context = context {
                    return context.container.frame.height - context.messageView.frame.height - UIApplication.shared.safeAreaInsets.bottom
                }
            default: break
            }
            
            return -1
        }
    }
    
    private lazy var pangesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        return gesture
    }()
    private weak var context: IAMessageContext?
    
    deinit {
        print("TopBottomAnimator deinit")
        removePanGesture()
    }
    
    init(config: IAMessageConfig) {
        self.config = config
        super.init()
    }
    
    func addContext(context: IAMessageContext) {
        self.context = context
        
        layoutMessage(context: context)
        hideMessageContext(context: context)
        
        // add gesture
        if config.interactiveHidden, let interactiveView = context.messageView.interactiveView {
            addPanGesture(on: interactiveView)
        }
    }
    
    func show(completion: @escaping AnimationCompletion) {
        guard let context = self.context else { return }
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        
                        context.messageView.transform = .identity
                       }, completion: completion)
    }
    
    func hide(completion: @escaping AnimationCompletion) {
        guard let context = self.context else { return }
        
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
        messageView.frame.origin.y = originY
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
    
    // MARK: Gesture
    private func addPanGesture(on view: UIView) {
        pangesture.cancelsTouchesInView = true
        view.addGestureRecognizer(pangesture)
    }
    
    private func removePanGesture() {
        if let interactiveView = context?.messageView.interactiveView {
            interactiveView.removeGestureRecognizer(pangesture)
        }
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            delegate?.panStarted(self)
        case .changed:
            handlePanChanged(gesture)
        case .ended, .cancelled:
            handlePanEnd(gesture)
        default: break
        }
        
        gesture.setTranslation(.zero, in: context?.messageView)
    }
    
    private func handlePanChanged(_ gesture: UIPanGestureRecognizer) {
        guard let messageView = context?.messageView else { return }
        
        let translationPoint = gesture.translation(in: messageView)
        let velocity = gesture.velocity(in: messageView)
        
        // 負往上，正往下
        switch config.presentStyle {
        case .top:
            let lastTranslationY = translationPoint.y * -1
            let nextTranslationY = self.translationY + lastTranslationY
            let translationY = max(nextTranslationY, 0)
            self.translationY = translationY
            messageView.transform = CGAffineTransform(translationX: 0, y: -self.translationY)
            break
        case .bottom:
            let lastTranslationY = translationPoint.y
            let nextTranslationY = self.translationY + lastTranslationY
            let translationY = max(nextTranslationY, 0)
            self.translationY = translationY
            messageView.transform = CGAffineTransform(translationX: 0, y: self.translationY)
            break
        default: break
        }
        
        closeSpeed = velocity.y
    }
    
    private func handlePanEnd(_ gesture: UIPanGestureRecognizer) {
        let view = gesture.view
        let translationForHidden = (view?.frame.size.height ?? 0) * hiddenPercent
        
        // 消失部分超過hiddenPercent或者拖動速度過快
        // 負往上，正往下
        switch config.presentStyle {
        case .top:
            let lastSpeed = closeSpeed * -1
            if lastSpeed >= minCloseSpeed || translationY > translationForHidden {
                // hide
                delegate?.animation(self, shouldHidden: true)
            }
            else {
                // show
                delegate?.animation(self, shouldHidden: false)
            }
            break
        case .bottom:
            let lastSpeed = closeSpeed
            if lastSpeed >= minCloseSpeed || translationY > translationForHidden {
                // hide
                delegate?.animation(self, shouldHidden: true)
            }
            else {
                // show
                delegate?.animation(self, shouldHidden: false)
            }
            break
        default: break
        }
        
        closeSpeed = 0.0
        translationY = 0.0
    }
}
