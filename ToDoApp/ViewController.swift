//
//  MAPD 714 - Assigment 2 - ToDo List Application
//
// Name: Todo List
// Desc: To do app
// Contributors: #300964200 - Viktor Bilyk
//               #300965775 - Timofei Sopin
//
// Ver: 0.19 - Added task complete logic
// File: Main Screen View Controller handler

import UIKit
import CoreData
import CoreGraphics

class ViewController: UITableViewController, TaskViewCellDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func taskViewCellChkBoxTapped(_ sender: TaskViewCell) {
        //
        guard let tapIndexPath = tableView.indexPath(for: sender) else { return}
        selectedTaskIndex = tapIndexPath.row
        let isDone = tasksList[selectedTaskIndex!].value(forKey: "isDone") as! Bool
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        tasksList[selectedTaskIndex!].setValue(!isDone, forKey: "isDone")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Saving error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func taskViewCellEditBtnTapped(_ sender: TaskViewCell) {
        guard let tapIndexPath = tableView.indexPath(for: sender) else { return}
        selectedTaskIndex = tapIndexPath.row
        let isDone = tasksList[selectedTaskIndex!].value(forKey: "isDone") as! Bool
        if !isDone {
            selectedTask = tasksList[selectedTaskIndex!]
            self.performSegue(withIdentifier: "DisplayTaskInfo", sender: nil)
        }
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
    var categoryColor = ["Home": UIColor.blue, "Work": UIColor.brown, "Groceries": UIColor.green, "Family": UIColor.red]
    var sortByList = ["Name", "Date", "Category"]
    var selectedSortType: Int?
    
    var sortPicker = UIPickerView()
    
    @IBOutlet weak var sortItem: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortPicker.delegate = self
        sortPicker.dataSource = self
        sortItem.inputView = sortPicker
        sortItem.placeholder = "Sort by: "
        selectedSortType = -1
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.sortByList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.sortByList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sortItem.text = "Sort by: " + sortByList[row]
        selectedSortType = row
        self.sortItem.resignFirstResponder()
        sortData()
    }
    
    func sortData () {
        //
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        if (selectedSortType! != -1) {
            var sortDescriptor = NSSortDescriptor()
            
            switch selectedSortType! as Int {
            case 0:
                sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            case 1:
                sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
            case 2:
                sortDescriptor = NSSortDescriptor(key: "category", ascending: true)
            default:
                break
            }
            
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        do {
            tasksList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Fetch error: \(error)")
        }
        
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        //fetch data from db when view loads
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
        
        if (selectedSortType! != -1) {
            var sortDescriptor = NSSortDescriptor()
            
            switch selectedSortType! as Int {
            case 0:
                sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            case 1:
                sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
            case 2:
                sortDescriptor = NSSortDescriptor(key: "category", ascending: true)
            default:
                break
            }
            
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
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
        
        let date = Date()
        
        task.setValue(date, forKey: "createdAt")
        
        task.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            tasksList.append(task)
        } catch let error as NSError {
            print("Saving error: \(error)")
        }
        
    }
    
    func customDateFormat(date: Date) -> String{
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: date as Date)
        
        return dateString
    }
    
    //tableView stuff:
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as! TaskViewCell
        let isDone = tasksList[indexPath.row].value(forKey: "isDone") as! Bool
        //assign cell text
        cell.taskName.text = tasksList[indexPath.row].value(forKey: "name") as? String
        cell.taskName.textColor = isDone ? UIColor.darkGray : UIColor.black
        cell.taskCategory.backgroundColor = categoryColor[tasksList[indexPath.row].value(forKey: "category") as! String]
        cell.taskDate.text = customDateFormat(date: tasksList[indexPath.row].value(forKey: "createdAt") as! Date)
        cell.selectionStyle = .none
        cell.delegate = self
        return cell
    }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTaskIndex = indexPath.row
        let isDone = tasksList[selectedTaskIndex!].value(forKey: "isDone") as! Bool
        if !isDone {
            selectedTask = tasksList[selectedTaskIndex!]
            self.performSegue(withIdentifier: "DisplayTaskInfo", sender: nil)
        }
    }
    
    @IBAction func unwindFromDetailsVC(_ sender: UIStoryboardSegue) {
        if sender.source is DetailsViewViewController {
            if let senderVC = sender.source as? DetailsViewViewController {
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
                tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailsViewViewController
        vc.taskInfo = selectedTask
    }


}

