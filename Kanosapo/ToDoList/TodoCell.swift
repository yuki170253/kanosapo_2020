//
//  TodoCell.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/11/10.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import RealmSwift
class TodoCell: UITableViewCell {
    // Images
    let checkedImage = UIImage(named: "checkBox@2x")! as UIImage
    let uncheckedImage = UIImage(named: "box@2x")! as UIImage
    var todo: Todo?
    let realm = try! Realm()
    @IBOutlet weak var run: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkbutton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func flagbutton(_ sender: UIButton) {
        let result = realm.object(ofType: Todo.self, forPrimaryKey: "\(todo!.todoid)")
        if result!.todoDone{
            try! realm.write {
                result!.todoDone = false
            }
            sender.setImage(uncheckedImage, for: .normal)
            print("falseに変更")
        }else{
            try! realm.write {
                result!.todoDone = true
            }
            sender.setImage(checkedImage, for: .normal)
            print("trueに変更")
        }
    }
}
