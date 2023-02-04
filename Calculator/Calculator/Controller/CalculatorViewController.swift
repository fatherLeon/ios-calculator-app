//  Calculator - ViewController.swift
//  Created by 레옹아범.


import UIKit

final class CalculatorViewController: UIViewController {
    
    private var inputs: String = CalculatorInitial.initValue
    private var currentOperand: String = CalculatorInitial.initValue
    private var currentOperator: String = CalculatorInitial.initValue
    private var isCalculated: Bool = false
    private var isFractional: Bool {
        self.currentOperand.contains(CalculatorInitial.dotSymbol)
    }
    private var isFirstInput: Bool {
        return self.formulaStackView.subviews.isEmpty
    }
    
    @IBOutlet private weak var formulaScrollView: UIScrollView!
    @IBOutlet private weak var formulaStackView: UIStackView!
    @IBOutlet private weak var currentOperandLabel: UILabel!
    @IBOutlet private weak var currentOperatorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentOperatorLabel.text = CalculatorInitial.initValue
        self.currentOperandLabel.text = CalculatorInitial.initLabel
    }
    
    @IBAction private func didTapNumberButton(sender: UIButton) {
        guard let numberButtonTitle = sender.currentTitle else { return }
        
        self.currentOperand += numberButtonTitle
        
        updateCurrentNumberLabel(self.currentOperand)
    }
    
    @IBAction private func didTapZeroButton(sender: UIButton) {
        guard let zeroButtonTitle = sender.currentTitle else { return }
        
        if self.isFractional == false {
            self.currentOperand += zeroButtonTitle
            updateCurrentNumberLabel(self.currentOperand)
        } else {
            self.currentOperand += zeroButtonTitle
            self.currentOperandLabel.text = self.currentOperand
        }
    }
    
    @IBAction private func didTapDotButton(sender: UIButton) {
        guard self.currentOperand.contains(CalculatorInitial.dotSymbol) == false else { return }
        
        if self.currentOperand == CalculatorInitial.initValue {
            self.currentOperand = "0."
            self.currentOperandLabel.text = self.currentOperand
        } else {
            let formattedOperand = formattingNumber(self.currentOperand)
            self.currentOperand = formattedOperand + CalculatorInitial.dotSymbol
        }
        
        self.currentOperandLabel.text = self.currentOperand
    }
    
    @IBAction private func didTapOperatorButton(sender: UIButton) {
        guard let operatorButtonTitle = sender.currentTitle else { return }
        
        if self.currentOperandLabel.text != CalculatorInitial.initLabel {
            let currentOperandValue = formattingNumber(self.currentOperand)
            let currentOperatorValue = self.currentOperator
            
            addStackView(number: currentOperandValue, operatorType: currentOperatorValue)
            
            self.inputs += "\(self.currentOperator) \(self.currentOperand) "
            
            resetOperand()
            
            self.currentOperator = operatorButtonTitle
            self.currentOperatorLabel.text = self.currentOperator
        } else if isFirstInput == false {
            self.currentOperator = operatorButtonTitle
            self.currentOperatorLabel.text = self.currentOperator
        }
        
        self.isCalculated = false
    }
    
    @IBAction private func didTapReverseOperandButton(sender: UIButton) {
        guard let firstValue = self.currentOperand.first else { return }
        
        if firstValue.isNumber {
            self.currentOperand = CalculatorInitial.negativeSymbol + self.currentOperand
        } else if String(firstValue) == CalculatorInitial.negativeSymbol {
            self.currentOperand.removeFirst()
        }
        
        updateCurrentNumberLabel(self.currentOperand)
    }
    
    @IBAction private func didTapClearButton(sender: UIButton) {
        self.currentOperand = CalculatorInitial.initValue
        self.currentOperandLabel.text = CalculatorInitial.initLabel
    }
    
    @IBAction private func didTapAllClearButton(sender: UIButton) {
        resetAll()
        self.removeAllStackView()
    }
    
    @IBAction private func didTapCalculateButton(sender: UIButton) {
        if self.isCalculated == false && self.currentOperand.isEmpty == false {
            addStackView(number: self.currentOperandLabel.text, operatorType: self.currentOperator)
            
            self.inputs += "\(self.currentOperator) \(self.currentOperand) "
            
            var formula = ExpressionParser.parse(from: inputs)
            let result = formula.result()
            
            if result.isNaN {
                resetAll()
                self.currentOperandLabel.text = CalculatorInitial.notNumberSymbol
                self.isCalculated = false
                self.isCalculated = true
                
                return
            }
            
            let formattedOperand = formattingNumber("\(result)")
            
            resetAll()
            self.currentOperand = "\(formattedOperand)"
            self.currentOperandLabel.text = formattedOperand
            self.isCalculated = true
        }
    }
    
    private func updateCurrentNumberLabel(_ value: String) {
        let formattedOperand = formattingNumber(value)
        
        self.currentOperandLabel.text = formattedOperand
    }
    
    private func formattingNumber(_ value: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 1
        formatter.maximumSignificantDigits = 20
        
        guard let formattedNumber = formatter.number(from: value),
              let formattedOperand = formatter.string(from: formattedNumber) else { return "0" }
        
        return formattedOperand
    }
    
    private func resetOperand() {
        self.currentOperand.removeAll()
        self.currentOperandLabel.text = CalculatorInitial.initLabel
    }
    
    private func resetOperator() {
        self.currentOperator.removeAll()
        self.currentOperatorLabel.text?.removeAll()
    }
    
    private func resetInputs() {
        self.inputs.removeAll()
    }
    
    private func resetAll() {
        resetOperand()
        resetOperator()
        resetInputs()
    }
}

// MARK: - 뷰 관련 메소드(뷰 생성, 뷰 삭제, 뷰 스크롤)
extension CalculatorViewController {
    private func addStackView(number: String?, operatorType: String?) {
        guard let operandValue = number,
              let operatorValue = operatorType else { return }
        
        let formulaLabel = UILabel()
        formulaLabel.font = .preferredFont(forTextStyle: .title3)
        formulaLabel.text = "\(operatorValue) \(operandValue)"
        formulaLabel.textColor = .white

        self.formulaStackView.addArrangedSubview(formulaLabel)
        
        scrollToBottom()
    }

    private func removeAllStackView() {
        let allSubViewsInStackVIew = self.formulaStackView.arrangedSubviews
        
        allSubViewsInStackVIew.forEach { label in
            self.formulaStackView.removeArrangedSubview(label)
            label.removeFromSuperview()
        }
    }

    private func scrollToBottom() {
        if self.formulaScrollView.contentSize.height < self.formulaScrollView.bounds.size.height { return }
        self.formulaScrollView.layoutIfNeeded()
        self.formulaStackView.layoutIfNeeded()
        let bottomOffset = CGPoint(x: 0, y: self.formulaScrollView.contentSize.height - self.formulaScrollView.bounds.size.height)
        self.formulaScrollView.setContentOffset(bottomOffset, animated: true)
    }
}
