//
//  CustomTableViewCell.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/09/30.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var taskname: UILabel!
    @IBOutlet weak var target_time: UILabel!
    @IBOutlet weak var achi_rate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func set(taskname: String, target_time: String, achi_rate: String){
        self.taskname.text = taskname
        self.target_time.text = target_time
        self.achi_rate.text = achi_rate
    }
}
