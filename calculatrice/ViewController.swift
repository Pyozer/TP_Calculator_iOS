//
//  ViewController.swift
//  calculatrice
//
//  Created by Jean-Charles Moussé on 13/02/2019.
//  Copyright © 2019 Jean-Charles Moussé. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var numbers: [UIButton]!
    @IBOutlet var operators: [UIButton]!
    @IBOutlet weak var reset: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tempResult: UILabel!
    
    var displayed: String = ""
    var tempResultText: String = ""
    var isLastIsOperator: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updateText() {
        label.text = displayed
        tempResult.text = tempResultText
    }
    
    private func calcule() -> String {
        if displayed == "0"{
            return displayed
        }
        
        let formatted = displayed.replacingOccurrences(of: "x", with: "*", options: .literal, range: nil)
            .replacingOccurrences(of: "−", with: "-", options: .literal, range: nil)
            .replacingOccurrences(of: "÷", with: "/", options: .literal, range: nil)
        
        let mathExpression = NSExpression(format: formatted)
        let mathValue = mathExpression.expressionValue(with: nil, context: nil) as? Double ?? 0.0
        
        let numFormatter = NumberFormatter()
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 6
        
        return numFormatter.string(from: NSNumber(value: mathValue)) ?? "0"
    }
    
    
    @IBAction func onNumberPress(_ sender: UIButton) {
        let buttonValue = sender.titleLabel?.text ?? ""
        if String(displayed.prefix(1)) == "0" {
            displayed = String(displayed.dropFirst())
        }
        displayed += buttonValue
        tempResultText = calcule()
        updateText()
        isLastIsOperator = false
    }
    
    @IBAction func onReset(_ sender: UIButton) {
        displayed = "0"
        tempResultText = ""
        updateText()
    }
    
    
    
    @IBAction func onOperator(_ sender: UIButton) {
        let operatorValue = sender.titleLabel?.text ?? ""
        if operatorValue == "=" {
            displayed = calcule()
            tempResultText = ""
            updateText()
            isLastIsOperator = false
        } else if !isLastIsOperator {
            let operatorValue = sender.titleLabel?.text ?? ""
            displayed += operatorValue
            updateText()
            isLastIsOperator = true
        }
    }
}
