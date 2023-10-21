//
//  CustomIntensityVisualEffectView.swift
//  Carmu
//
//  Created by 김영빈 on 2023/10/11.
//

import UIKit

// MARK: - 커스텀으로 강도를 설정해서 Visual Effect를 추가하기 위한 뷰
final class CustomIntensityVisualEffectView: UIVisualEffectView {

    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    init(effect: UIVisualEffect, intensity: CGFloat) {
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [unowned self] in self.effect = effect }
        animator?.fractionComplete = intensity
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: Private
    private var animator: UIViewPropertyAnimator?

}
