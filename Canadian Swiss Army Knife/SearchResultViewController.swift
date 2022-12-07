//
//  SearchResultViewController.swift
//  Canadian Swiss Army Knife
//
//  Created by Jin on 2022-12-06.
//

import UIKit
import WebKit

class SearchResultViewController: UIViewController {
    
    var searchText = ""
    var searchField = ""
    var searchUrl = ""
    
    var searchTextEncoded: String {
        get {
            return searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        }
    }
    var searchFieldEncoded: String {
        get {
            return searchField.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        }
    }
    
    @IBOutlet weak var searchResultWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let newSearchUrl = getSearchUrl()
        if newSearchUrl != searchUrl {
            searchResultWebView.load(URLRequest(url: URL(string: newSearchUrl)!))
            searchUrl = newSearchUrl
        }
    }
    
    func getSearchUrl() -> String {
        var url = "https://www.google.com/search?q="
        if searchFieldEncoded.count > 0 {
            url += "site%3A\(searchFieldEncoded)+"
        }
        url += "\(searchTextEncoded)"
        return url
    }
    
}
