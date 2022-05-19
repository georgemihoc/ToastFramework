//
//  ToastView.swift
//  ToastFramework
//
//  Created by George Mihoc on 18.05.2022.
//

import UIKit

class ToastView: UIView, NibLoadable {

    @IBOutlet weak var toastLabel: UILabel!
    
    internal func setUpWith(message: String, toastColor: UIColor, textColor: UIColor) {
        toastLabel.text = message
        toastLabel.textColor = textColor
        backgroundColor = toastColor
    }
}
