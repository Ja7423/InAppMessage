//
//  IANotifyViewController.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/22.
//

import UIKit

class IANotifyViewController: UIViewController {
    
    public var messageTime: TimeInterval = 5
    public var animationDuration: TimeInterval = 0.5
    
    private var iaNotifyWindow: IANotifyWindow?
    private var currentMessageView: IAMessageView?
    private var currentMessage: IAMessage?
    private var currentMessagePosition: IANotifyPosition = .unknown
    
    // MARK: -
    init() {
        super.init(nibName: nil, bundle: nil)
        setupController()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupController() {
        view.backgroundColor = .clear
        
        if let windowScene = UIApplication.shared.activeWindow?.windowScene {
            iaNotifyWindow = IANotifyWindow(windowScene: windowScene)
            iaNotifyWindow?.rootViewController = self
            iaNotifyWindow?.windowLevel = .alert - 1
        }
    }
    
    public func show(_ message: IAMessage, on view: IAMessageView, at position: IANotifyPosition) {
        guard let notifyWindow = iaNotifyWindow else { return }
        
        hideCurrentMessage()
        
        currentMessageView = view
        view.setMessage(message)
        layoutMessage(view: view, position: position)
        self.view.addSubview(view)
        
        currentMessagePosition = position
        
        notifyWindow.notificationView = currentMessageView
        notifyWindow.isHidden = false
        
        let targetY = showOriginY(position)
        UIView.animate(withDuration: animationDuration,
                       delay: 0,
                       options: .curveEaseOut) {
            view.frame.origin.y = targetY
        } completion: { [weak self] (result) in
            guard let self = self else { return }
            if self.messageTime > 0, result {
                self.perform(#selector(self.hideCurrentMessage), with: nil, afterDelay: self.messageTime)
            }
        }
    }
    
    @objc public func hideCurrentMessage() {
        IANotifyViewController.cancelPreviousPerformRequests(withTarget: self)
        
        if let messageView = currentMessageView {
            currentMessageView = nil
            messageView.isUserInteractionEnabled = false
            
            let targetY = hideOriginY(currentMessagePosition)
            UIView.animate(withDuration: animationDuration,
                           delay: 0,
                           options: .curveEaseOut) {
                messageView.frame.origin.y = targetY
            } completion: { [weak self] (result) in
                guard let self = self else { return }
                messageView.removeFromSuperview()
                if self.currentMessageView == nil {
                    self.iaNotifyWindow?.isHidden = true
                }
            }
        }
        
        currentMessagePosition = .unknown
    }
    
    private func layoutMessage(view: IAMessageView, position: IANotifyPosition) {
        view.frame = CGRect(origin: .zero, size: view.sizeThatFits(self.view.bounds.size))
        view.frame.origin.y = hideOriginY(position)
    }
    
    private func showOriginY(_ position: IANotifyPosition) -> CGFloat {
        var y: CGFloat = 0
        switch position {
        case .top:
            y = UIApplication.shared.safeAreaInsets.top + 8
        case .bottom:
            let messageH = currentMessageView?.frame.height ?? 0
            y = self.view.frame.height - messageH - UIApplication.shared.safeAreaInsets.bottom
        default: break
        }
        return y
    }
    
    private func hideOriginY(_ position: IANotifyPosition) -> CGFloat {
        var y: CGFloat = 0
        switch position {
        case .top:
            y = -100
            if let messageView = currentMessageView {
                y = -messageView.frame.height - 8
            }
        case .bottom:
            y = self.view.frame.height
        default: break
        }
        return y
    }
}
