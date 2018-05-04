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
    
//    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
    }
}

extension ViewController: UITableViewDelegate {
    fileprivate func prepareTableView() {
        let items = Observable.just(
            (0..<20).map { "cell: \($0)" }
        )
        print("🤮 items: \(items)")
        
        // cell for row at indexpath
        items
            .bind(to: tableView.rx.items(
                cellIdentifier: "Cell",
                cellType: UITableViewCell.self
                )
            ) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
        
        // did select row
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { value in
                DefaultWireframe.presentAlert("Tapped \(value)")
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                DefaultWireframe.presentAlert("Tapped Detail @ \(indexPath.section),\(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }
}


