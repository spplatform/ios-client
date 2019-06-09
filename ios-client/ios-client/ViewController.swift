//
//  ViewController.swift
//  ios-client
//
//  Created by Kirill Klebanov on 6/8/19.
//  Copyright © 2019 Kirill Klebanov. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func loginTap(_ sender: Any) {
        login(loginTextField.text ?? "", password: passwordTextField.text ?? "")
    }
}

extension ViewController {
    
    func login(_ login: String, password: String) {
       
        let url = URL(string: "http://edu-server.herokuapp.com/api/login")!
        var request = URLRequest(url: url)
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "login": "13",
            "password": "Jack & Jill"
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON {[weak self] response in
//            guard response.result.isSuccess else {
//                print("Ошибка при запросе данных \(String(describing: response.result.error))")
//                return
//            }
            print(response.value)
            if false {
                self?.performSegue(withIdentifier: "openPoll", sender: self)
            } else {
                self?.performSegue(withIdentifier: "openMain", sender: self)
            }
        }
    }
}

