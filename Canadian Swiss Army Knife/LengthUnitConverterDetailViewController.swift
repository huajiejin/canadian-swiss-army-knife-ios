//
//  LengthUnitConverterDetailViewController.swift
//  Canadian Swiss Army Knife
//
//  Created by Jin on 2022-12-07.
//

import UIKit
import CoreData

class LengthUnitConverterDetailViewController: UIViewController {
    
    @IBOutlet weak var lengthInCentimetersTextField: UITextField!
    @IBOutlet weak var lengthInInchesTextField: UITextField!
    @IBOutlet weak var unitConversionHistoryTable: UITableView!
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var unitConversionRecords: [UnitConversionRecord] = []
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
        createUnitConversionRecord("\(lengthInCentimeters)", "cm", "\(lengthInInches)", "inch")
    }
    
    @IBAction func inchEditingDidEnd(_ sender: Any) {
        length = Measurement(value: Double(lengthInInchesTextField.text ?? "") ?? 0, unit: .inches)
        lengthInCentimetersTextField.text = "\(lengthInCentimeters)"
        createUnitConversionRecord("\(lengthInInches)", "inch", "\(lengthInCentimeters)", "cm")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard container != nil else {
            fatalError("Persistent container is required.")
        }
        
        lengthInCentimetersTextField.delegate = self
        lengthInInchesTextField.delegate = self
        
        unitConversionHistoryTable.delegate = self
        unitConversionHistoryTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUnitConversionRecords()
    }

    func fetchUnitConversionRecords() {
        guard let viewContext = container?.viewContext else { return }
        let unitConversionRecordsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UnitConversionRecord")
        unitConversionRecordsRequest.returnsObjectsAsFaults = false
        do {
            unitConversionRecords = try viewContext.fetch(unitConversionRecordsRequest) as! [UnitConversionRecord]
        }
        catch {
            print("SearchRecords request failed.")
        }
    }
    
    func createUnitConversionRecord(_ originValue: String, _ originUnit: String, _ targetValue: String, _ targetUnit: String) {
        guard let viewContext = container?.viewContext else { return }
        let entity = NSEntityDescription.entity(forEntityName: "UnitConversionRecord", in: viewContext)
        let unitConversionRecord = NSManagedObject(entity: entity!, insertInto: viewContext) as? UnitConversionRecord
        unitConversionRecord?.setValue(originValue, forKey: "originValue")
        unitConversionRecord?.setValue(originUnit, forKey: "originUnit")
        unitConversionRecord?.setValue(targetValue, forKey: "targetValue")
        unitConversionRecord?.setValue(targetUnit, forKey: "targetUnit")
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

extension LengthUnitConverterDetailViewController: UITableViewDelegate {
    
}

extension LengthUnitConverterDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        unitConversionRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnitConversionHistory", for: indexPath)
        let unitConversionRecord = unitConversionRecords[indexPath.row]
        cell.textLabel?.text = (unitConversionRecord.originValue ?? "") + (unitConversionRecord.originUnit ?? "")
        cell.detailTextLabel?.text = (unitConversionRecord.targetValue ?? "") + (unitConversionRecord.targetUnit ?? "")
        return cell
    }
}
