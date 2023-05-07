//
//  DetailViewController.swift
//  DI2
//
//  Created by 方品中 on 2023/5/7.
//

import UIKit

struct CellInfo {
    var text: String?
    var index: Int?
}

protocol DetailViewControllerDelegate {
    func doUpdate(cellInfo: CellInfo)
    func doInsert(text: String)
}

class DetailViewController: UIViewController {
    // 1. Delegate
    var delegate: DetailViewControllerDelegate?
    
    // 2. Closure
    var doUpdate: ((CellInfo) -> ())?
    var doInsert: ((String) -> ())?

    var cellInfo: CellInfo? {
        didSet {
            if cellInfo != nil {
                self.textField.text = cellInfo?.text
            }
        }
    }
    
    var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        button.addTarget(self, action: #selector(buttonTapped), for: UIControl.Event.touchUpInside)
    }
    
    @objc func buttonTapped(sender: UIButton) {
        if let text = textField.text {
            if var _cellInfo = self.cellInfo {
                _cellInfo.text = text
                
                // 1. delegate
                self.delegate?.doUpdate(cellInfo:_cellInfo)
                
                // 2. Closure
                self.doUpdate?(_cellInfo)
                
                self.navigationController?.popViewController(animated: true)
            } else {
                // 1. delegate
                self.delegate?.doInsert(text: text)

                // 2. Closure
                self.doInsert?(text)

                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func setupUI() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(textField)
        self.view.addSubview(button)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/3),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: 20),
            button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/3),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
