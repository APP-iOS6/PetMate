import Foundation

class Calc{
    var number1 : Int = 0
    var number2 : Int = 0
    
    func add(){
        let result: Int = number1 + number2
        print("add: \(result)")
        return result
    }
}

var myCalc: Calc = Calc()

myCalc.number1 = 15
myCalc.number2 = 4
print("number1 : \(myCalc.number1)")
print("number2 : \(myCalc.number2)")

let addnumber:Int = myCalc.add()
print("add: \(addnumber)")
