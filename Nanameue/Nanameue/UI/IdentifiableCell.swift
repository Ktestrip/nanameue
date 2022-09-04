//
//  IdentifiableCell.swift
//  Nanameue
//
//  Created by Frqnck  on 04/09/2022.
//

import UIKit

protocol IdentifiableCell: UITableViewCell {
    static var identifier: String { get }
    static var nib: UINib { get }
}
