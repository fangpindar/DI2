//
//  ViewController.swift
//  DI2
//
//  Created by 方品中 on 2023/5/7.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var array = ["2", "3", "4", "5"]
    
    @IBAction func addButtonClick(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showAdd", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            // 1. Delegate
            destination.delegate = self
            
            // 2. Closure
            //            destination.doUpdate = { [weak self] cellInfo in
            //                if let index = cellInfo.index,
            //                   let text = cellInfo.text {
            //                    self?.array[index] = text
            //                    self?.tableView.reloadData()
            //                }
            //            }
            //
            //            destination.doInsert = { [weak self] text in
            //                self?.array.append(text)
            //                self?.tableView.reloadData()
            //            }
            
            if let cellInfo = sender as? CellInfo {
                destination.cellInfo = cellInfo
            }
        }
    }
}

extension ViewController: TableCellDelegate {
    func doDelete(index: Int) {
        self.array.remove(at: index)
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? TableCell else { return UITableViewCell() }
        
        cell.label.text = String(array[indexPath.row])
        cell.button.tag = indexPath.row
        
        // 1. Closure
        cell.doDelete = { [weak self] index in
             self?.array.remove(at: index)
             self?.tableView.reloadData()
        }
        
        // 2. Target-Action
//         cell.button.addTarget(self, action: #selector(doDelete), for: .touchUpInside)
        
        // 3. Delegate
//        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TableCell else { return }
        
        let cellInfo = CellInfo(
            text: cell.label.text,
            index: indexPath.row
        )
        
        performSegue(withIdentifier: "showAdd", sender: cellInfo)
    }
    
    @objc func doDelete(_ sender: UIButton) {
        self.array.remove(at: sender.tag)
        self.tableView.reloadData()
    }
}

extension ViewController: DetailViewControllerDelegate {
    func doUpdate(cellInfo: CellInfo) {
        if let index = cellInfo.index,
           let text = cellInfo.text {
            self.array[index] = text
            self.tableView.reloadData()
        }
    }
    
    func doInsert(text: String) {
        self.array.append(text)
        self.tableView.reloadData()
    }
}
