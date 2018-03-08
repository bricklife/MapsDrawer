//
//  ViewController.swift
//  MapsDrawer
//
//  Created by ooba on 05/03/2018.
//  Copyright © 2018 ooba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    
    weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        pan.delegate = self
        view.addGestureRecognizer(pan)
        
        move(0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nav = segue.destination as! UINavigationController
        let table = nav.childViewControllers.first as! UITableViewController
        scrollView = table.tableView
    }
    
    func move(_ y: CGFloat) {
        topMargin.constant = 100 + y
    }
    
    var start: CGFloat = 0
    
    @objc func pan(_ pan: UIPanGestureRecognizer) {
        let position = pan.location(in: view)
        switch pan.state {
        case .began:
            start = position.y + scrollView.contentOffset.y
        case .changed:
            let diff = position.y - start
            if diff > 0 {
                move(diff)
                scrollView.contentOffset = .zero
                scrollView.showsVerticalScrollIndicator = false
            } else {
                move(0)
                scrollView.showsVerticalScrollIndicator = true
            }
        default:
            move(0)
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.scrollView.showsVerticalScrollIndicator = true
            })
        }
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
