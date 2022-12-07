//
//  LengthUnitConverterDetailViewController.swift
//  Canadian Swiss Army Knife
//
//  Created by Jin on 2022-12-07.
//

import UIKit

class LengthUnitConverterDetailViewController: UIViewController {
    
    @IBOutlet weak var lengthInCentimetersTextField: UITextField!
    @IBOutlet weak var lengthInInchesTextField: UITextField!
    
    var length: Measurement<UnitLength> = Measurement(value: 0, unit: .centimeters)
    var lengthInCentimeters: Double {
        get {
            return length.converted(to: .centimeters).value
        }
    }
    var lengthInInches: Double {
        get {
            return length.converted(to: .inches).value
        }
    }
    
    @IBAction func cmEditingDidEnd(_ sender: Any) {
        length = Measurement(value: Double(lengthInCentimetersTextField.text ?? "") ?? 0, unit: .centimeters)
        lengthInInchesTextField.text = "\(lengthInInches)"
    }
    
    @IBAction func inchEditingDidEnd(_ sender: Any) {
        length = Measurement(value: Double(lengthInInchesTextField.text ?? "") ?? 0, unit: .inches)
        lengthInCentimetersTextField.text = "\(lengthInCentimeters)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lengthInCentimetersTextField.delegate = self
        lengthInInchesTextField.delegate = self
    }
}

extension LengthUnitConverterDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let decimalSeparator = NSLocale.current.decimalSeparator! as String
        let separatorExists = textField.text?.range(of: decimalSeparator) != nil
        let separatorExistsInString = string.range(of: decimalSeparator) != nil
        return !(separatorExists && separatorExistsInString)
    }
}
