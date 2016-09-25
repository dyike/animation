//
//  ViewController.swift
//  coolAnimator
//
//  Created by ityike on 16/9/14.
//  Copyright © 2016年 袁 峰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var circleCenter: CGPoint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        setupCircleView()
        
        setupDragActions()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //创建圆形视图
    func setupCircleView() {
        
        let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        circle.center = self.view.center
        circle.layer.cornerRadius = 60.0
        circle.backgroundColor = UIColor.red
        
    }
    
    func setupDragActions() {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panedOnMainView(_:)))
        self.view.addGestureRecognizer(drag)
    }
    


}

