//
//  DemoTableViewController.swift
//  NLPDemo
//
//  Created by Paola Mata on 8/26/17.
//  Copyright © 2017 BuzzFeed Inc. All rights reserved.
//

import UIKit

class DemoTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Speech to Text Analysis"
        case 1:
            cell.textLabel?.text = "Part of Speech & Name Entity Identification"
        case 2:
            cell.textLabel?.text = "Lemmatization"
        case 3:
            cell.textLabel?.text = "Emojis"
        default:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var viewController: UIViewController?// = UIViewController()

        switch indexPath.row {
        case 0:
            viewController = storyboard.instantiateViewController(withIdentifier: "SpeechToText") as? SpeechRecognitionViewController
        case 1:
            viewController = storyboard.instantiateViewController(withIdentifier: "TextAnalysis") as? TextAnalysisViewController
        case 2:
            viewController = storyboard.instantiateViewController(withIdentifier: "Lemmatization") as? LemmasViewController
        case 3:
            viewController = storyboard.instantiateViewController(withIdentifier: "Emojis") as? EmojisViewController
        default:
            break
        }

        if let viewController = viewController {
           navigationController?.pushViewController(viewController, animated: true)
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
