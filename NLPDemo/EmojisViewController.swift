//
//  EmojisViewController.swift
//  NLPDemo
//
//  Created by Paola Mata on 8/26/17.
//  Copyright © 2017 BuzzFeed Inc. All rights reserved.
//

import UIKit

class EmojisViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    private let nlpManager = NLPManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = "🥔 + 🌮 = ☺️"

        transformEmojisToText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func transformEmojisToText() {
        let mutableString = NSMutableString(string: textView.text)
        CFStringTransform(mutableString, nil, kCFStringTransformToUnicodeName, false)
        CFStringLowercase(mutableString, nil)

        let textString = mutableString as String
        let tokens = nlpManager.lemmatize(text: textString)

        for token in tokens {
            print(token.token)
        }
    }
}
