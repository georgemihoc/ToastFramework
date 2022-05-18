//
//  HapticFeedback.swift
//  ToastFramework
//
//  Created by George Mihoc on 18.05.2022.
//

import UIKit

final class HapticFeedback {
    
    public enum FeedbackType {
        case success, warning, error, selection, impactLight, impactMedium, impactHeavy
    }
    
    static func generateFeedback(_ feedback: FeedbackType) {
        
        switch feedback {
        case .success       : UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning       : UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error         : UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .selection     : UISelectionFeedbackGenerator().selectionChanged()
        case .impactLight   : UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .impactMedium  : UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .impactHeavy   : UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
}
