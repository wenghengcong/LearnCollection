/*
 Copyright (C) 2018 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Menu view controller class.
 */

import Foundation
import UIKit

class MenuViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private struct Settings { // Constants.
        static let menuWidth: CGFloat = 270.0
        static let maxMaskOpacity: CGFloat = 0.6
        static let maxMainViewScale: CGFloat = 0.96
        static let panBezelWidth: CGFloat = 16.0
    }
    
    // Gesture.
    //
    private var tapGesture: UITapGestureRecognizer!
    private var panGesture: UIPanGestureRecognizer!

    //
    private var maskView = UIView()
    private var mainContainerView = UIView()
    private var menuContainerView = UIView()

    var mainViewController: UIViewController!
    var menuViewController: UIViewController!

    // Prevent clients from calling init other than the convenience one.
    //
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }

    init(mainViewController: UIViewController, menuViewController: UIViewController) {
        
        super.init(nibName: nil, bundle: nil)
        self.mainViewController = mainViewController
        self.menuViewController = menuViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainContainerView = UIView(frame: view.bounds)
        mainContainerView.backgroundColor = UIColor.clear
        view.insertSubview(mainContainerView, at: 0)
        
        maskView = UIView(frame: view.bounds)
        maskView.backgroundColor = UIColor.black
        maskView.layer.opacity = 0.0
        view.insertSubview(maskView, at: 1)
        
        var menuFrame: CGRect = view.bounds
        menuFrame.origin.x = 0.0 - Settings.menuWidth
        menuFrame.size.width = Settings.menuWidth
        menuContainerView = UIView(frame: menuFrame)
        menuContainerView.backgroundColor = UIColor.clear
        view.insertSubview(menuContainerView, at: 2)
        
        // Setup main and menu view controller.
        //
        addChildViewController(mainViewController)
        mainViewController.view.frame = mainContainerView.bounds
        mainContainerView.addSubview(mainViewController.view)
        mainViewController.didMove(toParentViewController: self)
        
        addChildViewController(menuViewController)
        menuViewController.view.frame = menuContainerView.bounds
        menuContainerView.addSubview(menuViewController.view)
        menuViewController.didMove(toParentViewController: self)

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(type(of: self).toggleMenu))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(type(of: self).handlePanGesture(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    func isMenuHidden() -> Bool {
        return menuContainerView.frame.origin.x <= 0.0 - Settings.menuWidth
    }
    
    func showMenu(velocity: CGFloat = 0.0) {
        
        view.window?.windowLevel = UIWindowLevelStatusBar + 1
        menuViewController.beginAppearanceTransition(isMenuHidden(), animated: true)
        
        let xOffset = fabs(menuContainerView.frame.origin.x)
        var duration = Double(velocity != 0.0 ? xOffset / fabs(velocity): 0.4)
        duration = Double(fmax(0.2, fmin(0.8, duration)))

        var frame = menuContainerView.frame
        frame.origin.x = 0.0
        
        UIView.animate( withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            self.menuContainerView.frame = frame
            self.maskView.layer.opacity = Float(Settings.maxMaskOpacity)
            self.mainContainerView.transform = CGAffineTransform(scaleX: Settings.maxMainViewScale,
                                                                 y: Settings.maxMainViewScale)
            
        }) { _ in
            self.mainContainerView.isUserInteractionEnabled = false
            self.menuViewController.endAppearanceTransition()
        }
    }
    
    func hideMenu(velocity: CGFloat = 0.0) {

        menuViewController.beginAppearanceTransition(isMenuHidden(), animated: true)
        
        let xOffset = Settings.menuWidth - fabs(menuContainerView.frame.origin.x)
        var duration = Double(velocity != 0.0 ? xOffset / fabs(velocity): 0.4)
        duration = Double(fmax(0.2, fmin(0.8, duration)))

        var frame: CGRect = menuContainerView.frame
        frame.origin.x = 0.0 - Settings.menuWidth
        
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            self.menuContainerView.frame = frame
            self.maskView.layer.opacity = 0.0
            self.mainContainerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            
        }) { _ in
            self.mainContainerView.isUserInteractionEnabled = true
            self.menuViewController.endAppearanceTransition()
        }
    
        view.window?.windowLevel = UIWindowLevelNormal
    }
    
    @objc func toggleMenu() { isMenuHidden() == false ? hideMenu() : showMenu() }
}

extension MenuViewController { // MARK: - UIGestureRecognizerDeletate and gesture handler.
    
    private struct States {
        static var grState: UIGestureRecognizerState = .ended
        static var panBeginAt = CGPoint()
        static var initialMenuOrigin = CGPoint()
        static func isMenuShownAtStart() -> Bool { return States.initialMenuOrigin.x == 0.0 }
    }
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        
        if panGesture.state == .began {
            guard States.grState == .ended || States.grState == .cancelled
                || States.grState == .failed else { return }

            menuViewController.beginAppearanceTransition(!isMenuHidden(), animated: true)
            view.window?.windowLevel = UIWindowLevelStatusBar + 1
            
            // Pick up the initial states.
            //
            States.initialMenuOrigin = menuContainerView.frame.origin
            States.panBeginAt = panGesture.translation(in: view)
            
        } else if panGesture.state == .changed {
            guard States.grState == .began || States.grState == .changed else { return }
            
            // Calcuate the x offset, the offset relative to -Settings.menuWidth.
            //
            let xInView = panGesture.translation(in: view).x
            var xOffset = xInView - States.panBeginAt.x
            
            if xOffset > 0.0 {
                xOffset = States.isMenuShownAtStart() ? Settings.menuWidth : min(xOffset, Settings.menuWidth)
            } else {
                xOffset = max(-Settings.menuWidth, xOffset)
                xOffset = States.isMenuShownAtStart() ? Settings.menuWidth + xOffset : xInView
            }
            
            // Calculate the new frame for menuContainerView.
            //
            let newOrigin = CGPoint(x: xOffset - Settings.menuWidth, y: States.initialMenuOrigin.y)
            menuContainerView.frame = CGRect(origin: newOrigin, size: menuContainerView.frame.size)
            
            // Calculte the maskView opacity and main view transform based on the ratio.
            //
            let ratio = xOffset / Settings.menuWidth
            
            maskView.layer.opacity = Float(Settings.maxMaskOpacity * ratio)
            
            let scale = Settings.maxMainViewScale + (1.0 - Settings.maxMainViewScale) * (1.0 - ratio)
            mainContainerView.transform = CGAffineTransform(scaleX: scale, y:scale)
            
        } else if panGesture.state == .ended || panGesture.state == .cancelled {
            guard States.grState == .changed else { return }
            
            // Hide menu only when users tend to hide it.
            //
            let velocity: CGPoint = panGesture.velocity(in: panGesture.view)
            
            if States.isMenuShownAtStart() { // Menu is initially visible.
                if panGesture.translation(in: view).x < States.panBeginAt.x {
                    hideMenu(velocity: velocity.x)
                }
            } else {
                if panGesture.translation(in: view).x > States.panBeginAt.x {
                    showMenu(velocity: velocity.x)
                }
            }
        }
        States.grState = panGesture.state
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let point: CGPoint = touch.location(in: view)
        
        if gestureRecognizer == panGesture {
            let tuple = view.bounds.divided(atDistance: Settings.panBezelWidth, from: CGRectEdge.minXEdge)
            let isPointContained = tuple.slice.contains(point)
            return !isMenuHidden() || isPointContained
            
        } else if gestureRecognizer == tapGesture {
            let isPointContained = menuContainerView.frame.contains(point)
            return !isMenuHidden() && !isPointContained
        }
        return true
    }
}

