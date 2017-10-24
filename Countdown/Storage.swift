//
//  Storage.swift
//  Countdown
//
//  Created by Brent on 2017-10-04.
//  Copyright © 2017 Brent Marykuca. All rights reserved.
//

import Foundation

struct EventItem : Codable
{
    let name: String
    let date: Date
    
    init(name: String, date: Date)
    {
        self.name = name
        self.date = date
    }
}

class Storage : Codable
{
    var items: [EventItem] = []
    
    init()
    {
        let url = URL(URL.userDocumentsFolder, child: "Storage.json")
        print(url)
        do {
            let jsonData = try Data(contentsOf: url)//url.data(using: .utf8)
            items = try JSONDecoder().decode([EventItem].self, from: jsonData)
        }
        catch {
            print("Error")
        }
    }
    
    deinit {
        let url = URL(URL.userDocumentsFolder, child: "Storage.json")
        do {
            //let jsonData = try Data(contentsOf: url)//url.data(using: .utf8)
            //items = try JSONDecoder().decode([EventItem].self, from: jsonData)
            let result = try JSONEncoder().encode(items)
            try url.encode(to: <#T##Encoder#>)
        }
        catch {
            print("Error")
        }

}
    
    func addEvent(_ event: EventItem)
    {
        items.append(event)
    }
    
    func deleteEvent(index: Int)
    {
        assert(index < items.count)
        
        items.remove(at: index)
    }
}
