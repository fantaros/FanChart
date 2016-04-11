//
//  DrawRegion.swift
//  FanChart
//
//  Created by fantaros on 16/4/11.
//  Copyright © 2016年 io.fantaros.github. All rights reserved.
//

import Foundation
import UIKit

protocol RenderRegion {
    var x : CGFloat {get set}
    var y : CGFloat {get set}
    var width : CGFloat {get set}
    var height : CGFloat {get set}
    var chartBackgroundColor : UIColor {get set}
    
    func render(context: CGContextRef?, data : [AnyObject]?)
}

class BaseRenderRegion  : RenderRegion {
    static let defaultBackgroundColor : UIColor = UIColor.whiteColor()
    var x : CGFloat = -1
    var y : CGFloat = -1
    var width : CGFloat = 0
    var height : CGFloat = 0
    var chartBackgroundColor : UIColor = BaseRenderRegion.defaultBackgroundColor
    unowned var parentView : UIView
    
    init (parent : UIView, frame : CGRect) {
        self.parentView = parent;
    }
    
    func render(context: CGContextRef?, data : [AnyObject]?) {
        
    }
}

enum BorderStyle {
    case Solid
    case Dash
}
