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
	
	//UIEdgeInsetsInsetRect
	public func insetRect(rect: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(rect, self)
	}
}

extension UIOffset: Equatable {
	public static var zero: UIOffset {
		return UIOffsetZero
	}
}
