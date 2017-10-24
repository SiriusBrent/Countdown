//
//  ViewController.swift
//  Countdown
//
//  Created by Brent on 2017-10-02.
//  Copyright © 2017 Brent Marykuca. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell
{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var duration: UILabel!
}

class TableViewController: UITableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Identifier") as? TableCell
        {
            cell.title.text = "Title"
            cell.duration.text = "\(indexPath)"
            return cell
        }
        fatalError()
    }
    
}

