//
//  IAMessagePresenter.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/24.
//

import Foundation

protocol PresenterEventDelegate: AnyObject {
    func willShow(_ presenter: IAMessagePresenter)
    func didShow(_ presenter: IAMessagePresenter)
    func willHidden(_ presenter: IAMessagePresenter)
    func didHidden(_ presenter: IAMessagePresenter)
}

class IAMessagePresenter: NSObject {
    weak var delegate: PresenterEventDelegate?

    let config: IAMessageConfig

    let animator: IAAnimator

    private var messageTime: TimeInterval {
        switch config.duration {
        case .auto:
            return 5.0
        case .forever:
            return 0
        case let .seconds(seconds):
            return seconds
        }
    }

    private var presentationContext: IAMessageContext?

    private lazy var notifyViewController = IANotifyViewController(config: config)

    deinit {
        print("IAMessagePresenter deinit")
        notifyViewController.destory()
    }

    init(config: IAMessageConfig = IAMessageConfig()) {
        self.config = config
        animator = IAMessagePresenter.getAnimator(config: config)
        super.init()

        animator.delegate = self
    }

    static func getAnimator(config: IAMessageConfig) -> IAAnimator {
        switch config.presentStyle {
        case .top:
            return TopBottomAnimator(config: config)
        case .bottom:
            return TopBottomAnimator(config: config)
        default:
            return TopBottomAnimator(config: config)
        }
    }

    func show(view: IAMessageView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)

        let context = IAMessageContext(container: notifyViewController.view, messageView: view)
        presentationContext = context

        animator.addContext(context: context)

        showPresentationContext()
    }

    private func showPresentationContext() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)

        guard let presentationContext else { return }

        // show window
        notifyViewController.show(context: presentationContext)

        // will show
        delegate?.willShow(self)

        animator.show { [weak self] completed in
            guard let self else { return }
            guard completed == true else { return }

            // did show
            self.delegate?.didShow(self)

            // hide
            if self.messageTime > 0 {
                self.perform(#selector(self.hide),
                             with: nil,
                             afterDelay: self.messageTime)
            }
        }
    }

    @objc func hide() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)

        guard presentationContext != nil else { return }

        // will hide
        delegate?.willHidden(self)

        animator.hide { [weak self] completed in
            guard let self else { return }
            guard completed == true else { return }

            // release viewController and window
            self.notifyViewController.destory()

            // did hide
            self.delegate?.didHidden(self)
        }
    }
}

// MARK: - IAAnimatorDelegate

extension IAMessagePresenter: IAAnimatorDelegate {
    func animation(_: IAAnimator, shouldHidden: Bool) {
        if shouldHidden {
            hide()
        } else {
            showPresentationContext()
        }
    }

    func panStarted(_: IAAnimator) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
}
