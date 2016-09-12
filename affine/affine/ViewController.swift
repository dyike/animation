//
//  ViewController.swift
//  affine
//
//  Created by ityike on 16/9/12.
//  Copyright © 2016年 袁 峰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    let kCircleViewSize: CGFloat = 100.0
    
    var circleView: UIView!
    
    var animationHappending = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        setupCircleView()
        
        
        //创建点击事件
        setupTapActions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        //避免圆形视图被多次添加
        //只要从navigation controller 或者 modal view 返回，或者旋转，这里就会被调用）
        if (self.circleView.superview == nil) {
             //把圆形视图添加到主视图
            self.view.addSubview(self.circleView)
        }
        //圆形视图的位置在主视图中间
        self.circleView.center = self.view.center
    }
    
    
    func setupCircleView() {
        self.circleView = UIView(frame: CGRectMake(0, 0, kCircleViewSize, kCircleViewSize))
        
        self.circleView.layer.cornerRadius = kCircleViewSize / 2.0
        
        self.circleView.backgroundColor = UIColor.redColor()
     
    }
    
    
    func setupTapActions() {
        //添加单击功能响应方法
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedOnMainView(_:)))
        
        singleTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(singleTap)
        
        //添加双击功能响应方法
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tappedOnMainView(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
        
        
        //双击时忽略单机，这个非常重要
        singleTap.requireGestureRecognizerToFail(doubleTap)
    
        
    }
    
    
    func tappedOnMainView(tap: UITapGestureRecognizer) {
        if (self.animationHappending) {
            return
        }
        
        //默认状态，为双击准备
        var transform = CGAffineTransformIdentity
        
        if (tap.numberOfTapsRequired == 1) {
            transform = CGAffineTransformScale(self.circleView.transform, 1.3, 1.3)
        }
        
        //开始动画
        self.animationHappending = true
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            //动画放大缩小
            self.circleView.transform = transform
        }) {
            (finished) -> Void in
            //动画完成
            self.animationHappending = false
        }
    }


}

