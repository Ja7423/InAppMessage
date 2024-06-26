//
//  IANotifyWindow.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/22.
//

import UIKit

class IANotifyWindow: UIWindow {
    public weak var notificationView: IAMessageView?

    deinit {
        print("IANotifyWindow deinit")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let notificationView else { return false }
        let touchPoint = convert(point, to: notificationView)
        return notificationView.point(inside: touchPoint, with: event)
    }
}
