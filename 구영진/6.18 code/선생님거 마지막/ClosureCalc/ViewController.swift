//
//  ViewController.swift
//  ClosureCalc
//
//  Created by Jongwook Park on 6/18/24.
//

import UIKit


class ViewController: UIViewController {
    
    var number1: Int = 0
    var number2: Int = 0
    var result: Int = 0
    
    @IBOutlet weak var firstNumberLabel: UILabel!
    @IBOutlet weak var secondNumberLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    func updateNumbers() {
        firstNumberLabel.text = "\(number1)"
        secondNumberLabel.text = "\(number2)"
        resultLabel.text = "\(result)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNumbers()
    }
    
    
    @IBAction func decreseFirstNumber(_ sender: Any) {
        number1 -= 1
        updateNumbers()
    }
    
    @IBAction func increaseFirstNumber(_ sender: Any) {
        number1 += 1
        updateNumbers()
    }
    
    @IBAction func decreaseSecondNumber(_ sender: Any) {
        number2 -= 1
        updateNumbers()
    }
    
    @IBAction func increaseSecondNumber(_ sender: Any) {
        number2 += 1
        updateNumbers()
    }
    
    @IBAction func addTwoNumbers(_ sender: Any) {
        
        let add = { (number1: Int, number2: Int) -> Int in
            return number1 + number2
        }
        
        result = add(number1, number2)
        
        updateNumbers()
    }
    @IBAction func SUB(_ sender: Any) {
        let subtract = { (num1: Int, num2: Int) -> Int in
            return num1 - num2
        }
        result = subtract(number1, number2)
        updateNumbers()
    }
    
    @IBAction func MUL(_ sender: Any) {
        let multiply = { (num1: Int, num2: Int) -> Int in
            return num1 * num2
        }
        result = multiply(number1, number2)
        updateNumbers()
    }
    
    @IBAction func DIV(_ sender: Any) {
        let divide = { (num1: Int, num2: Int) -> Int in
            // Avoid division by zero
            return num2 != 0 ? num1 / num2 : 0
        }
        result = divide(number1, number2)
        updateNumbers()
    }
}
