//
//  LineRender.swift
//  FanChart
//
//  Created by fantaros on 16/4/11.
//  Copyright © 2016年 io.fantaros.github. All rights reserved.
//

import Foundation
import UIKit

class LineChartRender  : BaseRenderRegion {
    static let defaultOuterLineColor : UIColor = UIColor.blackColor()
    static let defaultLineColor : UIColor = UIColor.blueColor()
    static let defaultBorderColor : UIColor = UIColor.lightGrayColor()
    var lineColor : UIColor = LineChartRender.defaultLineColor
    var outerLineColor : UIColor = LineChartRender.defaultOuterLineColor
    var borderColor : UIColor = LineChartRender.defaultBorderColor
    var borderStyle : BorderStyle = BorderStyle.Solid
    var borderWidth : CGFloat = 0.5
    var lineWidth : CGFloat = 1
    var middlePrice : Double?
    var maxAbs : Double?
    
    override init(parent: UIView, frame : CGRect) {
        super.init(parent: parent, frame: frame)
        self.x = frame.origin.x
        self.y = frame.origin.y
        self.width = frame.size.width
        self.height = frame.size.height
    }
    
    override func render(context: CGContextRef?, data: [AnyObject]?) {
        if context != nil && data != nil && middlePrice != nil && maxAbs != nil {
            self.parentView.backgroundColor = self.chartBackgroundColor
            self.parentView.opaque = true
            
            CGContextSaveGState(context)
            CGContextSetLineWidth(context, self.borderWidth)
            CGContextSetFillColorWithColor(context, self.chartBackgroundColor.CGColor)
            CGContextSetStrokeColorWithColor(context, self.chartBackgroundColor.CGColor)
            let backrect : CGRect = CGRectMake(self.x + self.borderWidth, self.y + self.borderWidth, self.width - self.borderWidth, self.height - self.borderWidth)
            CGContextAddRect(context, backrect)
            CGContextFillPath(context)
            // 恢复我们保存的绘画状态
            CGContextRestoreGState(context)
            
            if data?.count < 1 {
                return
            }
            
            let gap : CGFloat
            
            if (data?.count == 0) {
                gap = 3
            } else {
                gap = self.width / CGFloat((data?.count)!)
            }
            
            //渐变色
            let cs : CGColorSpaceRef? = CGColorSpaceCreateDeviceRGB()!
            let colors : [CGFloat] = [0.85, 0.89, 0.95, 1.0, 1.0, 1.0, 1.0, 1.0]
            let locations : [CGFloat] = [1, 0]
            var gradient : CGGradientRef? = nil
            if cs != nil {
                gradient = CGGradientCreateWithColorComponents(cs!, colors, locations, 2)
                //                CGColorSpaceRelease(cs);
            }
            
            // 绘价格线
            // 绘画前，保存绘画上下文状态
            CGContextSetLineWidth(context, self.lineWidth);
            CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
            
            var startX : CGFloat?, currentX : CGFloat?, currentY : CGFloat?, maxX : CGFloat?, maxY : CGFloat?
            
            //    lastX, lastY;
            var index : UInt = 0;
            var maxPrice : Double = 0;
            currentX = self.x - self.borderWidth + CGFloat(index) * gap
            var model : [String : String]? = data![0] as? [String : String]
            if model != nil {
                let price : Double = Double(model!["close"]!)!
                maxPrice = price;
                if (self.maxAbs == 0) {
                    currentY = self.y + 0.5 * self.height
                }else{
                    currentY = self.y + CGFloat(self.middlePrice! + self.maxAbs! - price) / CGFloat(2 * self.maxAbs!) * (self.height)
                }
            }
            
            startX = currentX;
//            startY = currentY;
            index++;
            CGContextSaveGState(context)
            CGContextBeginPath(context)
            var cmodel : [String : String]?
            let path : UIBezierPath = UIBezierPath()
            path.moveToPoint(CGPointMake(startX!, self.y + self.height))
            path.addLineToPoint(CGPointMake(currentX!, currentY!))
            
            index++
            cmodel = nil
            for ; index < UInt((data?.count)!); index++ {
                currentX = self.x + CGFloat(index) * gap
                cmodel = data![Int(index)] as? [String : String]
                let price : Double = Double(cmodel!["close"]!)!
                if self.maxAbs == 0 {
                    currentY = self.y + 0.5 * self.height;
                }else{
                    currentY = self.y + CGFloat(self.middlePrice! + self.maxAbs! - price) / CGFloat(2 * self.maxAbs!) * (self.height)
                }
                if price > maxPrice {
                    maxX = currentX
                    maxY = currentY
                    maxPrice = price
                }
                path.addLineToPoint(CGPointMake(currentX!, currentY!))
            }
            path.addLineToPoint(CGPointMake(currentX!, self.y + self.height))
            path.addLineToPoint(CGPointMake(startX!, self.y + self.height))
            path.addClip()
            if gradient != nil {
                CGContextDrawLinearGradient(context, gradient, CGPointMake(maxX!, self.y + self.height), CGPointMake(maxX!, maxY!), CGGradientDrawingOptions.DrawsBeforeStartLocation)
            }
            
            // 恢复我们保存的绘画状态
            CGContextRestoreGState(context)
//            CGGradientRelease(gradient);
            
            CGContextSetStrokeColorWithColor(context, self.outerLineColor.CGColor)
            CGContextSetFillColorWithColor(context, self.outerLineColor.CGColor)
            CGContextSaveGState(context)
            CGContextSetLineWidth(context, self.borderWidth)
            CGContextBeginPath(context)
            
            // 绘分时线边沿
            index = 0;
            currentX = self.x + CGFloat(index) * gap
            model = data![0] as? [String : String]
            if model != nil {
                let price : Double = Double(model!["close"]!)!
                maxPrice = price
                if (self.maxAbs == 0) {
                    currentY = self.y + 0.5 * self.height
                }else{
                    currentY = self.y + CGFloat(self.middlePrice! + self.maxAbs! - price) / CGFloat(2 * self.maxAbs!) * (self.height)
                }
            }
            CGContextMoveToPoint(context, currentX!, currentY!)
            index++;
            cmodel = nil;
            for ; index < UInt((data?.count)!); index++ {
                currentX = self.x + CGFloat(index) * gap
                cmodel = data![Int(index)] as? [String : String]
                let price : Double = Double(cmodel!["close"]!)!
                if (self.maxAbs == 0) {
                    currentY = self.y + 0.5 * self.height
                }else{
                    currentY = self.y + CGFloat(self.middlePrice! + self.maxAbs! - price) / CGFloat(2 * self.maxAbs!) * (self.height)
                }
                if (currentY > (self.y + self.height - 0.1)) {
                    currentY = (self.y + self.height - 0.1)
                }
                path.addLineToPoint(CGPointMake(currentX!, currentY!))
            }
            CGContextStrokePath(context)
            // 恢复我们保存的绘画状态
            CGContextRestoreGState(context)
            
        }
    }
}