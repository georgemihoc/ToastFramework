//
//  CTAToastView.swift
//  ToastFramework
//
//  Created by George Mihoc on 18.05.2022.
//

import UIKit

final class CTAToastView: UIView, NibLoadable {

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    
    private var action: (() -> Void)?

    @IBAction func didTapOnButton(_ sender: Any) {
        action?()
    }
    
    func setUpWith(message: String, toastColor: UIColor, textColor: UIColor, actionTitle: String, didTapOnAction: @escaping () -> Void) {
        self.action = didTapOnAction
        textLabel.text = message
        actionButton.setTitle(actionTitle, for: .normal)
        backgroundColor = toastColor
    }
}
