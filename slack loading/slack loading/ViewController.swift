//
//  ViewController.swift
//  slack loading
//
//  Created by ityike on 2016/9/25.
//  Copyright © 2016年 袁 峰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loadingView : SlackLoadingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func sizeSliderValueChange(sender: UISlider) {
        loadingView.transform = CGAffineTransform.identity.scaledBy(x: CGFloat(sender.value), y: CGFloat(sender.value))
    }
    
    @IBAction func durationSliderValueChange(sender: UISlider) {
        loadingView.duration = Double(sender.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

