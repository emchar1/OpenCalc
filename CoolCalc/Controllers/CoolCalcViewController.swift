//
//  CoolCalcViewController.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/19/22.
//

import UIKit

class CoolCalcViewController: UIViewController, CustomButtonDelegate, SettingsViewDelegate {
    
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
    // TODO: - Build out Calculator() model
    let calculator = Calculator()
    // TODO: -
    var settingsView: SettingsView!
    var calculationString = ""

    //Buttons
    let buttonClear = CalcButton(buttonLabel: "AC")
    let button7 = CalcButton(buttonLabel: "7")
    let button4 = CalcButton(buttonLabel: "4")
    let button1 = CalcButton(buttonLabel: "1")
    let buttonSign = CalcButton(buttonLabel: "+/-")
    let buttonPercent = CalcButton(buttonLabel: "%")
    let button8 = CalcButton(buttonLabel: "8")
    let button5 = CalcButton(buttonLabel: "5")
    let button2 = CalcButton(buttonLabel: "2")
    let button0 = CalcButton(buttonLabel: "0")
    let buttonDivide = CalcButton(buttonLabel: "÷")
    let button9 = CalcButton(buttonLabel: "9")
    let button6 = CalcButton(buttonLabel: "6")
    let button3 = CalcButton(buttonLabel: "3")
    let buttonDecimal = CalcButton(buttonLabel: ".")
    let buttonMultiply = CalcButton(buttonLabel: "×")
    let buttonSubtract = CalcButton(buttonLabel: "-")
    let buttonAdd = CalcButton(buttonLabel: "+")
    let buttonEquals = CalcButton(buttonLabel: "=")
    

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
        var wideSize: CGFloat
        
        switch settingsView.appearanceButtonSelected {
        case 1: wideSize = button1.buttonCornerRadius / 2
        case 2: wideSize = button1.frame.height / 2
        case 3: wideSize = 0
        default: wideSize = 0
        }
        
        settingsView.setOrigin()
        
        button0.updateAttributesWithOrientationChange(wideSize: wideSize)
        button1.updateAttributesWithOrientationChange(wideSize: wideSize)
        button2.updateAttributesWithOrientationChange(wideSize: wideSize)
        button3.updateAttributesWithOrientationChange(wideSize: wideSize)
        button4.updateAttributesWithOrientationChange(wideSize: wideSize)
        button5.updateAttributesWithOrientationChange(wideSize: wideSize)
        button6.updateAttributesWithOrientationChange(wideSize: wideSize)
        button7.updateAttributesWithOrientationChange(wideSize: wideSize)
        button8.updateAttributesWithOrientationChange(wideSize: wideSize)
        button9.updateAttributesWithOrientationChange(wideSize: wideSize)
        buttonDecimal.updateAttributesWithOrientationChange(wideSize: wideSize)
        buttonClear.updateAttributesWithOrientationChange(wideSize: wideSize)
        buttonSign.updateAttributesWithOrientationChange(wideSize: wideSize)
        buttonPercent.updateAttributesWithOrientationChange(wideSize: wideSize)
        buttonDivide.updateAttributesWithOrientationChange(wideSize: wideSize)
        buttonMultiply.updateAttributesWithOrientationChange(wideSize: wideSize)
        buttonSubtract.updateAttributesWithOrientationChange(wideSize: wideSize)
        buttonAdd.updateAttributesWithOrientationChange(wideSize: wideSize)
        buttonEquals.updateAttributesWithOrientationChange(wideSize: wideSize)
    }
    
    private func setupViewsInitialize() {
        //Set up Properties
        view.backgroundColor = K.lightOn ? .white : .black
        displayLabel.textAlignment = .right
        displayCalculation.alpha = 0.8
        displayCalculation.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 80)
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
        
        settingsView = SettingsView(withSize: 125)
        settingsView.delegate = self
                
        //Do all this AFTER initializing the properties above!
        setColors(color: K.savedColor)
        setLight(lightOn: K.lightOn)


        
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
        NSLayoutConstraint.activate([displayCalculation.heightAnchor.constraint(equalToConstant: 100)])
    }
}


// MARK: - CustomButton Delegate

extension CoolCalcViewController {
    func didTapButton(_ button: CustomButton) {
        if let button = button as? CalcButton {
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
}


// MARK: - SettingsView Delegate

extension CoolCalcViewController {
    func didChangeColor(_ color: UIColor?) {
        guard let color = color else { return }

        setColors(color: color)
    }
    
    func didSelectColor(_ color: UIColor?) {
        guard let color = color else { return }
        
        UserDefaults.standard.set(color, forKey: K.userDefaults_color)
        print("Color: \(color.description) saved to UserDefaults key: \(K.userDefaults_color)")
    }
    
    func didFlipSwitch(_ lightOn: Bool) {
        setLight(lightOn: lightOn)

        UserDefaults.standard.set(lightOn, forKey: K.userDefaults_light)
        print("Light is \(lightOn ? "ON" : "OFF") saved to UserDefaults key: \(K.userDefaults_light)")
    }
    
    func didHitMute(_ muteOn: Bool) {
        UserDefaults.standard.set(muteOn, forKey: K.userDefaults_mute)
        print("Mute is \(muteOn ? "ON" : "OFF") saved to UserDefaults key: \(K.userDefaults_mute)")
    }
    
    func didUpdateAppearance(_ appearanceButtonToggle: Int) {
        switch appearanceButtonToggle {
        case 1:
            setButtonAppearance(alpha: 0.65, offset: 5.0, size: 10, cornerRadius: 20, duration: 0.25, sound: "Tap1")
        case 2:
            setButtonAppearance(alpha: 0.65, offset: 2.0, size: button1.frame.height / 2, cornerRadius: button1.frame.height / 2, duration: 0.1, sound: "Tap2")
        case 3:
            setButtonAppearance(alpha: 0.65, offset: 8.0, size: 0, cornerRadius: 0, duration: 0.35, sound: "Tap3")
        default:
            break
        }
    }
    

    // MARK: - SettingsView Delegate Helper Functions
    
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
    
    private func setButtonAppearance(alpha: CGFloat, offset: CGFloat, size: CGFloat, cornerRadius: CGFloat, duration: CGFloat, sound: String) {
        UIView.animate(withDuration: 0.25) { [unowned self] in
            button0.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            button1.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            button2.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            button3.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            button4.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            button5.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            button6.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            button7.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            button8.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            button9.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            buttonDecimal.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            buttonClear.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            buttonSign.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            buttonPercent.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            buttonDivide.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            buttonMultiply.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            buttonSubtract.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            buttonAdd.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
            buttonEquals.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound)
        }
    }
}
