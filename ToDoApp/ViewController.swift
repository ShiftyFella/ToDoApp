//
//  MAPD 714 - Assigment 2 - ToDo List Application
//
// Name: Todo List
// Desc: To do app
// Contributors: #300964200 - Viktor Bilyk
//               #300965775 - Timofei Sopin
//
// Ver: 0.1 - Basic Set Up
// File: Main Screen View Controller handler

import UIKit
import CoreData

class ViewController: UITableViewController {

    var tasksList = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func addTask(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "To Do Task",
                                      message: "Add new task",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Add",
                                       style: .default) {
                                        [weak self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameOfTask = textField.text else {
                                                return
                                        }
                                        
                                        //add task to tasks
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tasksList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        //assign cell text
        return cell
    }


}

