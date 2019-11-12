//
//  File.swift
//  Wainnakel
//
//  Created by Bassuni on 11/6/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//
import Foundation
import UIKit
class CustomeButton : UIButton
{
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSize.zero // Use any CGSize
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
    }
    // ---------------animation------------------
    // ------objects------
    public enum StopAnimationStyle {
        case normal
        case expand
        case shake
    }
    private var cachedTitle: String?
    private let shrinkDuration: CFTimeInterval = 0.1
    private let shrinkCurve:CAMediaTimingFunction = CAMediaTimingFunction(name: .linear)
    private lazy var spiner: SpinerLayer = {
        let spiner = SpinerLayer(frame: self.frame)
        self.layer.addSublayer(spiner)
        return spiner
    }()
    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    private let expandCurve:CAMediaTimingFunction   = CAMediaTimingFunction(controlPoints: 0.95, 0.02, 1, 0.05)
    //--------------------------------------
    open func startAnimation() {
        self.isUserInteractionEnabled = false // Disable the user interaction during the animation
        self.cachedTitle = title(for: .normal)  // cache title before animation of spiner
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
        }, completion: { completed -> Void in
            self.shrink()   // reduce the width to be equal to the height in order to have a circle
            self.spiner.animation() // animate spinner
        })
    }
    
    private func shrink() {
        let shrinkAnim                   = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue             = frame.width
        shrinkAnim.toValue               = frame.height
        shrinkAnim.duration              = shrinkDuration
        shrinkAnim.timingFunction        = shrinkCurve
        shrinkAnim.fillMode              = .forwards
        shrinkAnim.isRemovedOnCompletion = false
        layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
    }
    
    
    private func animateToOriginalWidth(completion:(()->Void)?) {
        let shrinkAnim = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnim.fromValue = (self.bounds.height)
        shrinkAnim.toValue = (self.bounds.width)
        shrinkAnim.duration = shrinkDuration
        shrinkAnim.timingFunction = shrinkCurve
        shrinkAnim.fillMode = .forwards
        shrinkAnim.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock {
            completion?()
        }
        self.layer.add(shrinkAnim, forKey: shrinkAnim.keyPath)
        
        CATransaction.commit()
    }
    
    private func setOriginalState(completion:(()->Void)?) {
        self.animateToOriginalWidth(completion: completion)
        self.spiner.stopAnimation()
        self.setTitle(self.cachedTitle, for: .normal)
        self.isUserInteractionEnabled = true // enable again the user interaction
        self.layer.cornerRadius = self.cornerRadius
    }
    
    private func shakeAnimation(completion:(()->Void)?) {
        let keyFrame = CAKeyframeAnimation(keyPath: "position")
        let point = self.layer.position
        keyFrame.values = [NSValue(cgPoint: CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + 10), y: CGFloat(point.y))),
                           NSValue(cgPoint: point)]
        
        keyFrame.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        keyFrame.duration = 0.7
        self.layer.position = point
        
        CATransaction.setCompletionBlock {
            completion?()
        }
        self.layer.add(keyFrame, forKey: keyFrame.keyPath)
        
        CATransaction.commit()
    }
    
    private func expand(completion:(()->Void)?, revertDelay: TimeInterval) {
        
        let expandAnim = CABasicAnimation(keyPath: "transform.scale")
        let expandScale = (UIScreen.main.bounds.size.height/self.frame.size.height)*2
        expandAnim.fromValue            = 1.0
        expandAnim.toValue              = max(expandScale,26.0)
        expandAnim.timingFunction       = expandCurve
        expandAnim.duration             = 0.4
        expandAnim.fillMode             = .forwards
        expandAnim.isRemovedOnCompletion  = false
        
        CATransaction.setCompletionBlock {
            completion?()
            // We return to original state after a delay to give opportunity to custom transition
            DispatchQueue.main.asyncAfter(deadline: .now() + revertDelay) {
                self.setOriginalState(completion: nil)
                self.layer.removeAllAnimations() // make sure we remove all animation
            }
        }
        
        layer.add(expandAnim, forKey: expandAnim.keyPath)
        
        CATransaction.commit()
    }
    
    open func stopAnimation(animationStyle:StopAnimationStyle = .normal, revertAfterDelay delay: TimeInterval = 1.0, completion:(()->Void)? = nil) {
        
        let delayToRevert = max(delay, 0.2)
        
        switch animationStyle {
        case .normal:
            // We return to original state after a delay to give opportunity to custom transition
            DispatchQueue.main.asyncAfter(deadline: .now() + delayToRevert) {
                self.setOriginalState(completion: completion)
            }
        case .shake:
            // We return to original state after a delay to give opportunity to custom transition
            DispatchQueue.main.asyncAfter(deadline: .now() + delayToRevert) {
                self.setOriginalState(completion: nil)
                self.shakeAnimation(completion: completion)
            }
        case .expand:
            self.spiner.stopAnimation() // before animate the expand animation we need to hide the spiner first
            self.expand(completion: completion, revertDelay: delayToRevert) // scale the round button to fill the screen
        }
    }
}

