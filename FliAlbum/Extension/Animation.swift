//
//  Animation.swift
//  FliAlbum
//
//  Created by Sangyeol Kang on 12/05/2019.
//  Copyright © 2019 devdagad. All rights reserved.
//

import UIKit

public struct Animation {
    public let duration: TimeInterval
    public let delay: TimeInterval
    public let closure: (UIView) -> Void
}

public extension Animation {
    
    static func playAnimation(_ tokens: [AnimationToken]) {
        guard !tokens.isEmpty else {
            return
        }
        
        var tokens = tokens
        let token = tokens.removeFirst()
        
        token.perform {
            playAnimation(tokens)
        }
    }
    
    static func fadeIn(duration: TimeInterval = 0, delay: TimeInterval = 0) -> Animation {
        return Animation(duration: duration, delay: delay) { $0.alpha = 1 }
    }
    
    static func fadeOut(duration: TimeInterval = 0, delay: TimeInterval = 0) -> Animation {
        return Animation(duration: duration, delay: delay) { $0.alpha = 0 }
    }
        static func changeImage(image: UIImage, duration: TimeInterval = 0, delay: TimeInterval = 0) -> Animation {
        return Animation(duration: duration, delay: delay) {
            guard let imageView = $0 as? UIImageView else { return }
            imageView.image = image
        }
    }
}

public final class AnimationToken {
    private let view: UIView
    private let animations: [Animation]
    private let mode: AnimationMode
    private var isValid = true
    private let completion: () -> Void
    
    internal init(view: UIView, animations: [Animation], mode: AnimationMode, completion: @escaping (() -> Void) = {}) {
        self.view = view
        self.animations = animations
        self.mode = mode
        self.completion = completion
    }
    
    deinit {
        perform(completionHandler: completion)
    }
    
    internal func perform(completionHandler: @escaping () -> Void) {
        guard isValid else {
            return
        }
        
        isValid = false
        
        switch mode {
        case .inSequence:
            view.performAnimations(animations, completionHandler: completionHandler)
        case .inParallel:
            view.performAnimationsInParallel(animations, completionHandler: completionHandler)
        }
    }
}

internal enum AnimationMode {
    case inSequence
    case inParallel
}

public extension UIView {
    @discardableResult func animate(_ animations: [Animation], completion: @escaping (() -> Void) = {}) -> AnimationToken {
        return AnimationToken(
            view: self,
            animations: animations,
            mode: .inSequence,
            completion: completion
        )
    }
    
    @discardableResult func animate(_ animations: Animation...) -> AnimationToken {
        return animate(animations)
    }
    
    @discardableResult func animate(inParallel animations: [Animation], completion: @escaping (() -> Void) = {}) -> AnimationToken {
        return AnimationToken(
            view: self,
            animations: animations,
            mode: .inParallel,
            completion: completion
        )
    }
    
    @discardableResult func animate(inParallel animations: Animation...) -> AnimationToken {
        return animate(inParallel: animations)
    }
}

internal extension UIView {
    func performAnimations(_ animations: [Animation], completionHandler: @escaping () -> Void) {
        guard !animations.isEmpty else {
            return completionHandler()
        }
        
        var animations = animations
        let animation = animations.removeFirst()
        
        UIView.animate(withDuration: animation.duration,
                       delay: animation.delay,
                       animations: {
                        animation.closure(self)
        }, completion: { result in
            if !result {
                animations.removeAll()
            }
            self.performAnimations(animations, completionHandler: completionHandler)
        })
    }
    
    func performAnimationsInParallel(_ animations: [Animation], completionHandler: @escaping () -> Void) {
        guard !animations.isEmpty else {
            return completionHandler()
        }
        
        let animationCount = animations.count
        var completionCount = 0
        
        let animationCompletionHandler = {
            completionCount += 1
            
            if completionCount == animationCount {
                completionHandler()
            }
        }
        
        for animation in animations {
            UIView.animate(withDuration: animation.duration, animations: {
                animation.closure(self)
            }, completion: { _ in
                animationCompletionHandler()
            })
        }
    }
}

