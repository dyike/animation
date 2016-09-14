//
//  ViewController.swift
//  donghua
//
//  Created by ityike on 16/9/11.
//  Copyright © 2016年 袁 峰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //衡量，圆形视图的大小
    let kCircleViewSize: CGFloat = 90.0
    
    //圆形视图的变量
    var circleView: UIView!
    
    //动画开始、停止的标记
    var animationHappending = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //创建圆形视图
        setupCircleView()
        
        //添加欢动手势
        setupSwipeActions()
    }
    
    override func viewDidLayoutSubviews() {
        //避免圆形视图被多次添加
        //只要从navigation controller 或者model view返回
        //或者旋转屏幕，调用
        if (self.circleView.superview == nil) {
            //把圆形视图添加到主视图
            self.view.addSubview(self.circleView)
        }
        
        //圆形视图的位置在主视图中间
        self.circleView.center = self.view.center
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupCircleView() {
        //初始化子视图
        self.circleView = UIView(frame: CGRect(x: 0, y: 0, width: kCircleViewSize, height: kCircleViewSize))
        
        //把视图做成圆形
        //圆角的半径等于边长的一半
        self.circleView.layer.cornerRadius = kCircleViewSize / 2.0
        
        //圆形视图颜色
        self.circleView.backgroundColor = UIColor.red
    }
    
    //手势滑动
    func setupSwipeActions() {
        //向下滑动，及响应
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeOnMainView(_:)))
        //swipeDown.direction = .down
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        
        
        //向上滑动，及响应
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeOnMainView(_:)))
        //swipeUp.direction = .up
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
        
        
        //向左滑动，及响应
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeOnMainView(_:)))
        //swipeLeft.direction = .left
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        
        //向右滑动，及响应
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeOnMainView(_:)))
        //swipeLeft.direction = .right
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    
    func swipeOnMainView(_ swipe: UISwipeGestureRecognizer) {
        
        if (self.animationHappending) {
            return
        }
        
        //找出圆形视图的最终的位置，如果向下滑动，位置就为底部，否则为顶部。如果向左滑动，位置就在左边，否则就在右边。
        
        let frameBegin = self.circleView.frame
        var frameEnd: CGRect = frameBegin
        
        //        if (swipe.direction == .Down) {
        //            frameEnd = CGRectMake(frameBegin.origin.x, self.view.frame.size.height - kCircleViewSize, kCircleViewSize, kCircleViewSize)
        //        } else if (swipe.direction == .Up) {
        //            frameEnd = CGRectMake(frameBegin.origin.x, 0, kCircleViewSize, kCircleViewSize)
        //        } else if (swipe.direction == .Left) {
        //            frameEnd = CGRectMake(kCircleViewSize, kCircleViewSize, frameBegin.origin.x, 0)
        //        } else if (swipe.direction == .Right) {
        //            frameEnd = CGRectMake(kCircleViewSize, kCircleViewSize, frameBegin.origin.x, self.view.frame.size.height - kCircleViewSize)
        //        }
        
        
        switch swipe.direction {
        case UISwipeGestureRecognizerDirection.down:
            frameEnd = CGRect(x: frameBegin.origin.x, y: self.view.frame.size.height - kCircleViewSize, width: kCircleViewSize, height: kCircleViewSize)
        case UISwipeGestureRecognizerDirection.up:
            frameEnd = CGRect(x: frameBegin.origin.x, y: 0, width: kCircleViewSize, height: kCircleViewSize)
        case UISwipeGestureRecognizerDirection.left:
            frameEnd = CGRect(x: 0, y: frameBegin.origin.y, width: kCircleViewSize, height: kCircleViewSize)
        case UISwipeGestureRecognizerDirection.right:
            frameEnd = CGRect(x: self.view.frame.size.width - kCircleViewSize, y: frameBegin.origin.y, width: kCircleViewSize, height: kCircleViewSize)
        default:
            break
        }
        
        
        //动画开始
        self.animationHappending = true
        
        //在动画block中修改圆形视图的位置
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            
            self.circleView.frame = frameEnd
            
        }) {
            
            (finished) -> Void in
            self.animationHappending = false
            
        }
        
    }
    
    
    
}

