//
//  MAPD 714 - Assigment 2 - ToDo List Application
//
// Name: Todo List
// Desc: To do app
// Contributors: #300964200 - Viktor Bilyk
//               #300965775 - Timofei Sopin
//
// Ver: 0.13 - Added handling and recieving of data
// File: Details Screen View Controller handler


import UIKit
import CoreData

class DetailsViewViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categoryList.count
    }
    
    var taskInfo: NSManagedObject?
    var action_type: String!
    var categoryList = ["Home", "Work", "Groceries", "Family"]

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskNote: UITextView!
    @IBOutlet weak var taskCategory: UITextField!
    var taskCategoryPicker = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()

        taskName.text = taskInfo?.value(forKey: "name") as? String
        taskNote.text = taskInfo?.value(forKey: "note") as? String
        taskCategory.text = taskInfo?.value(forKey: "category") as? String
        
        taskCategoryPicker.delegate = self
        taskCategoryPicker.dataSource = self
        
        taskCategory.inputView = taskCategoryPicker
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        let actionBtn = sender as? UIBarButtonItem
        if (actionBtn?.title == "Save") {
            taskInfo?.setValue(taskName.text, forKey: "name")
            taskInfo?.setValue(taskNote.text, forKey: "note")
            taskInfo?.setValue(taskCategory.text, forKey: "category")
            action_type = "Save"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.taskCategory.text = categoryList[row]
        self.taskCategory.resignFirstResponder()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
