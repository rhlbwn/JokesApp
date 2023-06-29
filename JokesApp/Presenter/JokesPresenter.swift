//
//  JokesPresenter.swift
//  JokesApp
//
//  Created by Rahul Bawane on 29/06/23.
//

import UIKit
import Foundation

protocol JokesDelegate {
    func reloadUI()
}

typealias JokesPresenterDelegate = JokesDelegate & UIViewController

class JokesPresenter {
    var delegate: JokesDelegate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var jokes = [Joke]()
    
    public func setViewDelegate(delegate: JokesPresenterDelegate) {
        self.delegate = delegate
    }
    
    //MARK: - Data Source
    public func getRowCount() -> Int {
        return self.jokes.count
    }
    
    public func getJoke(index: Int) -> String {
        return self.jokes[index].joke ?? ""
    }
    
    //MARK: - API Calls
    public func getJokes() {
        guard let url = URL(string: "https://geek-jokes.sameerkumar.website/api") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let jokes = String(data: data, encoding: .utf8)
                if self.jokes.count >= 10 {
                    if let firstJoke = self.jokes.first {
                        self.deleteJoke(joke: firstJoke)
                    }
                }
                self.createJoke(joke: jokes ?? "")
            }
        }
        task.resume()
    }
    
    //MARK: - Core Data
    public func getLocalJokes() {
        do {
            jokes = try context.fetch(Joke.fetchRequest())
            self.delegate?.reloadUI()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func createJoke(joke: String) {
        let newJoke = Joke(context: context)
        newJoke.joke = joke
        self.saveContext()
    }
    
    public func deleteJoke(joke: Joke) {
        context.delete(joke)
    }
    
    public func saveContext() {
        do {
            try context.save()
            self.getLocalJokes()
        } catch {
            print(error.localizedDescription)
        }
    }
}
