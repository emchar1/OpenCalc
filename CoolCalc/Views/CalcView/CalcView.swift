//
//  CalcView.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/9/22.
//

import UIKit


protocol CalcViewDelegate: AnyObject {
    func buttonPressed(_ view: CalcView, button: CalcButton)
}


class CalcView: UIView, CustomButtonDelegate {
    // MARK: - Properties
    
    //Stacks
    private var stackMain = UIStackView()
    private let stackButtons = UIStackView()
    private let stack0 = UIStackView() //top
    private let stack1 = UIStackView()
    private let stack2 = UIStackView()
    private let stack3 = UIStackView()
    private let stack4 = UIStackView() //bottom
    
    //Display
    private let buttonSpacing: CGFloat = 8
    private let displayStack = UIStackView()
    private let displayLabel = UILabel()
    private let displayRunningLabel = UILabel()
    private let displaySpacerLabel = UILabel()
    
    //Buttons
    private let buttonClear = CalcButton(buttonLabel: "AC")
    private let button7 = CalcButton(buttonLabel: "7")
    private let button4 = CalcButton(buttonLabel: "4")
    private let button1 = CalcButton(buttonLabel: "1")
    private let buttonSign = CalcButton(buttonLabel: "+/-")
    private let buttonPercent = CalcButton(buttonLabel: "%")
    private let button8 = CalcButton(buttonLabel: "8")
    private let button5 = CalcButton(buttonLabel: "5")
    private let button2 = CalcButton(buttonLabel: "2")
    private let button0 = CalcButton(buttonLabel: "0")
    private let buttonDivide = CalcButton(buttonLabel: "÷")
    private let button9 = CalcButton(buttonLabel: "9")
    private let button6 = CalcButton(buttonLabel: "6")
    private let button3 = CalcButton(buttonLabel: "3")
    private let buttonDecimal = CalcButton(buttonLabel: ".")
    private let buttonMultiply = CalcButton(buttonLabel: "×")
    private let buttonSubtract = CalcButton(buttonLabel: "-")
    private let buttonAdd = CalcButton(buttonLabel: "+")
    private let buttonEquals = CalcButton(buttonLabel: "=")
    
    //Public Properties
    var standardButton: CalcButton {
        return button1
    }
    var calculationString = "0" {
        didSet {
            displayLabel.text = calculationString
        }
    }
    var calculationExpression = "0" {
        didSet {
            displayRunningLabel.text = calculationExpression
        }
    }
    weak var delegate: CalcViewDelegate?

    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewsInitialize()
        setupViewsLayout()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViewsInitialize() {
        //Set up Properties
        backgroundColor = K.lightOn ? .white : .black
        
        displayLabel.text = calculationString
        displayLabel.alpha = 0.8
        displayLabel.font = UIFont(name: K.font1Main, size: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 0.22)
        displayLabel.textAlignment = .right
        displayLabel.adjustsFontSizeToFitWidth = true
        displayLabel.textColor = K.lightOn ? .black : .white
        
        displayRunningLabel.text = calculationExpression
        displayRunningLabel.alpha = 0.4
        displayRunningLabel.font = UIFont(name: K.font1Bold, size: traitCollection.horizontalSizeClass == .compact ? 18 : 36)
        displayRunningLabel.textAlignment = .right
        displayRunningLabel.textColor = K.lightOn ? .black : .white
        
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

    }
    
    private func setupViewsLayout() {
        //Add stacks to view and set constraints
        addSubview(stackMain)
        NSLayoutConstraint.activate([stackMain.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2 * buttonSpacing),
                                     stackMain.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 2 * buttonSpacing),
                                     safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackMain.trailingAnchor, constant: 2 * buttonSpacing),
                                     safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackMain.bottomAnchor, constant: 2 * buttonSpacing)])
        
        stackMain.addArrangedSubview(displayStack)
        NSLayoutConstraint.activate([displayStack.topAnchor.constraint(equalTo: stackMain.arrangedSubviews[0].topAnchor),
                                     displayStack.leadingAnchor.constraint(equalTo: stackMain.arrangedSubviews[0].leadingAnchor),
                                     stackMain.arrangedSubviews[0].trailingAnchor.constraint(equalTo: displayStack.trailingAnchor),
                                     stackMain.arrangedSubviews[0].bottomAnchor.constraint(equalTo: displayStack.bottomAnchor),
                                     displayStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35)])
        
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
        displayStack.addArrangedSubview(displaySpacerLabel)
        displayStack.addArrangedSubview(displayLabel)
        displayStack.addArrangedSubview(displayRunningLabel)
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
        NSLayoutConstraint.activate([displayLabel.heightAnchor.constraint(equalToConstant: displayLabel.font.pointSize)])
        NSLayoutConstraint.activate([displayRunningLabel.heightAnchor.constraint(equalToConstant: displayRunningLabel.font.pointSize)])
    }
    
    
    // MARK: - Public Functions
        
    func updateButtonClear(resetToAllClear: Bool) {
        buttonClear.buttonLabel = resetToAllClear ? "AC" : "C"
        buttonClear.setTitle(buttonClear.buttonLabel, for: .normal)
    }
    
    func setColors(color: UIColor?) {
        guard let color = color else { return }
        
        let colorAltLeft = color.complementary
        let colorAltRight = color.complementary
        
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

        buttonDivide.backgroundColor = colorAltLeft
        buttonMultiply.backgroundColor = colorAltLeft
        buttonSubtract.backgroundColor = colorAltRight
        buttonAdd.backgroundColor = colorAltRight
        buttonEquals.backgroundColor = colorAltRight
    }
    
    func setLight(lightOn: Bool) {
        let backgroundColor: UIColor = lightOn ? .white : .black
        let textColor: UIColor = lightOn ? .black : .white
        
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.backgroundColor = backgroundColor
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
            
            displayLabel.textColor = textColor
            displayRunningLabel.textColor = textColor
        }
    }
    
    func setButtonAppearance(alpha: CGFloat, offset: CGFloat, size: CGFloat, cornerRadius: CGFloat, duration: CGFloat, sound: String, fonts: (main: String, bold: String)) {
        UIView.animate(withDuration: 0.25) { [unowned self] in
            button0.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            button1.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            button2.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            button3.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            button4.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            button5.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            button6.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            button7.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            button8.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            button9.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            buttonDecimal.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            buttonClear.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            buttonSign.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            buttonPercent.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            buttonDivide.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            buttonMultiply.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            buttonSubtract.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            buttonAdd.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            buttonEquals.updateWithAppearanceChange(alpha: alpha, offset: offset, wideSize: size, cornerRadius: cornerRadius, duration: duration, sound: sound, fonts: (fonts.main, fonts.bold))
            
            displayLabel.font = UIFont(name: fonts.main, size: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 0.22)
            displayRunningLabel.font = UIFont(name: fonts.bold, size: traitCollection.horizontalSizeClass == .compact ? 18 : 36)

        }
    }
    
    
    func orientationDidChange(cornerRadiusLandscape cornerRadius: CGFloat) {
        button0.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        button1.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        button2.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        button3.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        button4.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        button5.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        button6.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        button7.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        button8.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        button9.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        buttonDecimal.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        buttonClear.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        buttonSign.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        buttonPercent.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        buttonDivide.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        buttonMultiply.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        buttonSubtract.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        buttonAdd.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
        buttonEquals.updateAttributesWithOrientationChange(cornerRadiusForLandscape: cornerRadius)
    }
}


// MARK: - CustomButtonDelegate

extension CalcView {
    func didTapButton(_ button: CustomButton) {
        guard let button = button as? CalcButton else { return }
        
        delegate?.buttonPressed(self, button: button)
    }
}
