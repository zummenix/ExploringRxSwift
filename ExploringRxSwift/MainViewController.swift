//
//  MainViewController.swift
//  ExploringRxSwift
//
//  Created by Aleksey Kuznetsov on 12/08/2017.
//  Copyright © 2017 Aleksey Kuznetsov. All rights reserved.
//

import UIKit

import Cartography
import RxSwift
import RxCocoa

class MainViewController: UIViewController {

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let button = UIButton(type: .system)
        button.setTitle("Show Alert", for: .normal)
        view.addSubview(button)

        let textField1 = FancyTextField(frame: .zero)
        textField1.fieldName = "First Name"
        view.addSubview(textField1)

        let textField2 = FancyTextField(frame: .zero)
        textField2.fieldName = "Second Name"
        view.addSubview(textField2)

        constrain(button, textField1, textField2) { (button, textField1, textField2) in
            textField1.top == textField1.superview!.top + 60.0
            textField1.left == textField1.superview!.left + 20.0
            textField1.right == textField1.superview!.right - 20.0

            textField2.top == textField1.bottom + 20.0
            textField2.left == textField1.left
            textField2.right == textField1.right

            button.centerX == button.superview!.centerX
            button.centerY == button.superview!.centerY
            button.width == 200.0
            button.height == 44.0
        }

        button.rx.tap.subscribe { [weak self] _ in
            let alert = UIAlertController(title: "", message: "Simple message", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
}

