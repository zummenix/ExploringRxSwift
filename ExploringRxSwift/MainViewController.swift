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

        constrain(button) { (button) in
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

