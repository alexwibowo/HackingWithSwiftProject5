//
//  ViewController.swift
//  HwSwiftProj5
//
//  Created by Alex Wibowo on 14/9/21.
//

import UIKit

class ViewController: UITableViewController {

    var words = [String]()
    
    var guessedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
               
        if let url = Bundle.main.url(forResource: "start", withExtension: "txt")  {
            
            if let contents = try? String(contentsOf: url) {
                words = contents.components(separatedBy: "\n")
            }
        }
        
        playNext()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(reset))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(guess))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return guessedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
        cell.textLabel?.text = guessedWords[indexPath.row]
        return cell
    }
    
    @objc func reset(){
        guessedWords.removeAll()
        playNext()
    }
    
    func playNext(){
         if let randomWord = words.randomElement() {
            title = randomWord
        }
        
        tableView.reloadData()
    }
    
    @objc func guess(){
        let uac = UIAlertController(title: "Guess", message: nil, preferredStyle: .alert)
        uac.addTextField()
        
        uac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] action  in
            guard let text = uac.textFields?[0].text else { return }
            
            self?.submit(text)
        }))
        
        present(uac, animated: true)
    }
    
    func submit(_ text: String){
        let errorTitle: String
        let errorMessage: String
        
        if (isOriginal(word: text)){
            if (isReal(word: text)){
                if (isPossible(word: text)){
                    guessedWords.insert(text, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                }else{
                    errorTitle = "Word not possible"
                    errorMessage = "You cant spell that word from \(title?.lowercased())"
                }
            } else {
                errorTitle = "Word not recognized"
                errorMessage = "You cant just make up a word"
            }
        } else {
            errorTitle = "Word already used"
            errorMessage = "Please be original"
            
           
        }
        let uac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        uac.addAction(UIAlertAction(title: "OK", style: .default))
        present(uac, animated: true)
    }
    
    func isReal(word: String) -> Bool {
        let textChecker = UITextChecker()
        let result = textChecker.rangeOfMisspelledWord(in: word, range: NSRange(location: 0, length: word.utf16.count), startingAt: 0, wrap: false, language: "en")
        return result.location == NSNotFound
    }
        

    func isPossible(word: String) -> Bool {
        guard var tempword = title?.lowercased() else { return false }
        for letter in word {
            if let index = tempword.firstIndex(of: letter) {
                tempword.remove(at: index)
            } else {
                return false
            }
            
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !guessedWords.contains(word)
    }

}

