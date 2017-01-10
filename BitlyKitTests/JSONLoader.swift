//
//  JSONLoader.swift
//  Bitly
//
//  Created by Brennan Stehling on 1/9/17.
//  Copyright © 2017 SmallSharpTools LLC. All rights reserved.
//

import Foundation

class JSONLoader: NSObject {

    static let sharedInstance: JSONLoader = JSONLoader()

    func loadJSON(name: String) -> Any? {
        let data = loadData(name: name)

        if let data = data {
            return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        }

        return nil
    }

    func loadData(name: String) -> Data? {
        let bundle = Bundle(for: classForCoder)
        guard let path = bundle.path(forResource: name, ofType: "json") else {
            return nil
        }
        let fm = FileManager.default
        if fm.isReadableFile(atPath: path) {
            guard let data = fm.contents(atPath: path) else {
                return nil
            }

            return data
        }
        
        return nil
    }

}
