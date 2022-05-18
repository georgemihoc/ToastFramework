//
//  UIView+Toast.swift
//  ToastFramework
//
//  Created by George Mihoc on 18.05.2022.
//

import UIKit

public extension UIView {
    
    // Keys used for associated objects.
    private struct ToastKeys {
        static var timer        = "com.georgemihoc.toastFramework.timer"
        static var duration     = "com.georgemihoc.toastFramework.duration"
        static var completion   = "com.georgemihoc.toastFramework.completion"
        static var activeToasts = "com.georgemihoc.toastFramework.activeToasts"
        static var queue        = "com.georgemihoc.toastFramework.queue"
    }
    
    private class ToastCompletionWrapper {
        let completion: ((Bool) -> Void)?

        init(_ completion: ((Bool) -> Void)?) {
            self.completion = completion
        }
    }
    
    private var activeToasts: NSMutableArray {
        get {
            if let activeToasts = objc_getAssociatedObject(self, &ToastKeys.activeToasts) as? NSMutableArray {
                return activeToasts
            } else {
                let activeToasts = NSMutableArray()
                objc_setAssociatedObject(self, &ToastKeys.activeToasts, activeToasts, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activeToasts
            }
        }
    }
    
    private var queue: NSMutableArray {
        get {
            if let queue = objc_getAssociatedObject(self, &ToastKeys.queue) as? NSMutableArray {
                return queue
            } else {
                let queue = NSMutableArray()
                objc_setAssociatedObject(self, &ToastKeys.queue, queue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return queue
            }
        }
    }

    // MARK: - Show Toast Methods
    
    /// Show CTA (Call to action) toast
    /// - Parameters:
    ///   - message: Message
    ///   - actionTitle: Action title
    ///   - action: Action handler
    ///   - duration: Display duration
    ///   - completion: Completion handler
    func showCTAToast(message: String,
                      actionTitle: String,
                      action: (() -> Void)?,
                      duration: TimeInterval = ToastManager.shared.duration) {
        
        let ctaToast = CTAToastView.loadFromNib()
        ctaToast.setUpWith(message: message, actionTitle: actionTitle) { [unowned self] in
            
            hideToast()
            action?()
        }
        
        showToast(ctaToast, duration: duration)
    }
    
    /// Shoat toast message
    /// - Parameters:
    ///   - message: Message to show
    ///   - duration: Durration
    ///   - completion: Completion handler
    func showToast(message: String,
                   color: UIColor? = nil,
                   duration: TimeInterval = ToastManager.shared.duration,
                   completion: ((_ didTap: Bool) -> Void)? = nil) {
        
        let toastMessage = ToastView.loadFromNib()
        toastMessage.setUpWith(message: message, color: color)
        showToast(toastMessage, duration: duration, completion: completion)
    }
    
    /// Displays any view as toast. The completion closure
    /// executes when the toast view completes. `didTap` will be `true` if the toast view was dismissed from a tap.
    /// - Parameters:
    ///   - toast: Toast view to display
    ///   - duration: Duration
    ///   - completion: Completions handler
    func showToast(_ toast: UIView,
                   duration: TimeInterval = ToastManager.shared.duration,
                   completion: ((_ didTap: Bool) -> Void)? = nil) {
        
        objc_setAssociatedObject(toast, &ToastKeys.completion, ToastCompletionWrapper(completion), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        if ToastManager.shared.isQueueEnabled, activeToasts.count > 0 {
            
            objc_setAssociatedObject(toast, &ToastKeys.duration, NSNumber(value: duration), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            queue.add(toast)
            
        } else {
            showToast(toast, duration: duration)
        }
    }
    
    // MARK: - Hide Toast Methods
    
    /// Hides the active toast. If there are multiple toasts active in a view, this method
    /// hides the oldest toast (the first of the toasts to have been presented).
    func hideToast() {
        guard let activeToast = activeToasts.firstObject as? UIView else { return }
        hideToast(activeToast)
    }
    
    /// Hides an active toast.
    /// @param toast The active toast view to dismiss. Any toast that is currently being displayed
    /// on the screen is considered active.
    /// @warning this does not clear a toast view that is currently waiting in the queue.
    /// - Parameter toast: Toast view
    func hideToast(_ toast: UIView) {
        guard activeToasts.contains(toast) else { return }
        hideToast(toast, fromTap: false)
    }
    
    /// Hides all toast views.
    /// - Parameter clearQueue: If `true`, removes all toast views from the queue. Default is `true`.
    func hideAllToasts(clearQueue: Bool = true) {
        
        if clearQueue {
            clearToastQueue()
        }
        
        activeToasts.compactMap { $0 as? UIView }.forEach { hideToast($0) }
    }
    
    /// Removes all toast views from the queue. This has no effect on toast views that are
    /// active. Use `hideAllToasts(clearQueue:)` to hide the active toasts views and clear the queue.
    func clearToastQueue() {
        queue.removeAllObjects()
    }
    
    // MARK: - Private Show / Hide Methods
    
    private func showToast(_ toast: UIView, duration: TimeInterval) {
        
        let sideMargins: CGFloat = 10
        let bottomMargin: CGFloat = 30
        
        toast.alpha = 0.0
        addSubview(toast)

        toast.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: toast, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: sideMargins)
        let rightConstraint = NSLayoutConstraint(item: toast, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -sideMargins)
        let bottomConstraint = NSLayoutConstraint(item: toast, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1, constant: 0)

        addConstraints([leftConstraint, rightConstraint, bottomConstraint])

        setNeedsLayout()
        layoutIfNeeded()
        
        if ToastManager.shared.isTapToDismissEnabled {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.handleToastTapped(_:)))
            toast.addGestureRecognizer(recognizer)
            toast.isUserInteractionEnabled = true
            toast.isExclusiveTouch = true
        }
        
        if ToastManager.shared.isSwipeToDismissEnabled {
            
            /// Left swipe
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(UIView.handleToastLeftSwipe(_:)))
            leftSwipe.direction = .left
            toast.addGestureRecognizer(leftSwipe)
            
            /// Right swipe
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(UIView.handleToastRightSwipe(_:)))
            rightSwipe.direction = .right
            toast.addGestureRecognizer(rightSwipe)
            
            /// Down swipe
            let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(UIView.handleToastDownSwipe(_:)))
            downSwipe.direction = .down
            toast.addGestureRecognizer(downSwipe)
            
            toast.isUserInteractionEnabled = true
            toast.isExclusiveTouch = true
        }
        
        activeToasts.add(toast)
        self.addSubview(toast)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut, .allowUserInteraction], animations: {
            
            toast.alpha = 1.0
            bottomConstraint.constant = -bottomMargin
            self.layoutIfNeeded()
            
        }) { _ in
            
            HapticFeedback.generateFeedback(.impactLight)
            let timer = Timer(timeInterval: duration, target: self, selector: #selector(UIView.toastTimerDidFinish(_:)), userInfo: toast, repeats: false)
            RunLoop.main.add(timer, forMode: .common)
            objc_setAssociatedObject(toast, &ToastKeys.timer, timer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func hideToast(_ toast: UIView, fromTap: Bool) {
        
        invalidateTimer(for: toast)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
            toast.alpha = 0.0
            
        }) { [weak self] _ in
            
            guard let self = self else { return }
            self.dismissAnimationCompletion(for: toast, fromTap: false)
        }
    }
    
    private func hideToastLeftSwipe(_ toast: UIView) {
        
        invalidateTimer(for: toast)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            
            toast.alpha = 0.0
            toast.layer.transform = CATransform3DMakeTranslation(-UIDevice.current.screenSize.width, 0, 0)
            
        }) { [weak self] _ in
            
            guard let self = self else { return }
            self.dismissAnimationCompletion(for: toast, fromTap: false)
        }
    }
    
    private func hideToastRightSwipe(_ toast: UIView) {
        
        invalidateTimer(for: toast)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            
            toast.alpha = 0.0
            toast.layer.transform = CATransform3DMakeTranslation(UIDevice.current.screenSize.width, 0, 0)
            
        }) { [weak self] _ in
            guard let self = self else { return }
            self.dismissAnimationCompletion(for: toast, fromTap: false)
        }
    }
    
    private func hideToastDownSwipe(_ toast: UIView) {
        
        invalidateTimer(for: toast)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            
            toast.alpha = 0.0
            toast.layer.transform = CATransform3DMakeTranslation(0, 30, 0)
            
        }) { [weak self] _ in
            guard let self = self else { return }
            self.dismissAnimationCompletion(for: toast, fromTap: false)
        }
    }
    
    private func invalidateTimer(for toast: UIView) {
        if let timer = objc_getAssociatedObject(toast, &ToastKeys.timer) as? Timer {
            timer.invalidate()
        }
    }
    
    private func dismissAnimationCompletion(for toast: UIView, fromTap: Bool) {
        
        toast.removeFromSuperview()
        self.activeToasts.remove(toast)
        
        if let wrapper = objc_getAssociatedObject(toast, &ToastKeys.completion) as? ToastCompletionWrapper, let completion = wrapper.completion {
            completion(fromTap)
        }
        
        if let nextToast = self.queue.firstObject as? UIView, let duration = objc_getAssociatedObject(nextToast, &ToastKeys.duration) as? NSNumber {
            self.queue.removeObject(at: 0)
            self.showToast(nextToast, duration: duration.doubleValue)
        }
    }
    
    // MARK: - Events
    
    @objc
    private func handleToastTapped(_ recognizer: UITapGestureRecognizer) {
        guard let toast = recognizer.view else { return }
        hideToast(toast, fromTap: true)
    }
    
    @objc
    private func handleToastLeftSwipe(_ recognizer: UITapGestureRecognizer) {
        guard let toast = recognizer.view else { return }
        hideToastLeftSwipe(toast)
    }
    
    @objc
    private func handleToastRightSwipe(_ recognizer: UITapGestureRecognizer) {
        guard let toast = recognizer.view else { return }
        hideToastRightSwipe(toast)
    }
    
    @objc
    private func handleToastDownSwipe(_ recognizer: UITapGestureRecognizer) {
        guard let toast = recognizer.view else { return }
        hideToastDownSwipe(toast)
    }
    
    @objc
    private func toastTimerDidFinish(_ timer: Timer) {
        guard let toast = timer.userInfo as? UIView else { return }
        hideToast(toast)
    }
}


// MARK: - Toast Manager

public class ToastManager {
    
    public static let shared = ToastManager()
    
    /** Enables or disables tap to dismiss behaviour for toast views. When `true`,
     toast views will dismiss when tapped. When `false`, tapping will have no effect.
     */
    public var isTapToDismissEnabled = true
    
    /** Enables or disables wipe to dismiss behaviour for toast views. When `true`,
     toast views will dismiss when swiped. When `false`, swiping will have no effect.
     */
    public var isSwipeToDismissEnabled = true
    
    /** Enables or disables queueing behaviour for toast views. When `true`,
     toast views will appear one after the other. When `false`, multiple toast
     views will appear at the same time (potentially overlapping depending
     on their positions).
     */
    public var isQueueEnabled = true
    
    /**
     The default duration. Used for the `makeToast` and
     `showToast` methods that don't require an explicit duration.
     Default is 4.0.
     */
    public var duration: TimeInterval = 1.0
    
    /** Enables or disables haptic behaviour for toast views. When `true`,
     toast views will have a haptic feebback. When `false`, there won't be any haptic feedback
     */
    public var areHapticsEnabled = true
}
