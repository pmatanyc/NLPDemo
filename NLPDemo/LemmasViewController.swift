//
//  LemmasViewController.swift
//  NLPDemo
//
//  Created by Paola Mata on 8/19/17.
//  Copyright © 2017 BuzzFeed Inc. All rights reserved.
//

import UIKit

class LemmasViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var textView: UITextView!

    private let nlpManager = NLPManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        if
            let searchTerm = searchBar.text,
            let taggedSearchTerm = nlpManager.lemmatizeSingleWord(text: searchTerm).last
        {
            let taggedText = nlpManager.lemmatize(text: textView.text)
            let matches = taggedText.filter { $0.tag == taggedSearchTerm.tag }
            highlightMatches(taggedTokens: matches)
        }
    }

    private func highlightMatches(taggedTokens: [TaggedToken]) {
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)]
        let attributedString = NSMutableAttributedString(string: textView.text, attributes: attributes)

        let highlightAttributes = [NSAttributedStringKey.backgroundColor : UIColor.cyan]

        for taggedToken in taggedTokens {
            let range = taggedToken.tokenRange
            attributedString.addAttributes(highlightAttributes, range: range)
        }
        textView.attributedText = attributedString
    }
}
