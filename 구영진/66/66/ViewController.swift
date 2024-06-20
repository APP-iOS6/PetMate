//
//  ViewController.swift
//  66
//
//  Created by Mac on 6/17/24.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    @IBOutlet weak var valueLabel: UILabel!
    
    
    @IBOutlet weak var inputfield: UITextField!
    
    @IBAction func showValue(_ sender: Any) {
        let name = inputfield.text!
        valueLabel.text = "Hello, \(name)"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

