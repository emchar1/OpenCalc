//
//  VerticalViewController.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/19/22.
//

import UIKit

class VerticalViewController: UIViewController, CalcButtonDelegate, ColorViewDelegate {
    
    // MARK: - Properties
    
    //Stacks
    var stackMain = UIStackView()
    let stackButtons = UIStackView()
    let stack0 = UIStackView()
    let stack1 = UIStackView()
    let stack2 = UIStackView()
    let stack3 = UIStackView()
    
    //Display
    let spacing: CGFloat = 4
    let displayStack = UIStackView()
    let displayLabel = UILabel()
    let displayCalculation = UILabel()
    var calculationString = ""

    //Buttons
    let calculator = Calculator()
    var colorView: ColorView!
    
    
    let buttonClear = CalcButton(label: "AC")
    let button7 = CalcButton(label: "7")
    let button4 = CalcButton(label: "4")
    let button1 = CalcButton(label: "1")
    let buttonSign = CalcButton(label: "+/-")
    let buttonPercent = CalcButton(label: "%")
    let button8 = CalcButton(label: "8")
    let button5 = CalcButton(label: "5")
    let button2 = CalcButton(label: "2")
    let button0 = CalcButton(label: "0")
    let buttonDivide = CalcButton(label: "÷")
    let button9 = CalcButton(label: "9")
    let button6 = CalcButton(label: "6")
    let button3 = CalcButton(label: "3")
    let buttonDecimal = CalcButton(label: ".")
    let buttonMultiply = CalcButton(label: "×")
    let buttonSubtract = CalcButton(label: "-")
    let buttonAdd = CalcButton(label: "+")
    let buttonEquals = CalcButton(label: "=")
    

    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupViews()
        setupViewsInitialize()
        setupViewsLayout()
        
        view.addSubview(colorView)
        colorView.delegate = self

//        colorSelectorView.backgroundColor = .red
    }
}


// MARK: - Setup Helper Functions

extension VerticalViewController {
    private func setupViews() {
        //Debug - button colors
//        stackMain.backgroundColor = .systemOrange
//        displayStack.backgroundColor = .systemBlue
//        displayLabel.backgroundColor = .systemCyan
//        displayCalculation.backgroundColor = .systemIndigo
//        stackButtons.backgroundColor = .magenta
//        stackClear.backgroundColor = .systemPurple
//        stackPercent.backgroundColor = .systemPurple
//        stackDivide.backgroundColor = .systemPurple
//        stackMultiply.backgroundColor = .systemPurple
//        buttonClear.backgroundColor = .systemRed
//        button7.backgroundColor = .systemOrange
//        button4.backgroundColor = .systemYellow
//        button1.backgroundColor = .systemGreen
//        buttonSign.backgroundColor = .systemBlue
//        buttonPercent.backgroundColor = .systemRed
//        button8.backgroundColor = .systemOrange
//        button5.backgroundColor = .systemYellow
//        button2.backgroundColor = .systemGreen
//        button0.backgroundColor = .systemBlue
//        buttonDivide.backgroundColor = .systemRed
//        button9.backgroundColor = .systemOrange
//        button6.backgroundColor = .systemYellow
//        button3.backgroundColor = .systemGreen
//        buttonDecimal.backgroundColor = .systemBlue
//        buttonMultiply.backgroundColor = .systemRed
//        buttonSubtract.backgroundColor = .systemOrange
//        buttonAdd.backgroundColor = .systemYellow
//        buttonEquals.backgroundColor = .systemGreen
//        buttonMultiply.backgroundColor = .systemBackground
//        buttonEquals.backgroundColor = .secondarySystemBackground
    }
    
    private func setupViewsInitialize() {
        //Set up Properties
        displayLabel.textAlignment = .right
        displayCalculation.backgroundColor = .secondarySystemBackground
        displayCalculation.alpha = 0.65
        displayCalculation.textAlignment = .right
        displayCalculation.textColor = .label
        buttonClear.delegate = self
        button7.delegate = self
        button4.delegate = self
        button1.delegate = self
        buttonSign.delegate = self
        buttonPercent.delegate = self
        button8.delegate = self
        button5.delegate = self
        button2.delegate = self
        button0.delegate = self
        buttonDivide.delegate = self
        button9.delegate = self
        button6.delegate = self
        button3.delegate = self
        buttonDecimal.delegate = self
        buttonMultiply.delegate = self
        buttonSubtract.delegate = self
        buttonAdd.delegate = self
        buttonEquals.delegate = self
        colorView = ColorView(frame: CGRect(x: 20, y: 60, width: 100, height: 100))

        //Set up Stacks
        stackMain.axis = .vertical
        stackMain.distribution = .fill
        stackMain.spacing = spacing
        stackMain.translatesAutoresizingMaskIntoConstraints = false
        displayStack.axis = .vertical
        displayStack.distribution = .fill
        displayStack.translatesAutoresizingMaskIntoConstraints = false
        stackButtons.axis = .horizontal
        stackButtons.distribution = .fillEqually
        stackButtons.spacing = spacing
        stackButtons.translatesAutoresizingMaskIntoConstraints = false
        stack0.axis = .vertical
        stack0.distribution = .fillEqually
        stack0.spacing = spacing
        stack0.translatesAutoresizingMaskIntoConstraints = false
        stack1.axis = .vertical
        stack1.distribution = .fillEqually
        stack1.spacing = spacing
        stack1.translatesAutoresizingMaskIntoConstraints = false
        stack2.axis = .vertical
        stack2.distribution = .fillEqually
        stack2.spacing = spacing
        stack2.translatesAutoresizingMaskIntoConstraints = false
        stack3.axis = .vertical
        stack3.distribution = .fillProportionally
        stack3.spacing = spacing
        stack3.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupViewsLayout() {
        //Add stacks to view and set constraints
        view.addSubview(stackMain)
        NSLayoutConstraint.activate([stackMain.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2 * spacing),
                                     stackMain.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2 * spacing),
                                     view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackMain.trailingAnchor, constant: 2 * spacing),
                                     view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackMain.bottomAnchor, constant: 2 * spacing)])
        
        stackMain.addArrangedSubview(displayStack)
        NSLayoutConstraint.activate([displayStack.topAnchor.constraint(equalTo: stackMain.arrangedSubviews[0].topAnchor),
                                     displayStack.leadingAnchor.constraint(equalTo: stackMain.arrangedSubviews[0].leadingAnchor),
                                     stackMain.arrangedSubviews[0].trailingAnchor.constraint(equalTo: displayStack.trailingAnchor),
                                     stackMain.arrangedSubviews[0].bottomAnchor.constraint(equalTo: displayStack.bottomAnchor),
                                     displayStack.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.5)])
        
        stackMain.addArrangedSubview(stackButtons)
        NSLayoutConstraint.activate([stackButtons.topAnchor.constraint(equalTo: stackMain.arrangedSubviews[1].topAnchor),
                                     stackButtons.leadingAnchor.constraint(equalTo: stackMain.arrangedSubviews[1].leadingAnchor),
                                     stackMain.arrangedSubviews[1].trailingAnchor.constraint(equalTo: stackButtons.trailingAnchor),
                                     stackMain.arrangedSubviews[1].bottomAnchor.constraint(equalTo: stackButtons.bottomAnchor)])
        
        stackButtons.addArrangedSubview(stack0)
        NSLayoutConstraint.activate([stack0.topAnchor.constraint(equalTo: stackButtons.arrangedSubviews[0].topAnchor),
                                     stack0.leadingAnchor.constraint(equalTo: stackButtons.arrangedSubviews[0].leadingAnchor),
                                     stackButtons.arrangedSubviews[0].trailingAnchor.constraint(equalTo: stack0.trailingAnchor),
                                     stackButtons.arrangedSubviews[0].bottomAnchor.constraint(equalTo: stack0.bottomAnchor)])

        stackButtons.addArrangedSubview(stack1)
        NSLayoutConstraint.activate([stack1.topAnchor.constraint(equalTo: stackButtons.arrangedSubviews[1].topAnchor),
                                     stack1.leadingAnchor.constraint(equalTo: stackButtons.arrangedSubviews[1].leadingAnchor),
                                     stackButtons.arrangedSubviews[1].trailingAnchor.constraint(equalTo: stack1.trailingAnchor),
                                     stackButtons.arrangedSubviews[1].bottomAnchor.constraint(equalTo: stack1.bottomAnchor)])

        stackButtons.addArrangedSubview(stack2)
        NSLayoutConstraint.activate([stack2.topAnchor.constraint(equalTo: stackButtons.arrangedSubviews[2].topAnchor),
                                     stack2.leadingAnchor.constraint(equalTo: stackButtons.arrangedSubviews[2].leadingAnchor),
                                     stackButtons.arrangedSubviews[2].trailingAnchor.constraint(equalTo: stack2.trailingAnchor),
                                     stackButtons.arrangedSubviews[2].bottomAnchor.constraint(equalTo: stack2.bottomAnchor)])

        stackButtons.addArrangedSubview(stack3)
        NSLayoutConstraint.activate([stack3.topAnchor.constraint(equalTo: stackButtons.arrangedSubviews[3].topAnchor),
                                     stack3.leadingAnchor.constraint(equalTo: stackButtons.arrangedSubviews[3].leadingAnchor),
                                     stackButtons.arrangedSubviews[3].trailingAnchor.constraint(equalTo: stack3.trailingAnchor),
                                     stackButtons.arrangedSubviews[3].bottomAnchor.constraint(equalTo: stack3.bottomAnchor)])
        
        //Add arranged subviews to button stacks
        displayStack.addArrangedSubview(displayLabel)
        displayStack.addArrangedSubview(displayCalculation)
        stack0.addArrangedSubview(buttonClear)
        stack0.addArrangedSubview(button7)
        stack0.addArrangedSubview(button4)
        stack0.addArrangedSubview(button1)
        stack0.addArrangedSubview(buttonSign)
        stack1.addArrangedSubview(buttonPercent)
        stack1.addArrangedSubview(button8)
        stack1.addArrangedSubview(button5)
        stack1.addArrangedSubview(button2)
        stack1.addArrangedSubview(button0)
        stack2.addArrangedSubview(buttonDivide)
        stack2.addArrangedSubview(button9)
        stack2.addArrangedSubview(button6)
        stack2.addArrangedSubview(button3)
        stack2.addArrangedSubview(buttonDecimal)
        stack3.addArrangedSubview(buttonMultiply)
        stack3.addArrangedSubview(buttonSubtract)
        stack3.addArrangedSubview(buttonAdd)
        stack3.addArrangedSubview(buttonEquals)
                
        //These constraints allow 2x size for the = button. Is this the cleanest way to do it???
        NSLayoutConstraint.activate([buttonMultiply.heightAnchor.constraint(equalTo: stack3.heightAnchor, multiplier: 0.2, constant: -0.8 * spacing),
                                     buttonSubtract.heightAnchor.constraint(equalTo: stack3.heightAnchor, multiplier: 0.2, constant: -0.8 * spacing),
                                     buttonAdd.heightAnchor.constraint(equalTo: stack3.heightAnchor, multiplier: 0.2, constant: -0.8 * spacing),
                                     buttonEquals.heightAnchor.constraint(equalTo: stack3.heightAnchor, multiplier: 0.4, constant: -0.6 * spacing)])

        //Display Label
        NSLayoutConstraint.activate([displayCalculation.heightAnchor.constraint(equalToConstant: 40)])
//        NSLayoutConstraint.activate([displayLabel.topAnchor.constraint(equalTo: displayStack.topAnchor),
//                                     displayLabel.leadingAnchor.constraint(equalTo: displayStack.leadingAnchor),
//                                     displayStack.trailingAnchor.constraint(equalTo: displayLabel.trailingAnchor),
//                                     displayStack.bottomAnchor.constraint(equalTo: displayLabel.bottomAnchor)])
//        NSLayoutConstraint.activate([displayLabel.topAnchor.constraint(equalTo: displayStack.topAnchor),
//                                     displayLabel.leadingAnchor.constraint(equalTo: displayStack.leadingAnchor),
//                                     displayStack.trailingAnchor.constraint(equalTo: displayLabel.trailingAnchor),
//                                     displayStack.bottomAnchor.constraint(equalTo: displayLabel.bottomAnchor)])
    }
    
}


// MARK: - CalcButton Delegate

extension VerticalViewController {
    func didTapButton(_ button: CalcButton) {
        switch button.model.type {
        case .number:
            calculationString += button.model.value
        case .clear:
            calculationString = ""
        case .decimal:
            calculationString += button.model.value
        case .sign:
            calculationString += "#"
        default:
            calculationString += "?"
        }
                
        displayCalculation.text = calculationString
    }
}


// MARK: - ColorSelectorView Delegate

extension VerticalViewController {
    func didSelectColor(_ color: UIColor) {
//        view.backgroundColor = color
        
        button0.backgroundColor = color
        button1.backgroundColor = color
        button2.backgroundColor = color
        button3.backgroundColor = color
        button4.backgroundColor = color
        button5.backgroundColor = color
        button6.backgroundColor = color
        button7.backgroundColor = color
        button8.backgroundColor = color
        button9.backgroundColor = color
    }
}
