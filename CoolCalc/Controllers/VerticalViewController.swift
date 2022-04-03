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
    let stack0 = UIStackView() //top
    let stack1 = UIStackView()
    let stack2 = UIStackView()
    let stack3 = UIStackView()
    let stack4 = UIStackView() //bottom
    
    //Display
    let buttonSpacing: CGFloat = 8
    let displayStack = UIStackView()
    let displayLabel = UILabel()
    let displayCalculation = UILabel()
    
    //Models
    let calculator = Calculator() //build this...
    var colorView: ColorView!
    var colorViewExpandedTimer: Timer?
    var colorViewTimerInterval: TimeInterval = 3.0
    var colorViewFrame = CGRect(x: 20, y: 60, width: 100, height: 100)
    var calculationString = ""

    //Buttons
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
        
        setupViewsInitialize()
        setupViewsLayout()
    }


    // MARK: - Setup Helper Functions
    
    private func setupViewsInitialize() {
        //Set up Properties
        view.backgroundColor = K.lightOn ? .white : .black
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
        colorView = ColorView(frame: colorViewFrame)
        colorView.delegate = self
        setColors(color: K.savedColor)
        flipSwitch(lightOn: K.lightOn)
        setExpanded(expanded: false)

        //Set up Stacks
        stackMain.axis = .vertical
        stackMain.distribution = .fill
        stackMain.spacing = buttonSpacing
        stackMain.translatesAutoresizingMaskIntoConstraints = false
        displayStack.axis = .vertical
        displayStack.distribution = .fill
        displayStack.translatesAutoresizingMaskIntoConstraints = false
        stackButtons.axis = .vertical
        stackButtons.distribution = .fillEqually
        stackButtons.spacing = buttonSpacing
        stackButtons.translatesAutoresizingMaskIntoConstraints = false
        stack0.axis = .horizontal
        stack0.distribution = .fillEqually
        stack0.spacing = buttonSpacing
        stack0.translatesAutoresizingMaskIntoConstraints = false
        stack1.axis = .horizontal
        stack1.distribution = .fillEqually
        stack1.spacing = buttonSpacing
        stack1.translatesAutoresizingMaskIntoConstraints = false
        stack2.axis = .horizontal
        stack2.distribution = .fillEqually
        stack2.spacing = buttonSpacing
        stack2.translatesAutoresizingMaskIntoConstraints = false
        stack3.axis = .horizontal
        stack3.distribution = .fillEqually
        stack3.spacing = buttonSpacing
        stack3.translatesAutoresizingMaskIntoConstraints = false
        stack4.distribution = .fillProportionally
        stack4.spacing = buttonSpacing
        stack4.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.translatesAutoresizingMaskIntoConstraints = false

    }
    
    private func setupViewsLayout() {
        //Add stacks to view and set constraints
        view.addSubview(stackMain)
        view.addSubview(colorView)  //This needs to be added AFTER adding stackMain
        NSLayoutConstraint.activate([stackMain.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2 * buttonSpacing),
                                     stackMain.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2 * buttonSpacing),
                                     view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackMain.trailingAnchor, constant: 2 * buttonSpacing),
                                     view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackMain.bottomAnchor, constant: 2 * buttonSpacing)])
        
        stackMain.addArrangedSubview(displayStack)
        NSLayoutConstraint.activate([displayStack.topAnchor.constraint(equalTo: stackMain.arrangedSubviews[0].topAnchor),
                                     displayStack.leadingAnchor.constraint(equalTo: stackMain.arrangedSubviews[0].leadingAnchor),
                                     stackMain.arrangedSubviews[0].trailingAnchor.constraint(equalTo: displayStack.trailingAnchor),
                                     stackMain.arrangedSubviews[0].bottomAnchor.constraint(equalTo: displayStack.bottomAnchor),
                                     displayStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)])
        
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

        stackButtons.addArrangedSubview(stack4)
        NSLayoutConstraint.activate([stack4.topAnchor.constraint(equalTo: stackButtons.arrangedSubviews[4].topAnchor),
                                     stack4.leadingAnchor.constraint(equalTo: stackButtons.arrangedSubviews[4].leadingAnchor),
                                     stackButtons.arrangedSubviews[4].trailingAnchor.constraint(equalTo: stack4.trailingAnchor),
                                     stackButtons.arrangedSubviews[4].bottomAnchor.constraint(equalTo: stack4.bottomAnchor)])

        //Add arranged subviews to button stacks
        displayStack.addArrangedSubview(displayLabel)
        displayStack.addArrangedSubview(displayCalculation)
        stack0.addArrangedSubview(buttonClear)
        stack0.addArrangedSubview(buttonSign)
        stack0.addArrangedSubview(buttonPercent)
        stack0.addArrangedSubview(buttonDivide)
        stack1.addArrangedSubview(button7)
        stack1.addArrangedSubview(button8)
        stack1.addArrangedSubview(button9)
        stack1.addArrangedSubview(buttonMultiply)
        stack2.addArrangedSubview(button4)
        stack2.addArrangedSubview(button5)
        stack2.addArrangedSubview(button6)
        stack2.addArrangedSubview(buttonSubtract)
        stack3.addArrangedSubview(button1)
        stack3.addArrangedSubview(button2)
        stack3.addArrangedSubview(button3)
        stack3.addArrangedSubview(buttonAdd)
        stack4.addArrangedSubview(button0)
        stack4.addArrangedSubview(buttonDecimal)
        stack4.addArrangedSubview(buttonEquals)

        //These constraints allow 2x size for the 0 button
        NSLayoutConstraint.activate([button0.widthAnchor.constraint(equalTo: stack4.widthAnchor, multiplier: 0.5, constant: -0.5 * buttonSpacing),
                                     buttonDecimal.widthAnchor.constraint(equalTo: stack4.widthAnchor, multiplier: 0.25, constant: -0.75 * buttonSpacing)])

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
    func didChangeColor(_ color: UIColor) {
        setColors(color: color)
        
        self.colorViewExpandedTimer?.invalidate()
        self.colorViewExpandedTimer = Timer.scheduledTimer(timeInterval: self.colorViewTimerInterval,
                                                           target: self,
                                                           selector: #selector(runTimerAction(_:)),
                                                           userInfo: nil,
                                                           repeats: false)
    }
    
    func didSelectColor(_ color: UIColor) {
        UserDefaults.standard.set(color, forKey: K.userDefaults_color)
        print("Color: \(color.description) saved to UserDefaults key: \(K.userDefaults_color)")
    }
    
    func didFlipSwitch(_ lightOn: Bool) {
        flipSwitch(lightOn: lightOn)

        UserDefaults.standard.set(lightOn, forKey: K.userDefaults_light)
        print("Light is \(lightOn ? "on" : "off")")
        
        self.colorViewExpandedTimer?.invalidate()
        self.colorViewExpandedTimer = Timer.scheduledTimer(timeInterval: self.colorViewTimerInterval,
                                                           target: self,
                                                           selector: #selector(runTimerAction(_:)),
                                                           userInfo: nil,
                                                           repeats: false)

    }
    
    func didSetExpanded(_ expanded: Bool) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 10,
                       animations: {

            if expanded {
                self.setExpanded(expanded: true)
                
                self.colorViewExpandedTimer?.invalidate()
                self.colorViewExpandedTimer = Timer.scheduledTimer(timeInterval: self.colorViewTimerInterval,
                                                                   target: self,
                                                                   selector: #selector(self.runTimerAction(_:)),
                                                                   userInfo: nil,
                                                                   repeats: false)
            }
            else {
                self.setExpanded(expanded: false)
            }
        })
    }
    
    
    // MARK: - ColorViewSelector Delegate Helper Functions
                                                           
    @objc private func runTimerAction(_ expanded: Bool) {
        colorView.expand(false)
    }
    
    private func setExpanded(expanded: Bool) {
        if expanded {
            colorView.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
            colorView.alpha = 1.0
        }
        else {
            colorView.transform = CGAffineTransform.identity.scaledBy(x: 0.25, y: 0.25)
            colorView.alpha = 0.65
        }

        colorView.frame.origin = colorViewFrame.origin
    }
    
    private func setColors(color: UIColor) {
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
        buttonDecimal.backgroundColor = color
        
        buttonClear.backgroundColor = color.withAlphaComponent(0.5)
        buttonSign.backgroundColor = color.withAlphaComponent(0.5)
        buttonPercent.backgroundColor = color.withAlphaComponent(0.5)

        buttonDivide.backgroundColor = color.getComplimentary()
        buttonMultiply.backgroundColor = color.getComplimentary()
        buttonSubtract.backgroundColor = color.getComplimentary()
        buttonAdd.backgroundColor = color.getComplimentary()
        buttonEquals.backgroundColor = color.getComplimentary()
    }
    
    private func flipSwitch(lightOn: Bool) {
        let backgroundColor: UIColor = lightOn ? .white : .black
        let titleColor: UIColor = lightOn ? .black : .white
        
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = backgroundColor
            self.button0.setTitleColor(titleColor, for: .normal)
            self.button1.setTitleColor(titleColor, for: .normal)
            self.button2.setTitleColor(titleColor, for: .normal)
            self.button3.setTitleColor(titleColor, for: .normal)
            self.button4.setTitleColor(titleColor, for: .normal)
            self.button5.setTitleColor(titleColor, for: .normal)
            self.button6.setTitleColor(titleColor, for: .normal)
            self.button7.setTitleColor(titleColor, for: .normal)
            self.button8.setTitleColor(titleColor, for: .normal)
            self.button9.setTitleColor(titleColor, for: .normal)
            self.buttonDecimal.setTitleColor(titleColor, for: .normal)
            self.buttonClear.setTitleColor(titleColor, for: .normal)
            self.buttonSign.setTitleColor(titleColor, for: .normal)
            self.buttonPercent.setTitleColor(titleColor, for: .normal)
            self.buttonDivide.setTitleColor(titleColor, for: .normal)
            self.buttonMultiply.setTitleColor(titleColor, for: .normal)
            self.buttonSubtract.setTitleColor(titleColor, for: .normal)
            self.buttonAdd.setTitleColor(titleColor, for: .normal)
            self.buttonEquals.setTitleColor(titleColor, for: .normal)
        }
    }
}
