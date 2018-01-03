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

class DetailsViewViewController: UIViewController {
    
    var taskInfo: NSManagedObject?
    var action_type: String!

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var taskNote: UITextView!
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        taskInfo?.setValue(taskName.text, forKey: "name")
        taskInfo?.setValue(taskNote.text, forKey: "note")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        taskName.text = taskInfo?.value(forKey: "name") as? String
        taskNote.text = taskInfo?.value(forKey: "note") as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    @IBAction func updateTask(_ sender: UIButton) {
//        taskInfo?.setValue(taskName.text, forKey: "name")
//        taskInfo?.setValue(taskNote.text, forKey: "note")
//
//    }
    @IBAction func deleteTask(_ sender: UIButton) {
        //
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        let actionBtn = sender as? UIButton
        action_type = actionBtn?.currentTitle
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
