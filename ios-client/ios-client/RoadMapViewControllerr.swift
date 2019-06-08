//
//  RoadMapViewController.swift
//  ios-client
//
//  Created by Kirill Klebanov on 6/8/19.
//  Copyright © 2019 Kirill Klebanov. All rights reserved.
//


import UIKit
import TangramKit

class TGLocusPathLayout: TGPathLayout {
    
    override class var layerClass: Swift.AnyClass {
        return CAShapeLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    private func setup() {
        let shapeLayer = layer as! CAShapeLayer
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = nil
    }

}

class RoadMapViewController: UIViewController {
    
    var myPathLayout: TGLocusPathLayout!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let scrollView = UIScrollView()
        
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        
//        let degrees: CGFloat  = 90 //the value in degrees
//        scrollView.transform = CGAffineTransform(rotationAngle: degrees * CGFloat(Double.pi)/180)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        myPathLayout = TGLocusPathLayout()
        myPathLayout.backgroundColor = .white
//        myPathLayout.tg_height.equal(scrollView)
//        myPathLayout.tg_width.equal(scrollView)
        //
        
        myPathLayout.tg_height.equal(.wrap).min(scrollView).and().tg_width.equal(.wrap).min(scrollView)
        //myPathLayout.tg_padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        scrollView.addSubview(myPathLayout)
        
        myPathLayout.tg_coordinateSetting.isReverse = !myPathLayout.tg_coordinateSetting.isReverse
        
        changeFunc(index: .sin)
        
        handleAdd()
        handleAdd()
//        handleAdd()
//        handleAdd()
//        
//        handleAdd()
//        handleAdd()
//        handleAdd()
//        handleAdd()
//        
//        handleAdd()
//        handleAdd()
//        handleAdd()
//        handleAdd()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(RoadMapViewController.handleRevrse(sender:))),
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(RoadMapViewController.handleAction(sender:))),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(RoadMapViewController.handleAdd(sender:)))
        ]
        
        //myPathLayout.tg_coordinateSetting.isReverse = !myPathLayout.tg_coordinateSetting.isReverse
        
        
    }
    
    @objc func handleRevrse(sender: UIBarButtonItem) {
        myPathLayout.tg_coordinateSetting.isReverse = !myPathLayout.tg_coordinateSetting.isReverse
        myPathLayout.tg_layoutAnimationWithDuration(0.3)
    }
    
    enum CurveType: String {
        case straight_line
        case sin
        case cycloid
        case spiral_like
        case cardioid
        case astroid
        case cancle
    }
    
    let titles: [CurveType] = [.straight_line, .sin, .cycloid, .spiral_like, .cardioid, .astroid, .cancle]
    
    @objc func handleAction(sender: UIBarButtonItem? = nil) {
        
        let sheet = UIAlertController(title: "Curve Type", message: nil, preferredStyle: .actionSheet)
        
        for title in titles {
            var style: UIAlertAction.Style = .default
            if title == .cancle {
                style = .cancel
            }
            
            let action = UIAlertAction(title: title.rawValue, style: style, handler: { action in
                
                switch action.title! {
                case "straight_line":
                    self.actionSheetAction(type: .straight_line)
                case "sin":
                    self.actionSheetAction(type: .sin)
                case "cycloid":
                    self.actionSheetAction(type: .cycloid)
                case "spiral_like":
                    self.actionSheetAction(type: .spiral_like)
                case "cardioid":
                    self.actionSheetAction(type: .cardioid)
                case "astroid":
                    self.actionSheetAction(type: .astroid)
                case "cancle": break
                default: break
                }
            })
            
            sheet.addAction(action)
        }
        
        present(sheet, animated: true, completion: nil)
        
    }
    
    let colors: [UIColor] = [.red, .gray, .blue, .orange, .black, .purple]
    
    var randomColor: UIColor {
        return colors[Int(arc4random_uniform(UInt32(colors.count)))]
    }
    
    @objc func handleAdd(sender: UIBarButtonItem? = nil) {
        
        var pt = CGPoint.zero
        if myPathLayout.tg_pathSubviews.count > 0 {
            pt = myPathLayout.tg_pathSubviews.last!.frame.origin
        }
        
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 10
        btn.layer.masksToBounds = true
        btn.center = pt
        btn.tg_width.equal(150)
        btn.tg_height.equal(100)
        btn.backgroundColor = randomColor
        btn.addTarget(self, action: #selector(RoadMapViewController.handleDel(sender:)), for: .touchUpInside)
        
        myPathLayout.addSubview(btn)
        myPathLayout.tg_layoutAnimationWithDuration(0.3)
    }
    
    @objc func handleDel(sender: UIButton) {
        sender.removeFromSuperview()
        myPathLayout.tg_layoutAnimationWithDuration(0.3)
    }
    
    func actionSheetAction(type: CurveType) {
        changeFunc(index: type)
        myPathLayout.setNeedsLayout()
        myPathLayout.tg_layoutAnimationWithDuration(0.5)
    }
    
    func changeFunc(index of: CurveType) {
        
        switch of {
        case .straight_line:
            myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0, y: 0)
            myPathLayout.tg_coordinateSetting.isMath = false
            myPathLayout.tg_coordinateSetting.start = nil
            myPathLayout.tg_coordinateSetting.end = nil
            myPathLayout.tg_spaceType = .fixed(60)
            myPathLayout.tg_rectangularEquation = { $0 * 2 }
            
        case .sin:
            myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0, y: 0.5)
            myPathLayout.tg_coordinateSetting.isMath = true
            myPathLayout.tg_coordinateSetting.start = nil
            myPathLayout.tg_coordinateSetting.end = nil
            myPathLayout.tg_spaceType = .fixed(CGFloat(Double.pi*100-20))
            myPathLayout.tg_rectangularEquation = {
                //print("index \($0) value \(100 * sin(TGRadian(angle:$0).value))")
                return 100 * (sin(TGRadian(angle:$0 + 90).value)) + 250
            }
            
        case .cycloid:
            myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0, y: 0.5)
            myPathLayout.tg_coordinateSetting.isMath = true
            myPathLayout.tg_coordinateSetting.start = nil
            myPathLayout.tg_coordinateSetting.end = nil
            myPathLayout.tg_spaceType = .fixed(100)
            myPathLayout.tg_parametricEquation = {
                let t = TGRadian(angle:$0).value
                let a: CGFloat = 50
                return CGPoint(x: a * (t - sin(t)), y: a * (1 - cos(t)))
            }
        
        case .spiral_like:
            myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0.5, y: 0.5)
            myPathLayout.tg_coordinateSetting.isMath = false
            myPathLayout.tg_coordinateSetting.start = nil
            myPathLayout.tg_coordinateSetting.end = nil
            myPathLayout.tg_spaceType = .fixed(60)
            myPathLayout.tg_polarEquation = { 20 * $0 }
            
        case .cardioid:
            myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0.2, y: 0.5)
            myPathLayout.tg_coordinateSetting.isMath = true
            myPathLayout.tg_coordinateSetting.start = nil
            myPathLayout.tg_coordinateSetting.end = nil
            myPathLayout.tg_spaceType = .flexed
            myPathLayout.tg_polarEquation = { 120 * (1 + cos(CGFloat($0))) }
            
        case .astroid:
            myPathLayout.tg_coordinateSetting.origin = CGPoint(x: 0.5, y: 0.5)
            myPathLayout.tg_coordinateSetting.isMath = true
            myPathLayout.tg_coordinateSetting.start = 0
            myPathLayout.tg_coordinateSetting.end = 360
            myPathLayout.tg_spaceType = .flexed
            myPathLayout.tg_parametricEquation = { CGPoint(x: 150 * pow(cos(TGRadian(angle:$0).value), 3), y: 150 * pow(sin(TGRadian(angle:$0).value), 3)) }
            
        default: break
        }
    }
}
