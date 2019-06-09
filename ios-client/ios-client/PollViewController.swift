//
//  PollViewController.swift
//  ios-client
//
//  Created by Kirill Klebanov on 6/9/19.
//  Copyright © 2019 Kirill Klebanov. All rights reserved.
//

import UIKit

class PollViewController: UIViewController {

    var polls: [Poll?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Poll print \(polls)")
    }
}
