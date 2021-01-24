//
//  IAMessage.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/22.
//

import Foundation
import UIKit

struct IAMessage {
    var title: String
    var body: String?
    var image: String
    var userInfo: [String: Any]?
}


typealias IAMessageClickHandler = (IAMessage) -> ()
protocol IAMessageView where Self: UIView {
    func setMessage(_ message: IAMessage)
    func clickMessage(_ handler: IAMessageClickHandler)
}
