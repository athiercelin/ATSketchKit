//
//  ATColorPicker.swift
//  ATSketchKit
//
//  Created by Arnaud Thiercelin on 1/17/16.
//  Copyright © 2016 Arnaud Thiercelin. All rights reserved.
//

import UIKit

/**
This class provides a basic view to pick a new color using a color map
*/
@IBDesignable
public class ATColorPicker: UIView {

	public var delegate: ATColorPickerDelegate?
	
	public enum ColorSpace {
		case HSV
		case Custom
	}
	
	public var colorSpace = ColorSpace.HSV
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self.configure()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.configure()
	}
	
	func configure() {
		
	}
	
	// MARK: - Drawing
	public override func drawRect(rect: CGRect) {
		self.drawColorMap(rect)
	}
	
	func drawColorMap(rect: CGRect) {
		let context = UIGraphicsGetCurrentContext()
		
		for x in 0..<Int(rect.size.width) {
			for y in 0..<Int(rect.size.height) {
				let point = CGPoint(x: CGFloat(x), y: CGFloat(y))
				let color = colorAtPoint(point, inRect: rect)
				
				color.setFill()
				let rect = CGRectMake(CGFloat(x), CGFloat(y), 1.0, 1.0)
				CGContextFillRect(context, rect)
			}
		}
	}
	
	// MARK: - Event handling
	
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		// kickstart the flow.
	}
	
	public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let point = touches.first!.locationInView(self)
		let color = self.colorAtPoint(point, inRect: self.bounds)
		
			NSLog("Color At Point[\(point.x),\(point.y)]: \(color)")
		if self.delegate != nil {
			self.delegate!.colorPicker(self, didChangeToSelectedColor: color)
		}
	}
	
	public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		let point = touches.first!.locationInView(self)
		let color = self.colorAtPoint(point, inRect: self.bounds)

		if self.delegate != nil {
			self.delegate!.colorPicker(self, didEndSelectionWithColor: color)
		}
	}
	
	// MARK: - Convenience color methods
	
	func colorAtPoint(point: CGPoint, inRect rect: CGRect) -> UIColor {
		var color = UIColor.whiteColor()
		switch colorSpace {
		case .HSV:
			color = self.hsvColorAtPoint(point, inRect: rect)
		default:
			color = self.customColorAtPoint(point, inRect: rect)
		}
		return color
	}
	
	func customColorAtPoint(point: CGPoint, inRect rect: CGRect) -> UIColor {
		let x = point.x
		let y = point.y
		
		let redValue = (y/rect.size.height + (rect.size.width - x)/rect.size.width) / 2
		let greenValue = ((rect.size.height - y)/rect.size.height + (rect.size.width - x)/rect.size.width) / 2
		let blueValue = (y/rect.size.height + x/rect.size.width) / 2
		let color = UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
		
		return color
	}
	
	func hsvColorAtPoint(point: CGPoint, inRect rect: CGRect) -> UIColor {
		return UIColor(hue: point.x/rect.size.width, saturation: point.y/rect.size.height, brightness: 1.0, alpha: 1.0)
	}
	
	public override var description: String {
		get {
			return self.debugDescription
		}
	}
	
	public override var debugDescription: String{
		get {
			return "ATColorPicker \n" +
			"ColorSpace: \(self.colorSpace)\n"
		}
	}
}