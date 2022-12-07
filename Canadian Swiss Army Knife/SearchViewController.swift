//
//  SearchViewController.swift
//  Canadian Swiss Army Knife
//
//  Created by Jin on 2022-12-04.
//

import UIKit

class SearchViewController: UIViewController {
    
    let searchFields = ["", "stackoverflow.com", "github.com", "reddit.com"]
    var searchField: String {
        get {
            return searchFields[searchFieldPicker.selectedRow(inComponent: 0)]
        }
    }
    
    @IBOutlet weak var searchFieldPicker: UIPickerView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    @IBAction func search(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFieldPicker.delegate = self
        searchFieldPicker.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "SearchResult":
            let searchResultViewController = segue.destination as! SearchResultViewController
            searchResultViewController.searchField = searchField
            searchResultViewController.searchText = searchTextField.text ?? ""
        default:
            preconditionFailure("Unexpected segue id")
        }
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

