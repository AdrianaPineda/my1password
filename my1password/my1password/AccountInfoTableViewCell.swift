//
//  AccountInfoTableViewCell.swift
//  my1password
//
//  Created by Adriana Pineda on 3/26/16.
//  Copyright © 2016 Adriana Pineda. All rights reserved.
//

import UIKit

class AccountInfoTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func copy(sender: AnyObject?) {
        UIPasteboard.generalPasteboard().string = "TESTING"
    }

    func reveal(sender: AnyObject) {
        //
    }
}
