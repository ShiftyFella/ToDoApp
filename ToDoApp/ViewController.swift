//
//  MAPD 714 - Assigment 2 - ToDo List Application
//
// Name: Todo List
// Desc: To do app
// Contributors: #300964200 - Viktor Bilyk
//               #300965775 - Timofei Sopin
//
// Ver: 0.12 - Added saving and display of data from CoreData DB
// File: Main Screen View Controller handler

import UIKit
import CoreData

class ViewController: UITableViewController {

    var tasksList: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //fetch data from db when view loads
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        do {
            tasksList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetch error: \(error)")
        }
    }

    @IBAction func addTask(_ sender: UIBarButtonItem) {
        //Create pop-up modal to enter new task name
        
        let alert = UIAlertController(title: "To Do Task",
                                      message: "Add new task",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Add",
                                       style: .default) {
                                        //get value from text field inside pop-up modal and save it
                                        [weak self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let nameOfTask = textField.text else {
                                                return
                                        }
                                        
                                        self?.saveTask(name: nameOfTask)
                                        self?.tableView.reloadData()

                                        
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
    
    func saveTask(name: String) {
        //save task to DB
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
        
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        task.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            tasksList.append(task)
        } catch let error as NSError {
            print("Saving error: \(error)")
        }
        
    }
    
    //tableView stuff:
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        //assign cell text
        cell.textLabel?.text = tasksList[indexPath.row].value(forKey: "name") as? String
        return cell
    }


}

