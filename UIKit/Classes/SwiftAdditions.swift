//
//  SwiftAdditions.swift
//  UIKit
//
//  Created by C.W. Betts on 1/22/16.
//
//

import Foundation

@warn_unused_result
public func ==(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> Bool {
	return UIEdgeInsetsEqualToEdgeInsets(lhs, rhs)
}

@warn_unused_result
public func ==(lhs: UIOffset, rhs: UIOffset) -> Bool {
	return UIOffsetEqualToOffset(lhs, rhs)
}

extension UIEdgeInsets: Equatable {
	public static var zero: UIEdgeInsets {
		return UIEdgeInsetsZero
	}
	
	public func insetRect(rect: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(rect, self)
	}

}

extension UIOffset: Equatable {
	public static var zero: UIOffset {
		return UIOffsetZero
	}
}

extension UIDeviceOrientation {
	public var isLandscape: Bool {
		return self == .LandscapeLeft || self == .LandscapeRight
	}
	
	public var isPortrait: Bool {
		return self == .Portrait || self == .PortraitUpsideDown
	}
	
	public var isFlat: Bool {
		return self == .FaceUp || self == .FaceDown
	}
	
	public var isValidInterfaceOrientation: Bool {
		return self != .Unknown
	}
}

extension UIInterfaceOrientation {
	public var isLandscape: Bool {
		return self == .LandscapeLeft || self == .LandscapeRight
	}
	
	public var isPortrait: Bool {
		return self == .Portrait || self == .PortraitUpsideDown
	}
}

extension UIActionSheet {
	public convenience init(title: String?, delegate: UIActionSheetDelegate?, cancelButtonTitle: String?, destructiveButtonTitle: String?, otherButtonTitles firstButtonTitle: String, _ moreButtonTitles: String...) {
		self.init(title: title, delegate: delegate, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: destructiveButtonTitle)
		addButtonWithTitle(firstButtonTitle)
		for str in moreButtonTitles {
			addButtonWithTitle(str)
		}
	}
}

extension UIColor: _ColorLiteralConvertible {
	public required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
		self.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
	}
}

@warn_unused_result
public func UIDeviceOrientationIsLandscape(orientation: UIDeviceOrientation) -> Bool {
	return orientation.isLandscape
}

@warn_unused_result
public func UIDeviceOrientationIsPortrait(orientation: UIDeviceOrientation) -> Bool {
	return orientation.isPortrait
}

@warn_unused_result
public func UIDeviceOrientationIsValidInterfaceOrientation(orientation: UIDeviceOrientation) -> Bool {
	return orientation.isValidInterfaceOrientation
}

@warn_unused_result
public func UIInterfaceOrientationIsLandscape(orientation: UIInterfaceOrientation) -> Bool {
	return orientation.isLandscape
}

@warn_unused_result
public func UIInterfaceOrientationIsPortrait(orientation: UIInterfaceOrientation) -> Bool {
	return orientation.isPortrait
}
