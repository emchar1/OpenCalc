//
//  CoolCalcViewController.swift
//  CoolCalc
//
//  Created by Eddie Char on 3/19/22.
//

import UIKit

class CoolCalcViewController: UIViewController, SettingsViewDelegate, CalcViewDelegate {
    
    // MARK: - Properties

    var calcView: CalcView!
    var settingsView: SettingsView!
    var calculator = Calculator()


    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calcView = CalcView(frame: view.frame)
        calcView.delegate = self
        
        settingsView = SettingsView(withSize: 125)
        settingsView.delegate = self
                
        view.addSubview(calcView)
        view.addSubview(settingsView)
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
        case 1: wideSize = calcView.getButton().buttonCornerRadius / 2
        case 2: wideSize = calcView.getButton().frame.height / 2
        case 3: wideSize = 0
        default: wideSize = 0
        }
        
        calcView.orientationDidChange(wideSize: wideSize)
        settingsView.setOrigin()
        
        calcView.frame = view.frame
    }
    
}


// MARK: - CalcView Delegate

// FIXME: - Calculator Model
extension CoolCalcViewController {
    func buttonPressed(_ view: CalcView, button: CalcButton) {
        calcView.calculationString = calculator.getInput(button: button)
    }
}


// MARK: - SettingsView Delegate

extension CoolCalcViewController {
    func didChangeColor(_ color: UIColor?) {
        calcView.setColors(color: color)
    }
        
    func didFlipSwitch(_ lightOn: Bool) {
        calcView.setLight(lightOn: lightOn)
    }
        
    func didUpdateAppearance(_ appearanceButtonToggle: Int) {
        switch appearanceButtonToggle {
        case 1:
            calcView.setButtonAppearance(alpha: 0.65,
                                             offset: 5.0,
                                             size: 10,
                                             cornerRadius: 20,
                                             duration: 0.25,
                                             sound: "Tap1")
        case 2:
            calcView.setButtonAppearance(alpha: 0.65,
                                             offset: 2.0,
                                             size: calcView.getButton().frame.height / 2,
                                             cornerRadius: calcView.getButton().frame.height / 2,
                                             duration: 0.1,
                                             sound: "Tap2")
        case 3:
            calcView.setButtonAppearance(alpha: 0.65,
                                             offset: 8.0,
                                             size: 0,
                                             cornerRadius: 0,
                                             duration: 0.35,
                                             sound: "Tap3")
        default:
            break
        }
    }
}
