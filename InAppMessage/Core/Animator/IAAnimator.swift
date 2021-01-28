//
//  IAAnimator.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/24.
//

import Foundation

public typealias AnimationCompletion = (_ completed: Bool) -> Void

public protocol IAAnimator: AnyObject {
    func show(context: IAMessageContext, completion: @escaping AnimationCompletion)
    func hide(context: IAMessageContext, completion: @escaping AnimationCompletion)
}
