//
//  SwiftAdditions.swift
//  UIKit
//
//  Created by C.W. Betts on 1/22/16.
//
//

import Foundation

public func ==(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> Bool {
	return UIEdgeInsetsEqualToEdgeInsets(lhs, rhs)
}

public func ==(lhs: UIOffset, rhs: UIOffset) -> Bool {
	return UIOffsetEqualToOffset(lhs, rhs)
}

extension UIEdgeInsets: Equatable {
	public static var zero: UIEdgeInsets {
		return UIEdgeInsetsZero
	}
	
	public func inset(rect: CGRect) -> CGRect {
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
		return self == .landscapeLeft || self == .landscapeRight
	}
	
	public var isPortrait: Bool {
		return self == .portrait || self == .portraitUpsideDown
	}
	
	public var isFlat: Bool {
		return self == .faceUp || self == .faceDown
	}
	
	public var isValidInterfaceOrientation: Bool {
		return self != .unknown
	}
}

extension UIInterfaceOrientation {
	public var isLandscape: Bool {
		return self == .landscapeLeft || self == .landscapeRight
	}
	
	public var isPortrait: Bool {
		return self == .portrait || self == .portraitUpsideDown
	}
}

extension UIActionSheet {
	public convenience init(title: String?, delegate: UIActionSheetDelegate?, cancelButtonTitle: String?, destructiveButtonTitle: String?, otherButtonTitles firstButtonTitle: String, _ moreButtonTitles: String...) {
		self.init(title: title, delegate: delegate, cancelButtonTitle: cancelButtonTitle, destructiveButtonTitle: destructiveButtonTitle)
		addButton(withTitle: firstButtonTitle)
		for str in moreButtonTitles {
			addButton(withTitle: str)
		}
	}
}

extension UIColor: _ExpressibleByColorLiteral {
	public required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
		self.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
	}
}

public func UIDeviceOrientationIsLandscape(_ orientation: UIDeviceOrientation) -> Bool {
	return orientation.isLandscape
}

public func UIDeviceOrientationIsPortrait(_ orientation: UIDeviceOrientation) -> Bool {
	return orientation.isPortrait
}

public func UIDeviceOrientationIsValidInterfaceOrientation(_ orientation: UIDeviceOrientation) -> Bool {
	return orientation.isValidInterfaceOrientation
}

public func UIInterfaceOrientationIsLandscape(_ orientation: UIInterfaceOrientation) -> Bool {
	return orientation.isLandscape
}

public func UIInterfaceOrientationIsPortrait(_ orientation: UIInterfaceOrientation) -> Bool {
	return orientation.isPortrait
}
