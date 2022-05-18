//
//  ViewController.swift
//  ToastFrameworkExample
//
//  Created by George Mihoc on 19.05.2022.
//

import UIKit
import ToastFrameworkSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func basicToastSelected(_ sender: UIButton) {
        view.showToast(message: "This is a Basic Toast.")
    }
    
    @IBAction func basicToastGraySelected(_ sender: UIButton) {
        view.showToast(message: "This is a Basic Gray Toast.", color: .gray)
    }
    
}
