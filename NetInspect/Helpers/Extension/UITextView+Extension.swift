//
//  UITextView+Extension.swift
//  NetInspect
//
//  Created by Lê Minh Hiếu on 3/9/25.
//

import UIKit

@IBDesignable
class PaddedTextView: UITextView {

    @IBInspectable var paddingTop: CGFloat = 8 {
        didSet { updateInsets() }
    }

    @IBInspectable var paddingLeft: CGFloat = 8 {
        didSet { updateInsets() }
    }

    @IBInspectable var paddingBottom: CGFloat = 8 {
        didSet { updateInsets() }
    }

    @IBInspectable var paddingRight: CGFloat = 8 {
        didSet { updateInsets() }
    }

    private func updateInsets() {
        self.textContainerInset = UIEdgeInsets(
            top: paddingTop,
            left: paddingLeft,
            bottom: paddingBottom,
            right: paddingRight
        )
        self.textContainer.lineFragmentPadding = 0
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updateInsets()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateInsets()
    }

}
