//
//  SelectTableCellControllerProtocol.swift
//  Carmunication
//
//  Created by 김동현 on 2023/10/12.
//

import UIKit

protocol SelectTableCellController {
    static func registerCell(on tableView: UITableView)
    func cellFromTableView(_ tableView: UITableView, forIndexPath indexPath: IndexPath) -> UITableViewCell
    func didSelectCell()
}

// cell 이 어떤 셀인지
protocol ListItem {
    var isDefalutItem: Bool {get}
    var isSelectAddressItem: Bool {get}
}
