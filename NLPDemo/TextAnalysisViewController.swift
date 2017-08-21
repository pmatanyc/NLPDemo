//
//  TextAnalysisViewController.swift
//  NLPDemo
//
//  Created by Paola Mata on 8/18/17.
//  Copyright © 2017 BuzzFeed Inc. All rights reserved.
//

import UIKit

class TextAnalysisViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tagSchemesSegmentedControl: UISegmentedControl!
    @IBOutlet weak var partOfSpeechSegmentedControl: UISegmentedControl!

    private let nlpManager = NLPManager()
    public var text = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        if !text.isEmpty {
            textView.text = text
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tagSchemesSegmentedControlPressed(_ sender: UISegmentedControl) {
        var taggedTokens = [TaggedToken]()

        switch sender.selectedSegmentIndex {
        case 0:
            partOfSpeechSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment
            partOfSpeechSegmentedControl.isHidden = false
        case 1:
            partOfSpeechSegmentedControl.isHidden = true
            taggedTokens = nlpManager.tagNames(text: textView.text)
            highlightTaggedText(taggedTokens: taggedTokens)
        default:
            break
        }
    }

    @IBAction func partOfSpeechSegmentedControlPressed(_ sender: UISegmentedControl) {
        var taggedTokens = [TaggedToken]()

        switch sender.selectedSegmentIndex {
        case 0:
            taggedTokens = nlpManager.partOfSpeech(text: textView.text, selectedTag: .noun)
        case 1:
            taggedTokens = nlpManager.partOfSpeech(text: textView.text, selectedTag: .verb)
        case 2:
            taggedTokens = nlpManager.partOfSpeech(text: textView.text, selectedTag: .adjective)
        case 3:
            taggedTokens = nlpManager.partOfSpeech(text: textView.text, selectedTag: .determiner)
        default:
            break
        }

        highlightTaggedText(taggedTokens: taggedTokens)
    }

    private func highlightTaggedText(taggedTokens: [TaggedToken]) {
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)]
        let attributedString = NSMutableAttributedString(string: textView.text, attributes: attributes)

        let highlightAttributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.black)]

        for taggedToken in taggedTokens {
            let range = taggedToken.tokenRange
            attributedString.addAttributes(highlightAttributes, range: range)
        }
        textView.attributedText = attributedString
    }
}
