//
//  ViewController.swift
//  ReactiveSandbox
//
//  Created by Masakazu Sano on 2018/05/02.
//  Copyright © 2018年 Masakazu Sano. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: table view (without section)

//final class ViewController: UIViewController {
//    @IBOutlet weak var tableView: UITableView!
//
//    let disposeBag = DisposeBag()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        prepareTableView()
//    }
//}
//
//extension ViewController: UITableViewDelegate {
//    fileprivate func prepareTableView() {
//        let items = Observable.just(
//            (0..<20).map { "cell: \($0)" }
//        )
//        print("🤮 items: \(items)")
//
//        // cell for row at indexpath
//        items
//            .bind(to: tableView.rx.items(
//                cellIdentifier: "Cell",
//                cellType: UITableViewCell.self
//            )
//        ) { (row, element, cell) in
//            cell.textLabel?.text = "\(element) @ row \(row)"
//        }
//        .disposed(by: disposeBag)
//
//        // did select row
//        tableView.rx
//            .modelSelected(String.self)
//            .subscribe(onNext: { value in
//                DefaultWireframe.presentAlert("Tapped \(value)")
//            })
//            .disposed(by: disposeBag)
//
//        tableView.rx
//            .itemAccessoryButtonTapped
//            .subscribe(onNext: { indexPath in
//                DefaultWireframe.presentAlert("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
//            })
//            .disposed(by: disposeBag)
//    }
//}

// MARK: table view (with section)

final class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let dataSource = DataSource()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
    }
}

extension ViewController: UITableViewDelegate {
    fileprivate func prepareTableView() {
        let items: Observable<[Item]> = Observable.just(
            (0..<20).map { Item(name: "no.\($0)") }
        )

        // bind datasource
        items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // did select row
        tableView.rx
            .modelSelected(Item.self)
            .subscribe(onNext: { item in
                DefaultWireframe.presentAlert("Tapped \(item.name)")
            })
            .disposed(by: disposeBag)

    }
}

final class DataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {
    typealias Element = [Item]
    var _itemModels: [Item] = []
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
        ) -> Int {
        return _itemModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath
        )
        let element = _itemModels[indexPath.row]
        cell.textLabel?.text = element.name
        return cell
    }
    
    // MARK: RxTableViewDataSourceType
    func tableView(
        _ tableView: UITableView,
        observedEvent: Event<[Item]>
        ) {
        Binder(self) { dataSource, element in
            dataSource._itemModels = element
            tableView.reloadData()
        }
        .on(observedEvent)
    }
}

extension DataSource: SectionedViewDataSourceType {
    // MARK: SectionedViewDataSourceType
    // NOTE: didSelectRow として使用
    func model(at indexPath: IndexPath) throws -> Any {
        return _itemModels[indexPath.row]
    }
}

struct Item {
    var name: String
}
