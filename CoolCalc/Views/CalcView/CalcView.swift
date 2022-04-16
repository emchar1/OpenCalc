//
//  CalcView.swift
//  CoolCalc
//
//  Created by Eddie Char on 4/9/22.
//

import UIKit


protocol CalcViewDelegate {
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
    private let displayCalculation = UILabel()
    
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
    
    //Other Properties
    var calculationString = "0" {
        didSet {
            displayCalculation.text = calculationString
        }
    }
    var delegate: CalcViewDelegate?

    
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
        displayLabel.textAlignment = .right
        displayCalculation.text = calculationString
        displayCalculation.alpha = 0.8
        displayCalculation.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 80)
        displayCalculation.textAlignment = .right
        displayCalculation.adjustsFontSizeToFitWidth = true
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
    
    
    // MARK: - Public Functions
    
    /**
     Returns a typical button, i.e. button1.
     - returns: button1
     */
    func getButton() -> CalcButton {
        return button1
    }
    
    func updateButtonClear(resetToAllClear: Bool) {
        buttonClear.buttonLabel = resetToAllClear ? "AC" : "C"
        buttonClear.setTitle(buttonClear.buttonLabel, for: .normal)
    }
    
    func setColors(color: UIColor?) {
        guard let color = color else { return }
        
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
            
            displayCalculation.textColor = textColor                        
        }
    }
    
    func setButtonAppearance(alpha: CGFloat, offset: CGFloat, size: CGFloat, cornerRadius: CGFloat, duration: CGFloat, sound: String) {
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
    
    
    func orientationDidChange(wideSize: CGFloat) {
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
}


// MARK: - CustomButtonDelegate

extension CalcView {
    func didTapButton(_ button: CustomButton) {
        guard let button = button as? CalcButton else { return }
        
        delegate?.buttonPressed(self, button: button)
    }
}