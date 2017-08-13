//
//  FancyTextField.swift
//  ExploringRxSwift
//
//  Created by Aleksey Kuznetsov on 13/08/2017.
//  Copyright © 2017 Aleksey Kuznetsov. All rights reserved.
//

import UIKit
import Cartography
import RxSwift
import RxCocoa

class FancyTextField: UIView {

    private let textField = UITextField()
    private let grayLineView = UIView()
    private let colorLineView = UIView()

    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        textField.borderStyle = .none
        addSubview(textField)

        grayLineView.backgroundColor = #colorLiteral(red: 0.9750739932, green: 0.9750967622, blue: 0.9750844836, alpha: 1)
        addSubview(grayLineView)

        colorLineView.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        addSubview(colorLineView)

        constrain(textField, grayLineView, colorLineView) { (textField, grayLineView, colorLineView) in
            textField.top == textField.superview!.top
            textField.left == textField.superview!.left
            textField.right == textField.superview!.right
            textField.height == 44.0

            grayLineView.top == textField.bottom
            grayLineView.left == textField.left
            grayLineView.right == textField.right
            grayLineView.height == 1.0

            colorLineView.top == grayLineView.top
            colorLineView.height == grayLineView.height
            colorLineView.bottom == colorLineView.superview!.bottom
        }

        let colorLineInvisibleGroup = constrain(colorLineView) { (colorLineView) in
            colorLineView.centerX == colorLineView.superview!.centerX
            colorLineView.width == 0.0
        }
        colorLineInvisibleGroup.active = true

        let colorLineVisibleGroup = constrain(colorLineView) { (colorLineView) in
            colorLineView.left == colorLineView.superview!.left
            colorLineView.right == colorLineView.superview!.right
        }
        colorLineVisibleGroup.active = false

        let active = textField.rx.controlEvent([.editingDidBegin]).map({ _ in true })
        let inactive = textField.rx.controlEvent([.editingDidEnd]).map({ _ in false })
        Observable.of(active, inactive).merge().bind { [weak self] (active) in
            self?.layoutIfNeeded()
            if active {
                colorLineInvisibleGroup.active = false
                colorLineVisibleGroup.active = true
            } else {
                colorLineVisibleGroup.active = false
                colorLineInvisibleGroup.active = true
            }

            UIView.animate(withDuration: 0.4, animations: {
                self?.layoutIfNeeded()
            })
        }.disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
