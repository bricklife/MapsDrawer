//
//  ViewController.swift
//  MapsDrawer
//
//  Created by ooba on 05/03/2018.
//  Copyright © 2018 ooba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var topOfTable: NSLayoutConstraint!
    @IBOutlet weak var topOfBar: NSLayoutConstraint!
    
    let threshold: CGFloat = 88
    let bottom: CGFloat = -44
    var top: CGFloat {
        return -view.frame.height + 60
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
    }
    
    func reset() {
        tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    
    var isHiddenDrawer: Bool = true
    func animation(hidden: Bool) {
        let y = hidden ? bottom : top
        self.topOfTable.constant = y
        self.topOfBar.constant = y
        self.isHiddenDrawer = hidden
        UIView.animate(withDuration: 0.3, animations: {
            self.tableView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if hidden {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        })
    }
    
    @IBAction func tap(_ sender: Any) {
        animation(hidden: !isHiddenDrawer)
    }
    
    @IBAction func pan(_ sender: Any) {
        guard let pan = sender as? UIPanGestureRecognizer else { return }
        let t = pan.translation(in: view)
        switch pan.state {
        case .began, .changed:
            let y = (isHiddenDrawer ? bottom : top) + t.y
            topOfTable.constant = y
            topOfBar.constant = y
        default:
            animation(hidden: t.y > threshold)
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isHiddenDrawer else { return }
        guard !scrollView.isDecelerating else { return }
        guard scrollView.isDragging else { return }
        let diff = -44 - scrollView.contentOffset.y
        if diff < 0 {
            topOfBar.constant = top
            scrollView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
            scrollView.showsHorizontalScrollIndicator = true
            scrollView.showsVerticalScrollIndicator = true
        } else {
            topOfBar.constant = top + diff
            scrollView.contentInset = UIEdgeInsets(top: 44 + diff, left: 0, bottom: 0, right: 0)
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        animation(hidden: scrollView.contentOffset.y < -threshold)
    }
}
