//
//  SettingsViewController.swift
//  ExploringRxSwift
//
//  Created by Aleksey Kuznetsov on 26/08/2017.
//  Copyright © 2017 Aleksey Kuznetsov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {

    class ViewModel {
        let bag: DisposeBag
        let items: Variable<[String]>
        let onDone: PublishSubject<Void>

        init(bag: DisposeBag, items: [String], onDone: PublishSubject<Void>) {
            self.bag = bag
            self.items = Variable(items)
            self.onDone = onDone
        }

        var item: AnyObserver<String> {
            return AnyObserver(eventHandler: { [weak self] (event) in
                switch event {
                case .next(let item):
                    self?.items.value.insert(item, at: 0)
                default:
                    break
                }
            })
        }
    }

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SettingsCell.self, forCellReuseIdentifier: String(describing: SettingsCell.self))

        navigationController?.setToolbarHidden(false, animated: true)

        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        doneItem.rx.tap.asDriver().drive(viewModel.onDone).disposed(by: viewModel.bag)
        navigationItem.rightBarButtonItem = doneItem

        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        addItem.rx.tap.asDriver().map({ _ in UUID().uuidString }).drive(viewModel.item).disposed(by: viewModel.bag)

        toolbarItems = [spaceItem(), addItem, spaceItem()]

        let itemsDriver = viewModel.items.asDriver()

        itemsDriver.drive(tableView.rx.items(cellIdentifier: String(describing: SettingsCell.self), cellType: SettingsCell.self)) { (row, element, cell) in
            cell.textLabel?.text = element
        }.disposed(by: viewModel.bag)

        itemsDriver.map({ String(describing: $0.count) }).drive(rx.title).disposed(by: viewModel.bag)
    }
}

private func spaceItem() -> UIBarButtonItem {
    return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
}
