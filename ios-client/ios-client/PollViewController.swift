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
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
