//
//  CustomLabel.swift
//  Fast Foodz
//
//  Created by Jeff on 2021/8/6.
//

import  UIKit
class CustomLabel: UILabel {
    let inset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }
    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.width += inset.left + inset.right
        intrinsicContentSize.height += inset.top + inset.bottom
        return intrinsicContentSize
    }
}
