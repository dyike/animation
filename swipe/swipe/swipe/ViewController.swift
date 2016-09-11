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
        self.circleView = UIView(frame: CGRectMake(0, 0, kCircleViewSize, kCircleViewSize))
        
        //把视图做成圆形
        //圆角的半径等于边长的一半
        self.circleView.layer.cornerRadius = kCircleViewSize / 2.0
        
        //圆形视图颜色
        self.circleView.backgroundColor = UIColor.redColor()
    }
    
    //手势滑动
    func setupSwipeActions() {
        //向下滑动，及响应
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeOnMainView(_:)))
        //swipeDown.direction = .Down
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
        
        //向上滑动，及响应
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeOnMainView(_:)))
        //swipeUp.direction = .Up
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view.addGestureRecognizer(swipeUp)
        
        
        //向左滑动，及响应
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeOnMainView(_:)))
        //swipeLeft.direction = .Left
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        
        //向右滑动，及响应
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.swipeOnMainView(_:)))
        //swipeLeft.direction = .Right
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
    }
    
    
    func swipeOnMainView(swipe: UISwipeGestureRecognizer) {
        
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
        case UISwipeGestureRecognizerDirection.Down:
            frameEnd = CGRectMake(frameBegin.origin.x, self.view.frame.size.height - kCircleViewSize, kCircleViewSize, kCircleViewSize)
        case UISwipeGestureRecognizerDirection.Up:
            frameEnd = CGRectMake(frameBegin.origin.x, 0, kCircleViewSize, kCircleViewSize)
        case UISwipeGestureRecognizerDirection.Left:
            frameEnd = CGRectMake(0, frameBegin.origin.y, kCircleViewSize, kCircleViewSize)
        case UISwipeGestureRecognizerDirection.Right:
            frameEnd = CGRectMake(self.view.frame.size.width - kCircleViewSize, frameBegin.origin.y, kCircleViewSize, kCircleViewSize)
        default:
            break
        }
        
        
        //动画开始
        self.animationHappending = true
        
        //在动画block中修改圆形视图的位置
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.circleView.frame = frameEnd
        }) {
            (finished) -> Void in
            self.animationHappending = false
        }
        
    }
    
    
    
}

