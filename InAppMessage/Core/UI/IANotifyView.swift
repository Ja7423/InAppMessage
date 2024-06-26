//
//  IANotifyView.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/23.
//

import UIKit

enum Margin {
    static let backgroundtopBottom: CGFloat = 0
    static let backgroundLeftRight: CGFloat = 8

    static let contentTop: CGFloat = 12
    static let contentLeft: CGFloat = 12
    static let contentRight: CGFloat = -12

    static let iconImageHeight: CGFloat = 20
    static let labelSpace: CGFloat = 8
}

class IANotifyView: UIView {
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.4)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true

        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero

        return view
    }()

    private lazy var blurBackground: UIVisualEffectView = {
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effectView.translatesAutoresizingMaskIntoConstraints = false
        return effectView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.5)
        return label
    }()

    private lazy var clickButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(toggleButton(_:)), for: .touchUpInside)
        return btn
    }()

    private var message: IAMessage?
    private var messageHandler: IAMessageClickHandler?

    deinit {
        print("IANotifyView deinit")
        messageHandler = nil
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialView()
    }

    private func initialView() {
        backgroundColor = .clear

        addSubview(backgroundView)
        backgroundView.addSubview(blurBackground)
        backgroundView.addSubview(iconImageView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(bodyLabel)
        addSubview(clickButton)

        installConstraint()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let height = Margin.contentTop + titleLabel.intrinsicContentSize.height + Margin.labelSpace + bodyLabel.intrinsicContentSize.height + Margin.contentTop
        return CGSize(width: size.width, height: height)
    }

    private func installConstraint() {
        backgroundView.topAnchor.constraint(equalTo: topAnchor,
                                            constant: Margin.backgroundtopBottom).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                constant: Margin.backgroundLeftRight).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                 constant: -Margin.backgroundLeftRight).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                               constant: Margin.backgroundtopBottom).isActive = true

        blurBackground.topAnchor.constraint(equalTo: backgroundView.topAnchor,
                                            constant: 0).isActive = true
        blurBackground.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor,
                                                constant: 0).isActive = true
        blurBackground.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor,
                                                 constant: 0).isActive = true
        blurBackground.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor,
                                               constant: 0).isActive = true

        iconImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor,
                                           constant: Margin.contentTop).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor,
                                               constant: Margin.contentLeft).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: Margin.iconImageHeight).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: Margin.iconImageHeight).isActive = true

        titleLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor,
                                        constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor,
                                            constant: Margin.labelSpace).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: Margin.contentRight).isActive = true

        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                       constant: Margin.labelSpace).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor,
                                           constant: 0).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor,
                                            constant: 0).isActive = true
        bodyLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor,
                                          constant: Margin.contentRight).isActive = true

        clickButton.topAnchor.constraint(equalTo: topAnchor,
                                         constant: Margin.backgroundtopBottom).isActive = true
        clickButton.leadingAnchor.constraint(equalTo: leadingAnchor,
                                             constant: Margin.backgroundLeftRight).isActive = true
        clickButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: -Margin.backgroundLeftRight).isActive = true
        clickButton.bottomAnchor.constraint(equalTo: bottomAnchor,
                                            constant: Margin.backgroundtopBottom).isActive = true
    }

    @objc private func toggleButton(_: UIButton) {
        messageHandler?(message)
    }
}

// MARK: - IAMessageView

extension IANotifyView: IAMessageView {
    var interactiveView: UIView? {
        return clickButton
    }

    func setMessage(_ message: IAMessage) {
        self.message = message

        titleLabel.text = message.title
        titleLabel.sizeToFit()

        bodyLabel.text = message.body
        bodyLabel.sizeToFit()

        iconImageView.image = UIImage(named: message.image)

        setNeedsLayout()
    }

    func clickMessage(_ handler: @escaping IAMessageClickHandler) {
        messageHandler = handler
    }
}
