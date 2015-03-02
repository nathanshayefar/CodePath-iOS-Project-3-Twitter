//
//  HamburgerViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 3/1/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class HamburgerViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    
    private var originalContainerViewCenter: CGPoint?
    private var containerViewMinRightCenter: CGPoint?
    private var containerViewMaxRightCenter: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.containerViewMinRightCenter = CGPoint(x: -containerView.bounds.width, y: view.center.y)
        self.containerViewMaxRightCenter = CGPoint(x: containerView.bounds.width / 2, y: view.center.y)
    }

    @IBAction func onPanContainerView(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        switch sender.state {
        case .Began:
            println("began")
            
            originalContainerViewCenter = self.containerView.center
        case .Changed:
            println("changed")
            
            containerView.center = CGPoint(x: self.originalContainerViewCenter!.x + translation.x, y: self.originalContainerViewCenter!.y)
        case .Ended:
            println("ended")
            
            if velocity.x > 0 {
                containerView.center = self.containerViewMaxRightCenter!
            } else {
                containerView.center = self.containerViewMinRightCenter!
            }
        default:
            println("other action")
        }
    }
}
