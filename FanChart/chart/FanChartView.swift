//
//  FanChartView.swift
//  FanChart
//
//  Created by fantaros on 16/4/11.
//  Copyright © 2016年 io.fantaros.github. All rights reserved.
//

import UIKit

class FanChartView: UIView {
    var render : RenderRegion?
    var defaultData : [[String : String]] = [[String : String]]()
    
    override init(frame: CGRect) {
                super.init(frame: frame)
        render = LineChartRender(parent: self, frame: frame);
        for var i : Int = 0; i < 100; i++ {
            defaultData.append(["close" : String(Double(arc4random_uniform(60) + 20))])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        if render != nil {
            let r : LineChartRender = render as! LineChartRender
            r.middlePrice = 50
            r.maxAbs = 50
            render?.render(UIGraphicsGetCurrentContext(), data: defaultData)
        }
    }
}
