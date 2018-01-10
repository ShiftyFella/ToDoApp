//
//  MAPD 714 - Assigment 2 - ToDo List Application
//
// Name: Todo List
// Desc: To do app
// Contributors: #300964200 - Viktor Bilyk
//               #300965775 - Timofei Sopin
//
// Ver: 0.1 - Basic Set Up with cell delegate protocols
// File: Custom Cell handler

import UIKit

protocol TaskViewCellDelegate: class {
    func taskViewCellChkBoxTapped(_ sender: TaskViewCell)
    func taskViewCellEditBtnTapped(_ sender: TaskViewCell)
    func taskViewCellDelBtnTapped(_ sender: TaskViewCell)
}

class TaskViewCell: UITableViewCell {

    @IBOutlet weak var taskDoneCheckBox: UIButton!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskEditBtn: UIButton!
    @IBOutlet weak var taskDelBtn: UIButton!
    @IBOutlet weak var taskCategory: UIButton!
    @IBOutlet weak var taskDate: UILabel!
    weak var delegate: TaskViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.taskCategory.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func chkBoxTap(_ sender: UIButton) {
        //
        delegate?.taskViewCellChkBoxTapped(self)
    }
    
    @IBAction func edtBtnTap(_ sender: UIButton) {
        //
        delegate?.taskViewCellEditBtnTapped(self)
    }
    
    @IBAction func delBtnTap(_ sender: UIButton) {
        //
        delegate?.taskViewCellDelBtnTapped(self)
    }
    
}
