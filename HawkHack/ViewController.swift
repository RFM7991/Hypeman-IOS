//
//  ViewController.swift
//  HawkHack
//
//  Created by Robert Francisco McPherson on 3/30/19.
//  Copyright © 2019 Robert Francisco McPherson. All rights reserved.
//

import UIKit
import Foundation
import youtube_ios_player_helper

class ViewController: UIViewController {

    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var root_button: UIButton!
    @IBOutlet weak var more_button: UIButton!
    @IBOutlet weak var bottom_button: UIButton!
    @IBOutlet weak var right_button: UIButton!
    @IBOutlet weak var left_button: UIButton!
    @IBOutlet weak var youtubePlayer: YTPlayerView!
    @IBOutlet weak var preview_button: UIButton!
    
    var myVar: MyVariables? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        myVar = MyVariables()
        callURLAPI(path: "https://api.jsonbin.io/b/5c40ab4a7b31f426f85b4cb1")
 
        // youtube player
        var playerVars : [String: Any] = [:]
        playerVars["playsinline"] = 1
        playerVars["controls"] = 1
        
        youtubePlayer.load(withPlaylistId: "PL6eBorfLzavmm5QkhSC4yF6HXNufPGKBC", playerVars: playerVars)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackground() {
        let gradient = CAGradientLayer()
        gradient.frame = backgroundView.bounds
        let startColor = UIColor(red:0.19, green:0.38, blue:0.59, alpha:1.0)
        let endColor = UIColor(red:0.26, green:0.26, blue:0.26, alpha:1.0)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        backgroundView.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func pressRoots(_ sender: UIButton) {
        
        if (myVar?.rhymes_loaded)! {
            
            var roots  = myVar?.loaded_roots
            let cRoot = roots?[(myVar?.rootIndex)!]
            myVar?.currentRoot = cRoot
            
            // set root pool
            var lyricPool = (myVar?.loaded_rhymes[cRoot!])
            lyricPool = shuffleList(arr: lyricPool!)
            myVar?.lyricPool = lyricPool!
            
            // if a preview is available, set root to last preview, else set to last element of pool
            var rootRhyme = "";
            if (myVar?.rootsInitPressed)! {
                rootRhyme = (myVar?.rootPreview)!
            }else {
                rootRhyme = (myVar?.lyricPool.popLast())!
            }
            let leftRhyme = myVar?.lyricPool.popLast()
            let bottomRhyme = myVar?.lyricPool.popLast()
            let rightRhyme = myVar?.lyricPool.popLast()
                
                // change root title
                root_button.setTitle(rootRhyme, for: .normal)
                // change left button to first rhyme
                left_button.setTitle(leftRhyme, for: .normal)
                // change bottom button to second rhyme
                bottom_button.setTitle(bottomRhyme, for: .normal)
                // change left button to third rhyme
                right_button.setTitle(rightRhyme, for: .normal)
                
                updateRootList()
            
                // button not yet pressed
            if (!(myVar?.rootsInitPressed)!) {
                myVar?.rootsInitPressed = true;
            }
            
        }
    }
    
    func updateRootList() {
        var index  = myVar?.rootIndex
        var roots = myVar?.loaded_roots
        
        // if we've reached end of list, reset index
        if ((myVar?.rootIndex)! < ((myVar?.loaded_roots.count)!  - 1)) {
            index = (index)! + 1
            
            // set preview to last element of next pool
            let nRoot = roots?[(index)!]
            let preview = myVar?.loaded_rhymes[nRoot!]?.popLast()
            myVar?.rootPreview = preview
            preview_button.setTitle(preview, for: .normal)
        }
        else {
            index = 0;
            // randomize words
            roots = shuffleList(arr: roots!)
            // set global roots
            myVar?.loaded_roots = roots!
        
        }
        // set global index
        myVar?.rootIndex = index
    }
    
    func shuffleList(arr: [String]) -> [String] {
        var shuffled = [String]()
        var list = arr
        for (_) in list {
            let rand = arc4random_uniform(UInt32(list.count))
            shuffled.append(list[Int(rand)])
            list.remove(at: Int(rand))
        }
        return shuffled
    }
    
    func shuffleMap(map: [String: String]) -> [String: String] {
        var shuffled = [String:String]()
        let keys = map.keys
        var keyArray = [String]()
        
        // load keys into an array
        for (key) in keys {
            keyArray.append(key)
        }
        
        // shuffle with keyArray
        for (key) in keyArray {
            let rand = arc4random_uniform(UInt32(keyArray.count))
            shuffled[key] = map[key]
            keyArray.remove(at: Int(rand))
        }
        return shuffled
    }

    
    @IBAction func pressMore(_ sender: UIButton) {
        print("More")
    //    print(myVar?.lyricPool)
        
        // if root button initialized
        if (myVar?.rootsInitPressed)! {
            let leftRhyme = myVar?.lyricPool.popLast()
            let bottomRhyme = myVar?.lyricPool.popLast()
            let rightRhyme = myVar?.lyricPool.popLast()
            
            
            // if a rhyme is available, change label, else press root button
            if (leftRhyme != nil && bottomRhyme != nil && rightRhyme != nil) {
                left_button.setTitle(leftRhyme, for: .normal)
                bottom_button.setTitle(bottomRhyme, for: .normal)
                right_button.setTitle(rightRhyme, for: .normal)
            } else {
                pressRoots(root_button)
            }
        }
    }
    
    @IBAction func pressRight(_ sender: UIButton) {
        print("right")
        // if root button initialized
        if (myVar?.rootsInitPressed)! {
            let rhyme = myVar?.lyricPool.popLast()
            
            // if a rhyme is available, change label, else press root button
            if (rhyme != nil) {
                right_button.setTitle(rhyme, for: .normal)
            } else {
                pressRoots(root_button)
            }
        }
    }
    
    @IBAction func pressLeft(_ sender: UIButton) {
        print("left")
        // if root button initialized
        if (myVar?.rootsInitPressed)! {
            let rhyme = myVar?.lyricPool.popLast()
            // if a rhyme is available, change label, else press root button
            if (rhyme != nil) {
                left_button.setTitle(rhyme, for: .normal)
            } else {
                pressRoots(root_button)
            }
        }
    }
    
    @IBAction func pressBottom(_ sender: UIButton) {
        print("bottom")
        // if root button initialized
        if (myVar?.rootsInitPressed)! {
            let rhyme = myVar?.lyricPool.popLast()
            // if a rhyme is available, change label, else press root button
            if (rhyme != nil) {
                bottom_button.setTitle(rhyme, for: .normal)
            } else {
                pressRoots(root_button)
            }
        }
    }
    
    // call api for root rhymes
    func callRhymeAPI(root: String, path: String) {
        let url = URL(string: path)
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.httpMethod = "GET"
            request.setValue("$2a$10$EPfJXSb9ngHBmHphdZ8Zfuk0YzPduXaA9LaGPAuuzjYFDgAKrIZ3S", forHTTPHeaderField: "secret-key")
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [Any] {
                        
                       print("Calling RHYME API", root, path)
                    
               //         print(object as? [[String: Any]] as Any)
                        self.myVar?.rhyme_map = object as? [[String: Any]]
                        self.loadRhymes(root: root)
                    } else {
                        print("JSON is invalid")
                    }
             //       }
                }
            })
            task.resume()
        }
    }
    
    // cal api for urls
    func callURLAPI(path: String) {
        let url = URL(string: path)
        if let usableUrl = url {
            var request = URLRequest(url: usableUrl)
            request.httpMethod = "GET"
            request.setValue("$2a$10$EPfJXSb9ngHBmHphdZ8Zfuk0YzPduXaA9LaGPAuuzjYFDgAKrIZ3S", forHTTPHeaderField: "secret-key")
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [Any] {
                        // if request returns JSON
              //          print(object as? [[String: Any]] as Any)
                        self.myVar?.root_urls = object as? [[String: String]]
                        self.loadRoots()
                    } else {
                        print("JSON is invalid")
                    }
                    //       }
                }
            })
            task.resume()
        }
    }
    // all paths seem to point to "weed"
    func loadRhymes(root: String) {
        print("load rhymes")
        
        // add roots to global list
        myVar?.loaded_roots.append(root)
        
        let rhymeMap = myVar?.rhyme_map
        print("myVar.rhymemap")
    //    print(rhymeMap)
        var words : [String] = []
        
        for (key_pair) in rhymeMap! {
            words.append(key_pair["word"]! as! String)
        }
 //       print("root is", root)
  //      print("rhymes are: ", words)
        // add rhyme list to global list
       myVar?.loaded_rhymes[root] = words
        
        // are all rhymes loaded? - enable pressRoot
       if (myVar?.loaded_rhymes.count == myVar?.loaded_roots.count) {
            myVar?.rhymes_loaded = true
        }
    }
    
    // makes calles to get rhymes using inital url fetch
    func loadRoots() {
        print("load roots")
        let url_json = myVar?.root_urls
        var rootMap = [String: String]()
        
   ///     print("RFM", url_json)
        
        // for each json object in json array
        for (key_pair) in url_json! {
            // append urls to list
            let path = key_pair["url"]!
            
            // append roots to global list
            let word = key_pair["root"]!
            
            //add to dict
            rootMap[word] = path
        }
        
        // set global root Index to 0
        myVar?.rootIndex = 0;
        
        // shuffle root map
        rootMap = shuffleMap(map: rootMap)
            
        // prepare call to get rhymes
        initRhymeLoad(map: rootMap)
    }
    
    func initRhymeLoad(map: [String:String]) {

    //    print(paths?.last())
        for (key_pair) in map {
     //       print(key_pair.key, ": " + key_pair.value)
            callRhymeAPI(root: key_pair.key, path: key_pair.value)
        }
    }
    
    struct MyVariables {
        // raw JSON
        var root_urls : [[String: String]]?
        var rhyme_map : [[String: Any]]?
        
        // parsed JSON
        var loaded_roots : [String] = []
        var loaded_rhymes = [String: [String]]()
        
        // indices
        var rootIndex : Int?
        
        // current root
        var currentRoot : String?
        
        // root preview
        var rootPreview : String?
        
        
        // lyric pool
        var lyricPool : [String] = []
        
        // bools
        var rhymes_loaded : Bool = false
        var rootsInitPressed: Bool = false
    }
    
}
