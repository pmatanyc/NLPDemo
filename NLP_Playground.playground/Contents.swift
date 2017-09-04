//: Playground - noun: a place where people can play

import Foundation


//Language Identification
func dominantLanguage(text: String) -> String? {
    let tagger = NSLinguisticTagger(tagSchemes: [.language], options: 0)
    tagger.string = text

    return tagger.dominantLanguage
}

dominantLanguage(text: "Fuimos al cine y despues a tomar un helado.")

// Tagging tokens

typealias TaggedToken = (String, NSLinguisticTag?)

func tag(text: String, scheme: NSLinguisticTagScheme, unit: NSLinguisticTaggerUnit = .word) -> [TaggedToken] {
    let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitOther]

    let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(for: unit, language: "en"),
                                    options: Int(options.rawValue))
    tagger.string = text

    var tokens: [TaggedToken] = []

    tagger.enumerateTags(in: NSMakeRange(0, text.characters.count), unit: unit, scheme: scheme, options: options) { tag, tokenRange, _ in
        guard let tag = tag else { return }
        let token = (text as NSString).substring(with: tokenRange)

        print("{token: \(token), tag: \(tag.rawValue), range: \(tokenRange)} \n")

        tokens.append((token, tag))
    }
    return tokens
}

// Helper methods
func partOfSpeech(text: String) -> [TaggedToken] {
    return tag(text: text, scheme: .lexicalClass)
}

func lemmatize(text: String) -> [TaggedToken] {
    return tag(text: text, scheme: .lemma)
}

func language(text: String) -> [TaggedToken] {
    return tag(text: text, scheme: .language, unit: .sentence)
}

tag(text: "Yes, I ate all the tacos!", scheme: .lexicalClass, unit: .word)

//Name Entity Identification

func tagNames(text: String) -> [TaggedToken] {
    let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)

    tagger.string = text

    let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
    let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]

    var tokens: [TaggedToken] = []
    tagger.enumerateTags(in: NSMakeRange(0, text.characters.count), unit: .word, scheme: .nameType, options: options) { tag, tokenRange, _ in
        // Make sure that the tag that was found is in the list of tags that we care about.
        guard let tag = tag, tags.contains(tag) else { return }

        let token = (text as NSString).substring(with: tokenRange)
        print("{token: \(token), tag: \(tag.rawValue), range: \(tokenRange)}\n")

        tokens.append((token, tag))
    }
    return tokens
}

tagNames(text: "This year, Apple held WWDC at San Jose, CA. Michelle Obama was a surprise guest speaker.")

