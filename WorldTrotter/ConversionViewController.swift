//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Cesar Carrillo on 8/29/17.
//  Copyright © 2017 Cesar Carrillo. All rights reserved.
//


import UIKit

class ConversionViewController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet var celsiusLabel: UILabel!
    @IBOutlet var textField: UITextField!
    
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet{
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>?
    {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        }
        else{
            return nil
        }
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField){
        
        if let text = textField.text, let number = numberFormatter.number(from: text){
            
            fahrenheitValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        }
        else{
            fahrenheitValue = nil
        }
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////
    
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue{
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        }
        else{
            celsiusLabel.text = "???"
        }
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
        
        updateCelsiusLabel()
    }
  ////////////////////////////////////////////////////////////////////////////////////////////////
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
  ////////////////////////////////////////////////////////////////////////////////////////////////
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        var result = true
        let currentLocale = Locale.current
        let decimalSepatator = currentLocale.decimalSeparator ?? "."
        
        let charactersNotAllowed = NSCharacterSet.letters
        let replacementTextHasLetter = string.rangeOfCharacter(from: charactersNotAllowed)
        if replacementTextHasLetter != nil{
            
            result = false
        }

        let existingTextHaveDecimalSeparator = textField.text?.range(of: decimalSepatator)
        let replacementTextHaveDecimalSeparator = string.range(of: decimalSepatator)
        if existingTextHaveDecimalSeparator != nil, replacementTextHaveDecimalSeparator != nil{
            
            result = false
        }
        else{
            return result
        }
        
        return result
    }
    

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let userHours = dateFormatter.string(from: date)
        
        let color: UIColor
        
        if Int(userHours)! > 6 && Int(userHours)! < 18 {
            color = UIColor.white
        } else {
            
            color = UIColor.darkGray
         
        }
        self.view.backgroundColor = color
        print(userHours)
    }
    
}
