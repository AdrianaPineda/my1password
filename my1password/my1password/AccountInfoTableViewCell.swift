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
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func copy(sender: AnyObject?) {
        //
        let pasteboard = UIPasteboard.generalPasteboard()
        pasteboard.string = "axs"
    }

    func reveal(sender: AnyObject) {
        //
    }
}
