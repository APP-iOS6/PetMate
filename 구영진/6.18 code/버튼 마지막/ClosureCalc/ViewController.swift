//
//  ViewController.swift
//  ClosureCalc
//
//  Created by 김수민 on 6/18/24.
//

import UIKit

class ViewController: UIViewController {
    
    var number1 :  Int = 0
    var number2 :  Int = 0
    var result :  Int = 0

    @IBOutlet weak var FirstNumberLabel: UILabel!
    @IBOutlet weak var SecondNumberLabel: UILabel!
    @IBOutlet weak var ResultLabel: UILabel!
    
    func updateNumbers() {
        FirstNumberLabel.text = "\(number1)"
        SecondNumberLabel.text = "\(number2)"
        ResultLabel.text = "\(result)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNumbers()
    }
    
    @IBAction func subFirstNumber(_ sender: Any) {
        number1 -= 1
        FirstNumberLabel.text = "\(number1)"
    }
    
    
    @IBAction func addFirstNumber(_ sender: Any) {
        number1 += 1
        FirstNumberLabel.text = "\(number1)"
    }
    
    
    
    @IBAction func subSecondNumber(_ sender: Any) {
        number2 -= 1
        SecondNumberLabel.text = "\(number2)"
    }
    
    
    @IBAction func addSecondNumber(_ sender: Any) {
        number2 += 1
        SecondNumberLabel.text = "\(number2)"
    }
    
    
    @IBAction func addTwoNumber(_ sender: Any) {
        let add = { (num1 :  Int, num2 : Int) -> Int in
            return num1 + num2
        }
        
        result = add(number1, number2)
        
        updateNumbers()
    }
    
    
    @IBAction func subTwoNumber(_ sender: Any) {
        let sub = { (num1 :  Int, num2 : Int) -> Int in
            return num1 - num2
        }
        
        result = sub(number1, number2)
        
        updateNumbers()
    }
    
    @IBAction func mulTwoNumber(_ sender: Any) {
        let mul = { (num1 :  Int, num2 : Int) -> Int in
            return num1 * num2
        }
        
        result = mul(number1, number2)
        
        updateNumbers()
    }
    
    @IBAction func divTwoNumber(_ sender: Any) {
        let div = { (num1 :  Int, num2 : Int) -> Float in
            return Float(num1) / Float(num2)
        }
        
        if number2 == 0{
            ResultLabel.text = "INF"
        }
        else {
            ResultLabel.text = "\(div(number1, number2))"
        }
    }
    
    
    @IBAction func resetButton(_ sender: Any) {
        number1 = 0
        number2 = 0
        result = 0
        
        updateNumbers()
    }
    
}

