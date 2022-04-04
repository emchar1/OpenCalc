//
//  VerticalViewController.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/19/22.
//

import UIKit

class VerticalViewController: UIViewController, CalcButtonDelegate, SettingsViewDelegate {
    
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
    let settingsViewSize: CGFloat = 125
    let settingsViewShrinkFactor: CGFloat = 0.25
    var settingsView: SettingsView!
    var settingsViewExpandedTimer: Timer?
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
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationDidChange(_:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return K.lightOn ? .darkContent : .lightContent
    }

    // MARK: - Setup Helper Functions
    
    @objc private func orientationDidChange(_ notification: NSNotification) {
        let buttonFont = UIDevice.current.orientation.isLandscape ? K.buttonFontWide : K.buttonFontTall
        
        resetSettingsViewOrigin()
        
        button0.titleLabel?.font = buttonFont
        button1.titleLabel?.font = buttonFont
        button2.titleLabel?.font = buttonFont
        button3.titleLabel?.font = buttonFont
        button4.titleLabel?.font = buttonFont
        button5.titleLabel?.font = buttonFont
        button6.titleLabel?.font = buttonFont
        button7.titleLabel?.font = buttonFont
        button8.titleLabel?.font = buttonFont
        button9.titleLabel?.font = buttonFont
        buttonDecimal.titleLabel?.font = buttonFont
        buttonClear.titleLabel?.font = buttonFont
        buttonSign.titleLabel?.font = buttonFont
        buttonPercent.titleLabel?.font = buttonFont
        buttonDivide.titleLabel?.font = buttonFont
        buttonMultiply.titleLabel?.font = buttonFont
        buttonSubtract.titleLabel?.font = buttonFont
        buttonAdd.titleLabel?.font = buttonFont
        buttonEquals.titleLabel?.font = buttonFont
    }
    
    private func resetSettingsViewOrigin() {
        settingsView.frame.origin = CGPoint(x: K.getSafeAreaInsets().leading + (settingsViewSize * settingsViewShrinkFactor / 2) + 1,
                                              y: K.getSafeAreaInsets().top + (settingsViewSize * settingsViewShrinkFactor / 2) + 1)
    }
    
    private func setupViewsInitialize() {
        //Set up Properties
        view.backgroundColor = K.lightOn ? .white : .black
        displayLabel.textAlignment = .right
        displayCalculation.alpha = 0.65
        displayCalculation.font = K.buttonFontWide
        displayCalculation.textAlignment = .right
        displayCalculation.textColor = K.lightOn ? .black : .white
        
        button0.delegate = self
        button1.delegate = self
        button2.delegate = self
        button3.delegate = self
        button4.delegate = self
        button5.delegate = self
        button6.delegate = self
        button7.delegate = self
        button8.delegate = self
        button9.delegate = self
        buttonDecimal.delegate = self
        buttonClear.delegate = self
        buttonSign.delegate = self
        buttonPercent.delegate = self
        buttonDivide.delegate = self
        buttonMultiply.delegate = self
        buttonSubtract.delegate = self
        buttonAdd.delegate = self
        buttonEquals.delegate = self
        
        settingsView = SettingsView(frame: CGRect(x: K.getSafeAreaInsets().leading, y: K.getSafeAreaInsets().top, width: settingsViewSize, height: settingsViewSize))
        settingsView.delegate = self
        setColors(color: K.savedColor)
        setLight(lightOn: K.lightOn)
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
        view.addSubview(settingsView)  //This needs to be added AFTER adding stackMain
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

        //Add arranged subviews to button stacks. Buttons MUST be in this order!
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


// MARK: - SettingsView Delegate

extension VerticalViewController {
    func didChangeColor(_ color: UIColor) {
        setColors(color: color)
        resetTimer()
    }
    
    func didSelectColor(_ color: UIColor) {
        UserDefaults.standard.set(color, forKey: K.userDefaults_color)
        print("Color: \(color.description) saved to UserDefaults key: \(K.userDefaults_color)")
    }
    
    func didFlipSwitch(_ lightOn: Bool) {
        setLight(lightOn: lightOn)
        resetTimer()

        UserDefaults.standard.set(lightOn, forKey: K.userDefaults_light)
        print("Light is \(lightOn ? "ON" : "OFF") saved to UserDefaults key: \(K.userDefaults_light)")
    }
    
    func didSetExpanded(_ expanded: Bool) {
        setExpanded(expanded: expanded)
        
        if expanded {
            resetTimer()
        }
    }
    
    
    // MARK: - SettingsView Delegate Helper Functions
     
    private func resetTimer() {
        settingsViewExpandedTimer?.invalidate()
        settingsViewExpandedTimer = Timer.scheduledTimer(timeInterval: 3.0,
                                                           target: self,
                                                           selector: #selector(runTimerAction(_:)),
                                                           userInfo: nil,
                                                           repeats: false)
    }
    
    @objc private func runTimerAction(_ expanded: Bool) {
        settingsView.expand(false)
    }
    
    private func setExpanded(expanded: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10) { [unowned self] in
            if expanded {
                settingsView.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                settingsView.alpha = 1.0
            }
            else {
                settingsView.transform = CGAffineTransform.identity.scaledBy(x: settingsViewShrinkFactor, y: settingsViewShrinkFactor)
                settingsView.alpha = 0.75
                
            }
            
            //Need to reinstate this, otherwise view expands from the center, not the top-left
            resetSettingsViewOrigin()
        }
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
    
    private func setLight(lightOn: Bool) {
        let backgroundColor: UIColor = lightOn ? .white : .black
        let textColor: UIColor = lightOn ? .black : .white
        
        UIView.animate(withDuration: 0.5) { [unowned self] in
            view.backgroundColor = backgroundColor
            button0.setTitleColor(textColor, for: .normal)
            button1.setTitleColor(textColor, for: .normal)
            button2.setTitleColor(textColor, for: .normal)
            button3.setTitleColor(textColor, for: .normal)
            button4.setTitleColor(textColor, for: .normal)
            button5.setTitleColor(textColor, for: .normal)
            button6.setTitleColor(textColor, for: .normal)
            button7.setTitleColor(textColor, for: .normal)
            button8.setTitleColor(textColor, for: .normal)
            button9.setTitleColor(textColor, for: .normal)
            buttonDecimal.setTitleColor(textColor, for: .normal)
            buttonClear.setTitleColor(textColor, for: .normal)
            buttonSign.setTitleColor(textColor, for: .normal)
            buttonPercent.setTitleColor(textColor, for: .normal)
            buttonDivide.setTitleColor(textColor, for: .normal)
            buttonMultiply.setTitleColor(textColor, for: .normal)
            buttonSubtract.setTitleColor(textColor, for: .normal)
            buttonAdd.setTitleColor(textColor, for: .normal)
            buttonEquals.setTitleColor(textColor, for: .normal)
            
            displayCalculation.textColor = textColor
            
            setNeedsStatusBarAppearanceUpdate()
        }
    }
}
