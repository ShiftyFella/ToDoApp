//
//  MAPD 714 - Assigment 2 - ToDo List Application
//
// Name: Todo List
// Desc: To do app
// Contributors: #300964200 - Viktor Bilyk
//               #300965775 - Timofei Sopin
//
// Ver: 0.17 - Added Custom Cell Edit and Delete action handlers
// File: Main Screen View Controller handler

import UIKit
import CoreData

class ViewController: UITableViewController, TaskViewCellDelegate {
    func taskViewCellChkBoxTapped(_ sender: TaskViewCell) {
        //
    }
    
    func taskViewCellEditBtnTapped(_ sender: TaskViewCell) {
        guard let tapIndexPath = tableView.indexPath(for: sender) else { return}
        
        selectedTask = tasksList[tapIndexPath.row]
        selectedTaskIndex = tapIndexPath.row
        self.performSegue(withIdentifier: "DisplayTaskInfo", sender: nil)
    }
    
    func taskViewCellDelBtnTapped(_ sender: TaskViewCell) {
        guard let tapIndexPath = tableView.indexPath(for: sender) else { return}
        selectedTaskIndex = tapIndexPath.row
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(tasksList[selectedTaskIndex!])
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Saving error: \(error)")
        }
        tasksList.remove(at: selectedTaskIndex!)
        
        tableView.reloadData()
    }
    

    var tasksList: [NSManagedObject] = []
    
    var selectedTask = NSManagedObject()
    
    var selectedTaskIndex: Int?
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! TaskViewCell
        //assign cell text
        cell.taskName.text = tasksList[indexPath.row].value(forKey: "name") as? String
        cell.delegate = self
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTask = tasksList[indexPath.row]
        selectedTaskIndex = indexPath.row
        self.performSegue(withIdentifier: "DisplayTaskInfo", sender: nil)
    }
    
    @IBAction func unwindFromDetailsVC(_ sender: UIStoryboardSegue) {
        if sender.source is DetailsViewViewController {
            if let senderVC = sender.source as? DetailsViewViewController {
                if senderVC.action_type == "Delete" {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    
                    let managedContext = appDelegate.persistentContainer.viewContext
                    
                    managedContext.delete(tasksList[selectedTaskIndex!])
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Saving error: \(error)")
                    }
                    tasksList.remove(at: selectedTaskIndex!)
                    
                }
                if senderVC.action_type == "Save" {
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    
                    let managedContext = appDelegate.persistentContainer.viewContext
                    
                    tasksList[selectedTaskIndex!] = senderVC.taskInfo!
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Saving error: \(error)")
                    }
                    
                }
            }
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailsViewViewController
        vc.taskInfo = selectedTask
    }


}

