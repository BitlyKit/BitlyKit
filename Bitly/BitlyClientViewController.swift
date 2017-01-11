//
//  BitlyClientViewController.swift
//  Bitly
//
//  Created by Brennan Stehling on 1/4/17.
//  Copyright © 2017 SmallSharpTools LLC. All rights reserved.
//

import UIKit
import BitlyKit

let UserDefaultUsername = "username"
let UserDefaultApiKey = "apiKey"
let UserDefaultAccessToken = "accessToken"
let UserDefaultURL = "url"

class BitlyClientViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var apiKeyTextField: UITextField!
    @IBOutlet weak var accessTokenTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var shortenURLButton: UIButton!
    @IBOutlet weak var shortenedURLLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        shortenedURLLabel.text = nil
        loadSettings()
    }

    @IBAction func shortenURLButtonTapped(_ sender: Any) {
        guard let urlString = urlTextField.text else {
            return
        }

        // dismiss keyboard
        view.endEditing(true)
        saveSettings()

        let url = URL(string: urlString)
        _ = BitlyClient.shorten(url: url, accessToken: accessTokenTextField.text) {
            [weak self] (url, error) in
            if let error = error {
                debugPrint("Error: \(error.localizedDescription)")
            }
            else if let url = url {
                debugPrint("URL: \(url.absoluteString)")
                guard let label = self?.shortenedURLLabel else {
                    fatalError()
                }
                label.text = url.absoluteString
            }
        }
    }

    // MARK: - Private Methods -

    private func loadSettings() {
        usernameTextField.text = UserDefaults.standard.object(forKey: UserDefaultUsername) as? String
        apiKeyTextField.text = UserDefaults.standard.object(forKey: UserDefaultApiKey) as? String
        accessTokenTextField.text = UserDefaults.standard.object(forKey: UserDefaultAccessToken) as? String
        urlTextField.text = UserDefaults.standard.object(forKey: UserDefaultURL) as? String
    }

    private func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(usernameTextField.text ?? "", forKey: UserDefaultUsername)
        defaults.set(apiKeyTextField.text ?? "", forKey: UserDefaultApiKey)
        defaults.set(accessTokenTextField.text ?? "", forKey: UserDefaultAccessToken)
        defaults.set(urlTextField.text ?? "", forKey: UserDefaultURL)
        defaults.synchronize()
    }

}

