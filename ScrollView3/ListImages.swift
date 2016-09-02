//
//  ListImages.swift
//  ScrollView3
//
//  Created by Hoàng Minh Thành on 9/1/16.
//  Copyright © 2016 Hoàng Minh Thành. All rights reserved.
//

import UIKit

class ListImages: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func onTouch(sender: AnyObject) {
        switch (sender.tag) {
        case 101 : pushView(0)
        case 102 : pushView(1)
        case 103 : pushView(2)
        default: break
        }
    }
    func pushView(index:Int)
    {
        let listView = self.storyboard?.instantiateViewControllerWithIdentifier("ViewScroll") as? ViewScroll
        listView?.currentPage = index
        self.navigationController?.pushViewController(listView!, animated: true)
    }
}
