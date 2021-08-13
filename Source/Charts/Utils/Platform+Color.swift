//
//  Platform+Color.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

#if canImport(UIKit)
import UIKit

public typealias NSUIColor = UIColor
public typealias NSUIBezierPath = UIBezierPath
private func fetchLabelColor() -> UIColor
{
    if #available(iOS 13, tvOS 13, *)
    {
        return .label
    }
    else
    {
        return .black
    }
}
private let labelColor: UIColor = fetchLabelColor()

extension UIColor
{
    static var labelOrBlack: UIColor { labelColor }
}
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public typealias NSUIColor = NSColor
public typealias NSUIBezierPath = NSBezierPath
private func fetchLabelColor() -> NSColor
{
    if #available(macOS 10.14, *)
    {
        return .labelColor
    }
    else
    {
        return .black
    }
}
private let labelColor: NSColor = fetchLabelColor()

extension NSColor
{
    static var labelOrBlack: NSColor { labelColor }
}

struct NSRectCorner: OptionSet {
   let rawValue: UInt
   
   static let none = NSRectCorner(rawValue: 0)
   static let topLeft = NSRectCorner(rawValue: 1 << 0)
   static let topRight = NSRectCorner(rawValue: 1 << 1)
   static let bottomLeft = NSRectCorner(rawValue: 1 << 2)
   static let bottomRight = NSRectCorner(rawValue: 1 << 3)
   static var all: NSRectCorner {
       return [.topLeft, .topRight, .bottomLeft, .bottomRight]
   }
   
  init(rawValue: UInt) {
       self.rawValue = rawValue
   }
}

extension NSBezierPath {
   var cgPath: CGPath {
       let path = CGMutablePath()
       var points = [CGPoint](repeating: .zero, count: 3)
       for i in 0 ..< self.elementCount {
           let type = self.element(at: i, associatedPoints: &points)
           switch type {
           case .moveTo:
               path.move(to: CGPoint(x: points[0].x, y: points[0].y))
           case .lineTo:
               path.addLine(to: CGPoint(x: points[0].x, y: points[0].y))
           case .curveTo:
               path.addCurve(
                   to: CGPoint(x: points[2].x, y: points[2].y),
                   control1: CGPoint(x: points[0].x, y: points[0].y),
                   control2: CGPoint(x: points[1].x, y: points[1].y))
           case .closePath:
               path.closeSubpath()
           }
       }
       return path
   }
   
   convenience init(roundedRect rect: NSRect, byRoundingCorners corners: NSRectCorner, cornerRadii: NSSize) {
       self.init()
       defer { close() }
       
       let topLeft = rect.origin
       let topRight = NSPoint(x: rect.maxX, y: rect.minY)
       let bottomRight = NSPoint(x: rect.maxX, y: rect.maxY)
       let bottomLeft = NSPoint(x: rect.minX, y: rect.maxY)
       
       if corners.contains(.topLeft) {
           move(to: CGPoint(x: topLeft.x + cornerRadii.width,
                            y: topLeft.y))
       } else {
           move(to: topLeft)
       }
       
       if corners.contains(.topRight) {
           line(to: CGPoint(x: topRight.x - cornerRadii.width,
                            y: topRight.y))
           curve(to: topRight,
                 controlPoint1: CGPoint(x: topRight.x,
                                        y: topRight.y + cornerRadii.height),
                 controlPoint2: CGPoint(x: topRight.x,
                                        y: topRight.y + cornerRadii.height))
       } else {
           line(to: topRight)
       }
       
       if corners.contains(.bottomRight) {
           line(to: CGPoint(x: bottomRight.x,
                            y: bottomRight.y - cornerRadii.height))
           curve(to: bottomRight,
                 controlPoint1: CGPoint(x: bottomRight.x - cornerRadii.width,
                                        y: bottomRight.y),
                 controlPoint2: CGPoint(x: bottomRight.x - cornerRadii.width,
                                        y: bottomRight.y))
       } else {
           line(to: bottomRight)
       }
       
       if corners.contains(.bottomLeft) {
           line(to: CGPoint(x: bottomLeft.x + cornerRadii.width,
                            y: bottomLeft.y))
           curve(to: bottomLeft,
                 controlPoint1: CGPoint(x: bottomLeft.x,
                                        y: bottomLeft.y - cornerRadii.height),
                 controlPoint2: CGPoint(x: bottomLeft.x,
                                        y: bottomLeft.y - cornerRadii.height))
       } else {
           line(to: bottomLeft)
       }
       
       if corners.contains(.topLeft) {
           line(to: CGPoint(x: topLeft.x,
                            y: topLeft.y + cornerRadii.height))
           curve(to: topLeft,
                 controlPoint1: CGPoint(x: topLeft.x + cornerRadii.width,
                                        y: topLeft.y),
                 controlPoint2: CGPoint(x: topLeft.x + cornerRadii.width,
                                        y: topLeft.y))
       } else {
           line(to: topLeft)
       }
   }
}

#endif
