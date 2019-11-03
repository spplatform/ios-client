//
//  ViewController.swift
//  ios-client
//
//  Created by Kirill Klebanov on 6/8/19.
//  Copyright © 2019 Kirill Klebanov. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var polls: [Poll?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func loginTap(_ sender: Any) {
        login(loginTextField.text, password: passwordTextField.text)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPoll" {
            if let destinationVC = segue.destination as? PollViewController {
                destinationVC.polls = polls
            }
        }
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "openPoll") {
            
            if let vc: PollViewController = segue.destination as? PollViewController {
                vc.polls = polls
            }
            
        }
    }
}

extension LoginViewController {
    
    func login(_ login: String?, password: String?) {
       
        guard  let login = login, !login.isEmpty else {
            showSimpleError(text: "Введите логин")
            return
        }
        
        guard  let password = password, !password.isEmpty else {
            showSimpleError(text: "Введите пароль")
            return
        }
        
        let url = URL(string: "https://mean-goose-69.localtunnel.me/api/login")!
        var request = URLRequest(url: url)
        request.setValue("text/plain; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "login": login,
            "password": password
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.httpBody = jsonData
        
        Alamofire.request(request).responseJSON {[weak self] response in
//            guard response.result.isSuccess else {
//                print("Ошибка при запросе данных \(String(describing: response.result.error))")
//                return
//            }
            //print(response.value)
            
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                let fisrt = JSON["first-poll"] as! NSDictionary
                let fpoll = self?.parsePoll(f: fisrt)
                let second = JSON["second-poll"] as! NSDictionary
                let spoll = self?.parsePoll(f: second)
                //print(JSON)
                self?.polls = [Poll?]()
                
                self?.polls?.append(fpoll)
                self?.polls?.append(spoll)
            }
            
            if true {
                self?.performSegue(withIdentifier: "openPoll", sender: self)
            } else {
                self?.performSegue(withIdentifier: "openMain", sender: self)
            }
        }
    }
    
    func parsePoll(f: NSDictionary) -> Poll {
        let fPoll = Poll()
        fPoll.id = f["id"] as? Int
        fPoll.text = f["description"] as? String
        let qs = f["questions"] as? NSArray
        fPoll.questions = parseQuestion(rqs: qs)
        return fPoll
    }
    
    func parseQuestion(rqs: NSArray?) -> [Question]? {
        var qs = [Question]()
        if let rqs = rqs {
            for rq in rqs {
                if let rqd = rq as? NSDictionary{
                    let q = Question()
                    q.id = rqd["id"] as? Int
                    q.text = rqd["description"] as? String
                    let ans = rqd["answers"] as? NSArray
                    q.answers = parseAns(rans: ans)
                    qs.append(q)
                }
            }
        }
        return qs
    }
    
    func parseAns(rans: NSArray?) -> [Answer]? {
        var ans = [Answer]()
        if let rans = rans {
            for ran in rans {
                if let rand = ran as? NSDictionary{
                    let an = Answer()
                    an.id = rand["id"] as? Int
                    an.text = rand["description"] as? String
                    ans.append(an)
                }
            }
        }
        return ans
    }
    
    /// User enter errors
    func showSimpleError(text: String) {
        let alertController = UIAlertController(title: "Ошибка ввода данных", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ок", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

