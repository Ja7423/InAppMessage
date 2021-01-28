//
//  IANotifyViewController.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/22.
//

import UIKit

class IANotifyViewController: UIViewController {
    
    let config: IAMessageConfig
    
    private var iaNotifyWindow: IANotifyWindow?
    private var currentMessageView: IAMessageView?
    private var currentMessage: IAMessage?
    private var currentMessagePosition: IANotifyPresentStyle = .unknown
    
    // MARK: -
    deinit {
        print("IANotifyViewController deinit")
    }
    
    init() {
        self.config = IAMessageConfig()
        super.init(nibName: nil, bundle: nil)
        setupController()
    }
    
    init(config: IAMessageConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
        setupController()
    }
    
    required init?(coder: NSCoder) {
        self.config = IAMessageConfig()
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
    
    public func show() {
        guard let notifyWindow = iaNotifyWindow else { return }
        notifyWindow.isHidden = false
    }
    
    public func destory() {
        iaNotifyWindow?.isHidden = true
        iaNotifyWindow?.windowScene = nil
        iaNotifyWindow?.rootViewController = nil
        iaNotifyWindow = nil
    }
}
