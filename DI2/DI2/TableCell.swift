//
//  TableCell.swift
//  DI2
//
//  Created by 方品中 on 2023/5/7.
//
import UIKit

protocol TableCellDelegate {
    func doDelete(index: Int)
}

class TableCell: UITableViewCell {
    var delegate: TableCellDelegate?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBAction func doDelete(_ sender: UIButton) {
        self.doDelete!(sender.tag)
        
        self.delegate?.doDelete(index: sender.tag)
    }
    
    var doDelete: ((Int) -> ())?
}
