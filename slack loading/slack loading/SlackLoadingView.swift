
//
//  SlackLoadingView.swift
//  slack loading
//
//  Created by ityike on 2016/9/25.
//  Copyright © 2016年 袁 峰. All rights reserved.
//

import UIKit


class SlackLoadingView: UIView, CAAnimationDelegate {
    
    var lineWidth:CGFloat = 0
    
    var lineLength:CGFloat = 0
    
    //边距
    var margin:CGFloat = 0
    
    //动画时间
    var duration:Double = 2
    
    //动画间隔时间
    var interval:Double = 1
    
    //四条线的颜色
    var colors:[UIColor] = [UIColor.init(rgba: "#9DD4E9"), UIColor.init(rgba: "#F5BD58"), UIColor.init(rgba: "#FF317E"), UIColor.init(rgba: "#6FC9B5")]
    
    //动画的状态
    private(set) var status:AnimationStatus = .Normal
    
    //四条线
    private var lines:[CAShapeLayer] = []
    
    enum AnimationStatus {
        //普通状态
        case Normal
        //动画中
        case Animating
        //暂停
        case Pause
    }
    
    
     //MARK: Initial Methods
    convenience init(fram: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = colors
        config()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }
    
    
    func animationDidStart(anim: CAAnimation) {
        if let animation = anim as? CABasicAnimation {
            if animation.keyPath == "transform.rotation.z" {
                status = .Animating
            }
        }
    }
    
    func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let animation = anim as? CABasicAnimation {
            if animation.keyPath == "strokEnd" {
                if flag {
                    status = .Normal
                    dispatch_after(DispatchTime.now(dispatch_time_t(DISPATCH_TIME_NOW), Int64(interval) * Int64(NSEC_PER_SEC)), dispatch_get_main_queue(), {
                        if self.status != .Animating {
                            self.startAnimation()
                        }
                    })
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch status {
        case .Animating:
            pauseAnimation()
        case .Pause:
            resumeAnimation()
        case .Normal:
            startAnimation()
        }
    }
    
    
    
    private func config() {
        lineLength = max(frame.width, frame.height)
        lineWidth = lineLength / 6.0
        margin = lineLength / 4.5 + lineWidth / 2.0
        drawLineShapeLayer()
        //调整角度
        transform = CGAffineTransform(rotationAngle: angle(angle: -30))
    }
    
    //MARK: 绘制线
    /**
     绘制四条线
     */
    
    private func drawLineShapeLayer() {
        //开始点
        let startPoint = [CGPoint(x: lineWidth / 2, y: margin),
                          CGPoint(x: lineLength - margin, y: lineWidth / 2),
                          CGPoint(x: lineLength - lineWidth / 2, y: lineLength - margin),
                          CGPoint(x: margin, y: lineLength - lineWidth / 2)]
        
        //结束点
        let endPoint = [CGPoint(x: lineLength - lineWidth / 2, y: margin),
                        CGPoint(x: lineLength - margin, y: lineLength - lineWidth / 2),
                        CGPoint(x: lineWidth / 2, y: lineLength - margin),
                        CGPoint(x: margin, y: lineWidth / 2)]
        
        for i in 0...2 {
            let line: CAShapeLayer = CAShapeLayer()
            line.lineWidth = lineWidth
            line.lineCap = kCALineCapRound
            line.opacity = 0.8
            line.strokeColor = colors[i].cgColor
            line.path = getLinePath(startPoint: startPoint[i], endPoint: endPoint[i]).cgPath
            layer.addSublayer(line)
            lines.append(line)
        }
     
        
    }
    
    /**
     获取线的路径
     
     - parameter startPoint: 开始点
     - parameter endPoint:   结束点
     
     - returns: 线的路径
     */
    private func getLinePath(startPoint: CGPoint, endPoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        return path
    }
    
   
//    private func point(x: CGFloat, y: CGFloat) -> CGPoint {
//        return CGPoint(x: x, y: y)
//    }
    
    private func angle(angle: Double) -> CGFloat {
        return CGFloat(angle * (M_PI) / 180)
    }
    
    
    //动画分解
    /**
     旋转的动画，旋转两圈
     */
    
    private func angleAnimation() {
        let angleAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        angleAnimation.fromValue = angle(angle: -30)
        angleAnimation.toValue = angle(angle: 690)
        angleAnimation.fillMode = kCAFillModeForwards
        angleAnimation.isRemovedOnCompletion = false
        angleAnimation.duration = duration
        angleAnimation.delegate = self
        layer.add(angleAnimation, forKey: "angleAnimation")
    }
    
    
    /**
    线的第一步动画，线长从长变短
    */
    
    private func lineAnimationOne() {
        let lineAnimationOne = CABasicAnimation.init(keyPath: "strokeEnd")
        lineAnimationOne.duration = duration / 2
        lineAnimationOne.fillMode = kCAFillModeForwards
        lineAnimationOne.isRemovedOnCompletion = false
        lineAnimationOne.fromValue = 1
        lineAnimationOne.toValue = 0
        for i in 0...3 {
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationOne, forKey: "lineAnimationOne")
        }
    }
    
    /**
     线的第二步动画，线向中间平移
     */
    
    private func lineAnimationTwo() {
        for i in 0...3 {
            var keypath = "transform.translation.x"
            if i % 2 == 1 {
                keypath = "transform.translation.y"
            }
            let lineAnimationTwo = CABasicAnimation.init(keyPath: keypath)
            lineAnimationTwo.beginTime = CACurrentMediaTime() + duration / 2
            lineAnimationTwo.duration = duration / 4
            lineAnimationTwo.fillMode = kCAFillModeForwards
            lineAnimationTwo.isRemovedOnCompletion = false
            lineAnimationTwo.autoreverses = true
            lineAnimationTwo.fromValue = 0
            
            if i < 2 {
                lineAnimationTwo.toValue = lineLength / 4
            } else {
                lineAnimationTwo.toValue = -lineLength / 4
            }
            
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationTwo, forKey: "lineAnimationTwo")
        }
        
        //三角形两边的比例
        let scale = (lineLength - 2 * margin) / (lineLength - lineWidth)
        for i in 0...3 {
            var keypath = "transform.translation.y"
            if i % 2 == 1 {
                keypath = "transform.translation.x"
            }
            
            let lineAnimationTwo = CABasicAnimation.init(keyPath: keypath)
            lineAnimationTwo.beginTime = CACurrentMediaTime() + duration / 2
            lineAnimationTwo.duration = duration / 4
            lineAnimationTwo.fillMode = kCAFillModeForwards
            lineAnimationTwo.isRemovedOnCompletion = false
            lineAnimationTwo.autoreverses = true
            lineAnimationTwo.fromValue = 0
            if i == 0 || i == 3 {
                lineAnimationTwo.toValue = lineLength / 4 * scale
            } else {
                lineAnimationTwo.toValue = -lineLength / 4 * scale
            }
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationTwo, forKey: "lineAnimationThree")
        }
    }
    
    /**
     线的第三步动画，线由短变长
     */
    
    private func lineAnimationThree() {
        //线移动的动画
        let lineAnimationFour = CABasicAnimation.init(keyPath: "strokeEnd")
        lineAnimationFour.beginTime = CACurrentMediaTime() + duration
        lineAnimationFour.duration = duration / 4
        lineAnimationFour.fillMode = kCAFillModeForwards
        lineAnimationFour.isRemovedOnCompletion = false
        lineAnimationFour.fromValue = 0
        lineAnimationFour.toValue = 1
        for i in 0...3 {
            if i == 3 {
                lineAnimationFour.delegate = self
            }
            let lineLayer = lines[i]
            lineLayer.add(lineAnimationFour, forKey: "lineAnimationFour")
        }
    }
    
    
    //MARK: Public Methods
    /**
     开始动画
     */
    
    
    func startAnimation() {
        angleAnimation()
        lineAnimationOne()
        lineAnimationTwo()
        lineAnimationThree()
    }
    
    /**
     暂停动画
     */
    func pauseAnimation() {
        layer.pauseAnimation()
        for lineLayer in lines {
            lineLayer.pauseAnimation()
        }
        status = .Pause
    }
    
    /**
    继续动画
    */
    func resumeAnimation() {
        layer.resumeAnimation()
        for lineLayer in lines {
            lineLayer.resumeAnimation()
        }
        status = .Animating
    }
    
    

}

extension CALayer {
    //暂停动画
    func pauseAnimation() {
        // 将当前时间CACurrentMediaTime转换为layer上的时间, 即将parent time转换为localtime
        let pauseTime = convertTime(CACurrentMediaTime(), from: nil)
        // 设置layer的timeOffset, 在继续操作也会使用到
        timeOffset = pauseTime
        // localtime与parenttime的比例为0, 意味着localtime暂停了
        speed = 0
        
    }
    
    //继续动画
    func resumeAnimation() {
        let pauseTime = timeOffset
        speed = 1
        timeOffset = 0
        beginTime = 0
        // 计算暂停时间
        let sincePause = convertTime(CACurrentMediaTime(), from: nil) - pauseTime
        // local time相对于parent time时间的beginTime
        beginTime = sincePause
    }
}










