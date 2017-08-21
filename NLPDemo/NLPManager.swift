//
//  NLPManager.swift
//  NLPDemo
//
//  Created by Paola Mata on 8/18/17.
//  Copyright © 2017 BuzzFeed Inc. All rights reserved.
//

import Foundation

typealias TaggedToken = (token: String, tag: NSLinguisticTag?, tokenRange: NSRange)

class NLPManager {
    private func tag(text: String, scheme: NSLinguisticTagScheme, unit: NSLinguisticTaggerUnit = .word) -> [TaggedToken] {
        let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(for: unit, language: "en"),
                                        options: 0)
        tagger.string = text

        let range = NSMakeRange(0, text.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitOther]

        var taggedTokens: [TaggedToken] = []

        tagger.enumerateTags(in: range, unit: unit, scheme: scheme, options: options) { tag, tokenRange, _ in
            guard let tag = tag else { return }

            let token = (text as NSString).substring(with: tokenRange)
            taggedTokens.append((token, tag, tokenRange))
        }
        return taggedTokens
    }

    // Helpers

    func partOfSpeech(text: String, selectedTag: NSLinguisticTag) ->[TaggedToken] {
        let taggedTokens = tag(text: text, scheme: .lexicalClass)
        return taggedTokens.filter { $0.tag == selectedTag }
    }

    func lemmatize(text: String) -> [TaggedToken] {
        return tag(text: text, scheme: .lemma)
    }

    func lemmatizeSingleWord(text: String) -> [TaggedToken] {
        let newText = "please show me \(text)"

        return tag(text: newText, scheme: .lemma)
    }

    // Name Entity Identification

    func tagNames(text: String) -> [TaggedToken] {
        let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)

        tagger.string = text

        let range = NSMakeRange(0, text.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]

        let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
        var taggedTokens: [TaggedToken] = []

        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, _ in
            // Make sure that the tag that was found is in the list of tags that we care about.
            guard let tag = tag, tags.contains(tag) else { return }

            let token = (text as NSString).substring(with: tokenRange)
            taggedTokens.append((token, tag, tokenRange))
        }
        return taggedTokens
    }
}
