import Foundation
import UIKit

// MARK: Swifty Target & Action
// See: https://www.mikeash.com/pyblog/friday-qa-2015-12-25-swifty-targetaction.html

// MARK: - UIControl

private final class ControlTargetActionTrampoline<T: AnyObject, C: UIControl> {
    private unowned let _target: T
    private let _action: ((T, C) -> Void)
    fileprivate init(target: T, action: @escaping ((T, C) -> Void)) {
        _target = target
        _action = action
    }

    fileprivate var action: Selector {
        return #selector(forwardingRealAction(sender:))
    }

    @objc private func forwardingRealAction(sender: UIControl) {
        if let sender = sender as? C {
            _action(_target, sender)
        }
    }
}

struct UIControlEventAssociatedKey {
    static var touchDown: Void?
    static var touchDownRepeat: Void?
    static var touchDragInside: Void?
    static var touchDragOutside: Void?
    static var touchDragEnter: Void?
    static var touchDragExit: Void?
    static var touchUpInside: Void?
    static var touchUpOutside: Void?
    static var touchCancel: Void?
    static var valueChanged: Void?
    static var primaryActionTriggered: Void?
    static var editingDidBegin: Void?
    static var editingChanged: Void?
    static var editingDidEnd: Void?
    static var editingDidEndOnExit: Void?
    static var allTouchEvents: Void?
    static var allEditingEvents: Void?
    static var applicationReserved: Void?
    static var systemReserved: Void?
    static var allEvents: Void?
}

public protocol UIControlTargetActionClosureSupport {}
extension UIControl: UIControlTargetActionClosureSupport {}
extension UIControlTargetActionClosureSupport where Self: UIControl {
    /// Associates a target object and action method with the control.
    /// - Parameters:
    ///   - target: The target object—that is, the object whose action method is called. If you specify nil, UIKit searches the responder chain for an object that responds to the specified action message and delivers the message to that object.
    ///   - events: A bitmask specifying the control-specific events for which the action method is called. Always specify at least one constant. For a list of possible constants, see UIControlEvents.
    ///   - action: A closure identifying the action method to be called.
    ///   - sender: The object that initiated the request.
    @available(iOS 9.0, *)
    public func addTarget<T: AnyObject>(_ target: T, for events: UIControl.Event, action: @escaping (_ target: T, _ sender: Self) -> Void) {

        let trampoline = ControlTargetActionTrampoline(target: target, action: action)
        addTarget(trampoline, action: trampoline.action, for: events)

        switch events {
        case .touchDown:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.touchDown, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .touchDownRepeat:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.touchDownRepeat, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .touchDragInside:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.touchDragInside, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .touchDragOutside:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.touchDragOutside, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .touchDragEnter:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.touchDragEnter, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .touchDragExit:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.touchDragExit, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .touchUpInside:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.touchUpInside, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .touchUpOutside:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.touchUpOutside, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .touchCancel:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.touchCancel, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .valueChanged:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.valueChanged, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .primaryActionTriggered:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.primaryActionTriggered, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .editingDidBegin:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.editingDidBegin, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .editingChanged:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.editingChanged, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .editingDidEnd:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.editingDidEnd, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .editingDidEndOnExit:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.editingDidEndOnExit, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .allTouchEvents:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.allTouchEvents, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .allEditingEvents:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.allEditingEvents, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .applicationReserved:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.applicationReserved, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .systemReserved:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.systemReserved, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case .allEvents:
            objc_setAssociatedObject(self, &UIControlEventAssociatedKey.allEvents, trampoline, .OBJC_ASSOCIATION_RETAIN)
        default:
            fatalError("*** Add target for events: \(events) not supported yet.")
        }
    }
}

// MARK: - Tap Gesture

import class UIKit.UIView
import class UIKit.UIGestureRecognizer

private final class GestureTargetActionTrampoline<V: UIView> {
    private let _action: (V) -> Void
    fileprivate init(action: @escaping (V) -> Void) {
        _action = action
    }

    fileprivate var action: Selector {
        return #selector(forwardingRealAction(sender:))
    }

    @objc private func forwardingRealAction(sender: UIGestureRecognizer) {
        if let view = sender.view as? V {
            _action(view)
        }
    }
}

private struct TapGestureAssociatedKey {
    public static var one: Void?
    public static var two: Void?
    public static var three: Void?
    public static var ten: Void?
}

public protocol GestureTargetActionClosureSupport {}
extension UIView: GestureTargetActionClosureSupport {}
extension GestureTargetActionClosureSupport where Self: UIView {
    /// Add a tap gesture to receiver.
    ///
    /// - Parameters:
    ///   - numberOfTapsRequired: The number of taps for the gesture to be recognized. The default value is 1.
    ///   - action: A closure identifying the action method to be called.
    ///   - sender: The object that initiated the request.
    public func tapAction(count: Int = 1, _ action: @escaping (_ sender: Self) -> Void) {
        isUserInteractionEnabled = true

        let trampoline = GestureTargetActionTrampoline(action: action)
        let tap = UITapGestureRecognizer(target: trampoline, action: trampoline.action)
        tap.numberOfTapsRequired = count
        addGestureRecognizer(tap)

        switch count {
        case 1:
            objc_setAssociatedObject(self, &TapGestureAssociatedKey.one, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case 2:
            objc_setAssociatedObject(self, &TapGestureAssociatedKey.two, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case 3:
            objc_setAssociatedObject(self, &TapGestureAssociatedKey.three, trampoline, .OBJC_ASSOCIATION_RETAIN)
        case 10:
            objc_setAssociatedObject(self, &TapGestureAssociatedKey.ten, trampoline, .OBJC_ASSOCIATION_RETAIN)
        default:
            fatalError("*** Add view \(count) taps action not supported yet.")
        }
    }

    public func removeAllTapActions() {
        gestureRecognizers?.compactMap({ $0 as? UITapGestureRecognizer }).forEach { tap in
            switch tap.numberOfTapsRequired {
            case 1:
                objc_setAssociatedObject(self, &TapGestureAssociatedKey.one, nil, .OBJC_ASSOCIATION_RETAIN)
            case 2:
                objc_setAssociatedObject(self, &TapGestureAssociatedKey.two, nil, .OBJC_ASSOCIATION_RETAIN)
            case 3:
                objc_setAssociatedObject(self, &TapGestureAssociatedKey.three, nil, .OBJC_ASSOCIATION_RETAIN)
            case 10:
                objc_setAssociatedObject(self, &TapGestureAssociatedKey.ten, nil, .OBJC_ASSOCIATION_RETAIN)
            default:
                fatalError("*** Remove view \(tap.numberOfTapsRequired) taps action not supported yet.")
            }
            removeGestureRecognizer(tap)
        }
    }
}
