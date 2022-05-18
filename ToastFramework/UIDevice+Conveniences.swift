//
//  UIDevice+Conveniences.swift
//  ToastFramework
//
//  Created by George Mihoc on 18.05.2022.
//

import UIKit

extension UIDevice {
    
    var safeAreaInsets: UIEdgeInsets {
        let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow})
        return window?.safeAreaInsets ?? UIEdgeInsets()
    }
    
    var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    var screenSizeWithScale: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: (screenSize.width * scale), height: (screenSize.height * scale))
    }
}
