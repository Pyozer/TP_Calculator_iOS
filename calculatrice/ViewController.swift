//
//  ViewController.swift
//  calculatrice
//
//  Created by Jean-Charles Moussé on 13/02/2019.
//  Copyright © 2019 Jean-Charles Moussé. All rights reserved.
//

import UIKit

extension String {
    func replace(_ of: String, _ with: String) -> String {
        return self.replacingOccurrences(of: of, with: with, options: .literal, range: nil)
    }
}

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
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longPress.minimumPressDuration = 0.65
        reset.addGestureRecognizer(longPress)
    }
    
    private func updateText() {
        label.text = displayed
        tempResult.text = tempResultText
    }
    
    private func calcule() -> String {
        if displayed == "" || displayed == "0" {
            return displayed
        }
        if displayed == "." {
            return "0"
        }
        
        var formatted = displayed.replace("x", "*").replace("−", "-").replace("÷", "/")
            .replace("./", "/").replace(".*", "*").replace(".-", "-").replace(".+", "+")
        
        if String(formatted.suffix(1)) == "." {
            formatted = String(formatted.dropLast())
        }
        
        let mathExpression = NSExpression(format: formatted)
        let mathValue = mathExpression.expressionValue(with: nil, context: nil) as? Double ?? 0.0
        
        let numFormatter = NumberFormatter()
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 6
        
        var result = numFormatter.string(from: NSNumber(value: mathValue)) ?? "0"
        if String(result.first ?? Character("")) == "." {
            result = "0" + result
        }
        return result
    }
    
    @IBAction func onNumberPress(_ sender: UIButton) {
        let buttonValue = sender.titleLabel?.text ?? ""
        displayed += buttonValue
        if buttonValue != "." {
            tempResultText = calcule()
        }
        updateText()
        isLastIsOperator = false
    }
    
    @IBAction func onOperator(_ sender: UIButton) {
        let operatorValue = sender.titleLabel?.text ?? ""
        if operatorValue == "=" {
            if isLastIsOperator {
                displayed = String(displayed.dropLast())
            }
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
    
    @IBAction func onDelete(_ sender: UIButton) {
        displayed = String(displayed.dropLast())
        updateText()
    }
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            displayed = ""
            tempResultText = ""
            updateText()
        }
    }
}
