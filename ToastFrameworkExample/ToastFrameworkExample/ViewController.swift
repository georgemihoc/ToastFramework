//
//  ViewController.swift
//  ToastFrameworkExample
//
//  Created by George Mihoc on 19.05.2022.
//

import ToastFrameworkSwift
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup configurable properties
        setupToastManager()
    }

    @IBAction func basicToastSelected(_ sender: UIButton) {
        presentBasicToast()
    }

    @IBAction func basicToastGraySelected(_ sender: UIButton) {
        presentBasicGrayToast()
    }
    
    @IBAction func basicBlackTextToastSelected(_ sender: UIButton) {
        presentBasicBlackTextToast()
    }
    
    @IBAction func ctaToastSelected(_ sender: UIButton) {
        presentCTAToast()
    }
}

// MARK: - Private

private extension ViewController {
    /// Setup configurable properties
    func setupToastManager() {
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isSwipeToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = true
        ToastManager.shared.duration = 2
        ToastManager.shared.areHapticsEnabled = true
    }

    func presentBasicToast() {
        view.showToast(message: "This is a Basic Toast.")
    }

    func presentBasicGrayToast() {
        view.showToast(message: "This is a Basic Gray Toast.", toastColor: .gray)
    }
    
    func presentBasicBlackTextToast() {
        view.showToast(message: "This is a Basic Gray Toast.", toastColor: .gray, textColor: .black)
    }

    func presentCTAToast() {
        view.showCTAToast(message: "This is a CTA Toast.", actionTitle: "Press here") { [weak self] in
            self?.view.showToast(message: "This is the follow-up Toast.", toastColor: .systemGreen)
        }
    }
}
