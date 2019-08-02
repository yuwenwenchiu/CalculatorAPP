//
//  ViewController.swift
//  Calculator
//
//  Created by Yuwen Chiu on 2019/7/30.
//  Copyright © 2019 YuwenChiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 記錄運算符號
    var operatingSign: String = ""
    // 紀錄目前的數字
    var currentNumber: Double = 0
    // 紀錄上一個數字
    var previousNumber: Double = 0
    // 紀錄是否計算中
    var isCalculating: Bool = false
    // 紀錄是否為新的運算
    var startNew: Bool = true

    // 顯示標籤
    @IBOutlet weak var resultLabel: UILabel!
    
    // 列舉運算的種類
    enum OperationType {
        case add
        case subtract
        case multiply
        case divide
        case none
    }
    // 記錄目前是什麼運算
    var operation: OperationType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // 點擊數字鍵會觸發的行為
    @IBAction func numbers(_ sender: UIButton) {
        // 紀錄使用者輸入的數字
        let inputNumber = sender.tag
        
        // 確認顯示標籤不為空值
        if resultLabel.text != nil {
            // 如果是新的運算
            if startNew == true {
                // 使用者輸入的數字存入顯示標籤(第一位數)
                resultLabel.text = "\(inputNumber)"
                startNew = false
            } else {
                // 如果不是新的運算，但符合下列其中一個條件，將使用者輸入的數字存入顯示標籤(第 1 位數)
                if resultLabel.text == "0" || operatingSign == "÷" || operatingSign == "x" ||
                    operatingSign == "-" || operatingSign == "+" {
                    resultLabel.text = "\(inputNumber)"
                    operatingSign = ""
                // 如果不是新的運算，也不符和上列任一個條件，將使用者輸入的數字接在目前顯示標籤的後面(第 2、3、4...位數)
                } else {
                    resultLabel.text = resultLabel.text! + "\(inputNumber)"
                }
            }
            // 如果顯示標籤不為空值，將值轉型為 Double 存入 currentNumber
            // 如果顯示標籤為空值，將 0 存入 currentNumber
            currentNumber = Double(resultLabel.text!) ?? 0
        }
    }
    
    // 點擊 ⬅︎ 會觸發的行為
    @IBAction func deleteLast(_ sender: UIButton) {
        // 如果顯示標籤只有 1 位數，將顯示標籤設為 0
        if resultLabel.text?.count == 1 {
            resultLabel.text = "0"
        // 如果顯示標籤不只 1 位數，將顯示標籤最後一個數字去除，並轉型為 Double 存入 currentNumber
        // 再將 currentNumber 傳入 okAnswerString 函式確認是否符合顯示條件
        } else {
            currentNumber = Double(resultLabel.text!.dropLast())!
            okAnswerString(from: currentNumber)
        }
        isCalculating = true
        startNew = false
    }
    
    // 點擊 C 會觸發的行為
    @IBAction func clear(_ sender: UIButton) {
        // 將所有變數設回初始值
        resultLabel.text = "0"
        operatingSign = ""
        currentNumber = 0
        previousNumber = 0
        isCalculating = false
        startNew = true
    }
    
    // 點擊 +/- 會觸發的行為
    @IBAction func negativeSwitch(_ sender: UIButton) {
        // 將顯示標籤轉型為 Double 乘以 -1 再存入 currentNumber
        // 再將 currentNumber 傳入 okAnswerString 函式確認是否符合顯示條件
        currentNumber = Double(resultLabel.text!)! * -1
        okAnswerString(from: currentNumber)
        isCalculating = true
        startNew = false
    }
    
    // 點擊 % 會觸發的行為
    @IBAction func percentage(_ sender: UIButton) {
        // 將顯示標籤轉型為 Double 除以 100 再存入 currentNumber
        // 再將 currentNumber 傳入 okAnswerString 函式確認是否符合顯示條件
        currentNumber = Double(resultLabel.text!)! / 100
        okAnswerString(from: currentNumber)
        isCalculating = true
        startNew = false
    }
    
    // 點擊 ÷ 會觸發的行為
    @IBAction func divide(_ sender: UIButton) {
        // 如果 previousNumber 不等於 0 就呼叫 nowAnswer 計算目前的結果
        if previousNumber != 0 {
            nowAnswer()
        }
        
        operatingSign = "÷"
        previousNumber = currentNumber
        isCalculating = true
        startNew = false
        operation = .divide
    }
    
    // 點擊 x 會觸發的行為
    @IBAction func multiply(_ sender: UIButton) {
        // 如果 previousNumber 不等於 0 就呼叫 nowAnswer 計算目前的結果
        if previousNumber != 0 {
            nowAnswer()
        }
        
        operatingSign = "x"
        previousNumber = currentNumber
        isCalculating = true
        startNew = false
        operation = .multiply
    }
    
    // 點擊 - 會觸發的行為
    @IBAction func subtract(_ sender: UIButton) {
        // 如果 previousNumber 不等於 0 就呼叫 nowAnswer 計算目前的結果
        if previousNumber != 0 {
            nowAnswer()
        }
        
        operatingSign = "-"
        previousNumber = currentNumber
        isCalculating = true
        startNew = false
        operation = .subtract
    }
    
    // 點擊 + 會觸發的行為
    @IBAction func add(_ sender: UIButton) {
        // 如果 previousNumber 不等於 0 就呼叫 nowAnswer 計算目前的結果
        if previousNumber != 0 {
            nowAnswer()
        }
        
        operatingSign = "+"
        previousNumber = currentNumber
        isCalculating = true
        startNew = false
        operation = .add
    }
    
    // 點擊 = 會觸發的行為
    @IBAction func giveAnswer(_ sender: UIButton) {
        // 如果正在運算中，判斷目前是什麼運算並得出結果檢查是否符合顯示條件
        if isCalculating == true {
            switch operation {
                case .add:
                    currentNumber = previousNumber + currentNumber
                    okAnswerString(from: currentNumber)
                case .subtract:
                    currentNumber = previousNumber - currentNumber
                    okAnswerString(from: currentNumber)
                case .multiply:
                    currentNumber = previousNumber * currentNumber
                    okAnswerString(from: currentNumber)
                case .divide:
                    currentNumber = previousNumber / currentNumber
                    okAnswerString(from: currentNumber)
                case .none:
                    resultLabel.text = ""
            }
            isCalculating = false
            startNew = true
        }
        previousNumber = 0
    }
    
    // 檢查運算結果是否符合顯示條件
    func okAnswerString(from number: Double) {
        // 紀錄符合顯示條件的字串
        var okText: String
        
        // 如果傳入的數字無條件捨去之後和原來相等，表示數字為整數，將數字轉型為 Int 再變成字串顯示
        if floor(number) == number {
            okText = "\(Int(number))"
        // 如果傳入的數字無條件捨去之後和原來不相等，表示數字為小數，數字保留為 Double 再變成字串顯示
        } else {
            okText = "\(number)"
        }
        
        // 字串最多只顯示 7 位數
        if okText.count >= 7 {
            okText = String(okText.prefix(7))
        }
        resultLabel.text = okText
    }
    
    func nowAnswer() {
        switch operation {
        case .add:
            currentNumber = previousNumber + currentNumber
            okAnswerString(from: currentNumber)
        case .subtract:
            currentNumber = previousNumber - currentNumber
            okAnswerString(from: currentNumber)
        case .multiply:
            currentNumber = previousNumber * currentNumber
            okAnswerString(from: currentNumber)
        case .divide:
            currentNumber = previousNumber / currentNumber
            okAnswerString(from: currentNumber)
        case .none:
            resultLabel.text = ""
        }
    }
    
}

