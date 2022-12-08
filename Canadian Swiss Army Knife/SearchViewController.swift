//
//  SearchViewController.swift
//  Canadian Swiss Army Knife
//
//  Created by Jin on 2022-12-04.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    
    let searchFields = ["", "stackoverflow.com", "github.com", "reddit.com"]
    var searchField: String {
        get {
            return searchFields[searchFieldPicker.selectedRow(inComponent: 0)]
        }
    }
    var container: NSPersistentContainer!
    var searchRecords: [SearchRecord] = []
    var selectedSearchRecordIndexPath: IndexPath?
    
    @IBOutlet weak var searchFieldPicker: UIPickerView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchHistoryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard container != nil else {
            fatalError("Persistent container is required.")
        }
        
        searchFieldPicker.delegate = self
        searchFieldPicker.dataSource = self
        
        searchHistoryTable.delegate = self
        searchHistoryTable.dataSource = self
        searchHistoryTable.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.onSearchHistoryTableLongPressed(longPressGesture:))))
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onViewTapped(tapGesture:))))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSearchRecords()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SearchResult":
            let searchResultViewController = segue.destination as! SearchResultViewController
            let searchText = searchTextField.text ?? ""
            searchResultViewController.searchText = searchText
            searchResultViewController.searchField = searchField
            createSearchRecord(searchText, searchField)
        case "SearchResultFromHistory":
            if let selectedRow = searchHistoryTable.indexPathForSelectedRow?.row,
               let searchResultViewController = segue.destination as? SearchResultViewController
            {
                let searchRecord = searchRecords[selectedRow]
                searchResultViewController.searchText = searchRecord.searchText ?? ""
                searchResultViewController.searchField = searchRecord.searchField ?? ""
            }
        default:
            preconditionFailure("Unexpected segue id")
        }
    }
    
    @objc func onSearchHistoryTableLongPressed(longPressGesture: UILongPressGestureRecognizer) {
        let positon = longPressGesture.location(in: searchHistoryTable)
        let indexPath = searchHistoryTable.indexPathForRow(at: positon)
        if let indexPath = indexPath {
            becomeFirstResponder()
            let menu = UIMenuController.shared
            let deleteMenuItem = UIMenuItem(title: LocalizedStrings.Delete, action: #selector(self.onDeleteHistory(_:)))
            menu.menuItems = [deleteMenuItem]
            menu.setTargetRect(CGRect(x: positon.x, y: positon.y, width: 2, height: 2), in: searchHistoryTable)
            menu.setMenuVisible(true, animated: true)
            selectedSearchRecordIndexPath = indexPath
        }
    }
    
    @objc func onDeleteHistory(_ sender: AnyObject) {
        if let indexPath = selectedSearchRecordIndexPath {
            container?.viewContext.delete(searchRecords[indexPath.row])
            do {
                try container?.viewContext.save()
            } catch {
                print("\(error)")
            }
            searchRecords.remove(at: indexPath.row)
            searchHistoryTable.deleteRows(at: [indexPath], with: .automatic)
            selectedSearchRecordIndexPath = nil
        }
    }
    
    @objc func onViewTapped(tapGesture: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
    }
    
    func fetchSearchRecords() {
        let searchRecordsRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchRecord")
        searchRecordsRequest.returnsObjectsAsFaults = false
        do {
            searchRecords = try container.viewContext.fetch(searchRecordsRequest) as! [SearchRecord]
        }
        catch {
            print("SearchRecords request failed.")
        }
    }
    
    func createSearchRecord(_ searchText: String, _ searchField: String) {
        let entity = NSEntityDescription.entity(forEntityName: "SearchRecord", in: container.viewContext)
        let searchRecord = NSManagedObject(entity: entity!, insertInto: container.viewContext) as? SearchRecord
        searchRecord?.setValue(searchText, forKey: "searchText")
        searchRecord?.setValue(searchField, forKey: "searchField")
    }
    
}

extension SearchViewController: UIPickerViewDelegate {
    
}

extension SearchViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchFields.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return searchFields[row]
    }
}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistory", for: indexPath)
        let searchRecord = searchRecords[indexPath.row]
        cell.textLabel?.text = searchRecord.searchText
        cell.detailTextLabel?.text = searchRecord.searchField
        return cell
    }
}
