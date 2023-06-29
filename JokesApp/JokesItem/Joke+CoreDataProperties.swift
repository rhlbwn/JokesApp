//
//  Jokes+CoreDataProperties.swift
//  JokesApp
//
//  Created by Rahul Bawane on 29/06/23.
//
//

import Foundation
import CoreData


extension Joke {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Joke> {
        return NSFetchRequest<Joke>(entityName: "Joke")
    }

    @NSManaged public var joke: String?

}

extension Joke : Identifiable {

}
