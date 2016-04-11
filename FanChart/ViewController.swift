//
//  ViewController.swift
//  FanChart
//
//  Created by fantaros on 16/4/11.
//  Copyright © 2016年 io.fantaros.github. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var baseView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func viewDidAppear(animated: Bool) {
        let chartView : FanChartView = FanChartView(frame: baseView.frame)
        baseView.addSubview(chartView)
        chartView.setNeedsDisplay()
    }

}

