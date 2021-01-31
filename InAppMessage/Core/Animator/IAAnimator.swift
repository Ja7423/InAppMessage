//
//  IAAnimator.swift
//  InAppMessage
//
//  Created by 家瑋 on 2021/1/24.
//

import Foundation

public protocol IAAnimatorDelegate: AnyObject {
    func animation(_ animator: IAAnimator, shouldHidden: Bool)
    func panStarted(_ animator: IAAnimator)
}

public typealias AnimationCompletion = (_ completed: Bool) -> Void

public protocol IAAnimator: AnyObject {
    
    var delegate: IAAnimatorDelegate? { get set }
    
    func addContext(context: IAMessageContext)
    
    func show(completion: @escaping AnimationCompletion)
    
    func hide(completion: @escaping AnimationCompletion)
}
