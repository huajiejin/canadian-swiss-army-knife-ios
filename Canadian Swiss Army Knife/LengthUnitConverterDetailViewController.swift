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
    var selectedUnitConversionRecordIndexPath: IndexPath?
    
    @IBAction func cmEditingDidEnd(_ sender: Any) {
        length = Measurement(value: textToDouble(lengthInCentimetersTextField.text), unit: .centimeters)
        lengthInInchesTextField.text = "\(lengthInInches)"
        createUnitConversionRecord("\(lengthInCentimeters)", "cm", "\(lengthInInches)", LocalizedStrings.inch)
    }
    
    @IBAction func inchEditingDidEnd(_ sender: Any) {
        length = Measurement(value: textToDouble(lengthInInchesTextField.text), unit: .inches)
        lengthInCentimetersTextField.text = "\(lengthInCentimeters)"
        createUnitConversionRecord("\(lengthInInches)", LocalizedStrings.inch, "\(lengthInCentimeters)", "cm")
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
        unitConversionHistoryTable.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.onUnitConversionHistoryTableLongPressed(longPressGesture:))))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onViewTapped(tapGesture:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUnitConversionRecords()
    }
    
    @objc func onUnitConversionHistoryTableLongPressed(longPressGesture: UILongPressGestureRecognizer) {
        let positon = longPressGesture.location(in: unitConversionHistoryTable)
        let indexPath = unitConversionHistoryTable.indexPathForRow(at: positon)
        showDeleteHistoryMenu(positon, indexPath)
    }
    
    @objc func onDeleteHistory(_ sender: AnyObject) {
        if let indexPath = selectedUnitConversionRecordIndexPath {
            container?.viewContext.delete(unitConversionRecords[indexPath.row])
            do {
                try container?.viewContext.save()
            } catch {
                print("\(error)")
            }
            unitConversionRecords.remove(at: indexPath.row)
            unitConversionHistoryTable.deleteRows(at: [indexPath], with: .automatic)
            selectedUnitConversionRecordIndexPath = nil
        }
    }
    
    @objc func onViewTapped(tapGesture: UITapGestureRecognizer) {
        lengthInCentimetersTextField.resignFirstResponder()
        lengthInInchesTextField.resignFirstResponder()
    }
    
    func showDeleteHistoryMenu(_ positon: CGPoint, _ indexPath: IndexPath?) {
        if let indexPath = indexPath {
            becomeFirstResponder()
            let menu = UIMenuController.shared
            let deleteMenuItem = UIMenuItem(title: LocalizedStrings.Delete, action: #selector(self.onDeleteHistory(_:)))
            menu.menuItems = [deleteMenuItem]
            menu.setTargetRect(CGRect(x: positon.x, y: positon.y, width: 2, height: 2), in: unitConversionHistoryTable)
            menu.setMenuVisible(true, animated: true)
            selectedUnitConversionRecordIndexPath = indexPath
        }
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
    
    func textToDouble(_ text: String?) -> Double {
        let decimalSeparator = NSLocale.current.decimalSeparator! as String
        return Double((text ?? "").replacingOccurrences(of: decimalSeparator, with: ".")) ?? 0
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
