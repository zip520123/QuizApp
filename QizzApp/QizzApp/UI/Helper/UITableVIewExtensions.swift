//
//  UITableVIewExtensions.swift
//  QizzApp
//
//  Created by zip520123 on 04/12/2020.
//  Copyright © 2020 zip520123. All rights reserved.
//

import UIKit

extension UITableView {
    func register(_ type: UITableViewCell.Type) {
        let className = String(describing: type)
        register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    func dequeueReusableCell<T>(_ type: T.Type) -> T?{
        let className = String(describing: type)
        return dequeueReusableCell(withIdentifier: className) as? T
    }
}
