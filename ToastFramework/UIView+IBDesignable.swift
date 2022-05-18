//
//  UIView+IBDesignable.swift
//  ToastFramework
//
//  Created by George Mihoc on 18.05.2022.
//

import UIKit

protocol HasNib: UIView { }

extension HasNib {
    static var nib: UINib {
        UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

/// Set root view's class in the matching filename to the class name -- don't use "File's Owner" to avoid crash
protocol NibLoadable: HasNib { }

extension NibLoadable {
    
    static func loadFromNib() -> Self {
        nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}
