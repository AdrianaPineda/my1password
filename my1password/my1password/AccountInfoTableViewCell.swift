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

        let subviews = self.subviews
        for view in subviews {

            let subviews2 = view.subviews

            for view2 in subviews2 {
                if let textField: UITextField = view2 as? UITextField {
                    UIPasteboard.generalPasteboard().string = textField.text
                    return
                }
            }
        }

    }

    func reveal(sender: AnyObject) {

        let subviews = self.subviews
        for view in subviews {
            let subviews2 = view.subviews

            for view2 in subviews2 {
                if let textField: UITextField = view2 as? UITextField {
                    textField.secureTextEntry = false
                    return
                }
            }
        }
    }

    func conceal(sender: AnyObject) {

        let subviews = self.subviews
        for view in subviews {
            let subviews2 = view.subviews

            for view2 in subviews2 {
                if let textField: UITextField = view2 as? UITextField {
                    textField.secureTextEntry = true
                    return
                }
            }
        }
    }
}
