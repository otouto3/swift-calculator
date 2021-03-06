//
//  ViewController.swift
//  CalculaotrApp
//
//  Created by ごつ on 2021/10/02.
//

import UIKit

class ViewController: UIViewController {
    
    enum CalculateStatus {
        case none, plus, minus, multiplication, division
    }

    var calculateStatus: CalculateStatus = .none
    var firstNumber = ""
    var secondNumber = ""
    
    let numbers = [
        ["C", "%", "$", "÷"],
        ["7", "8", "9", "*"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="],
    ]
    let cellId = "cellId"

    @IBOutlet weak var calculatorCollectionView: UICollectionView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var calculatorHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        // storyboardでつけた名前
        calculatorCollectionView.delegate = self
        calculatorCollectionView.dataSource = self
        calculatorCollectionView.register(CalculatorViewCell.self, forCellWithReuseIdentifier: cellId)
        calculatorCollectionView.backgroundColor = .clear
        calculatorCollectionView.contentInset = .init(top: 0, left: 14, bottom: 0, right: 14)
        // 大元の背景色の変更
        view.backgroundColor = .black
    }
    
    // cellをタッチしたかどうかがわかる
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = numbers[indexPath.section][indexPath.row]
        
        switch calculateStatus {
        case .none:
            handleFirstNumberSelected(number: number)
        case .plus, .minus, .multiplication, .division:
            handleSecondNumberSelected(number: number)
        }
    }
    
    private func handleFirstNumberSelected(number: String) {
        switch number {
        case "0"..."9":
            firstNumber += number
            numberLabel.text = firstNumber
            if firstNumber.hasPrefix("0") {
                firstNumber = ""                }
        case ".":
            if confirmIncludeDecimalPoint(numberString: firstNumber) {
                secondNumber += number
                numberLabel.text = secondNumber
            }
        case "+":
            calculateStatus = .plus
        case "-":
            calculateStatus = .minus
        case "*":
            calculateStatus = .multiplication
        case "÷":
            calculateStatus = .division
        case "C":
            clear()
        default:
            break
        }
    }
    
    private func handleSecondNumberSelected(number: String) {
        switch number {
        case "0"..."9":
            secondNumber += number
            numberLabel.text = secondNumber
            if secondNumber.hasPrefix("0") {
                secondNumber = ""
            }
        case ".":
            if confirmIncludeDecimalPoint(numberString: secondNumber) {
                firstNumber += number
                numberLabel.text = firstNumber
            }
        case "=":
            calculateResultNumber()
        case "C":
            clear()
        default:
            break
        }
    }
    
    private func calculateResultNumber() {
        let firstNum = Double(firstNumber) ?? 0
        let secondNum = Double(secondNumber) ?? 0
        
        var resultString: String?
        switch calculateStatus {
        case .plus:
            resultString = String(firstNum + secondNum)
        case .minus:
            resultString = String(firstNum - secondNum)
        case .multiplication:
            resultString = String(firstNum * secondNum)
        case .division:
            resultString = String(firstNum / secondNum)
        default:
            break
        }
        
        if let result = resultString, result.hasSuffix(".0") {
            resultString = result.replacingOccurrences(of: ".0", with: "")
        }
        
        numberLabel.text = resultString
        firstNumber = ""
        secondNumber = ""

        if let _firstNumber = resultString {
            firstNumber = _firstNumber
        }
        calculateStatus = .none
        
    }
    
    private func confirmIncludeDecimalPoint(numberString: String) -> Bool {
        if numberString.contains(".") == true || firstNumber.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    func clear() {
        firstNumber = ""
        secondNumber = ""
        numberLabel.text = "0"
        calculateStatus = .none
    }
}


extension ViewController: UICollectionViewDataSource {
    
    // cellを1行に？いくつ表示するか
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calculatorCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CalculatorViewCell
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        
        numbers[indexPath.section][indexPath.row].forEach { (numberString) in
            if "0"..."9" ~= numberString || numberString == "." {
                cell.numberLabel.backgroundColor = .darkGray
            } else if numberString == "C" || numberString == "%" || numberString == "$" {
                cell.numberLabel.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
                cell.numberLabel.textColor = .black
            }
        }
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }
    
    // cellの大きさなどを変更
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        width = ((collectionView.frame.width - 10) - 14 * 5) / 4
        let height = width
        if indexPath.section == 4 && indexPath.row == 0 {
            // 14はスペース分
            width = width * 2 + 14 + 17
        }
        
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
}


