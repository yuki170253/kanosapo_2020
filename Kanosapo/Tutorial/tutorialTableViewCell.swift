//
//  tutorialTableViewCell.swift
//  Kanosapo
//
//  Created by 古府侑樹 on 2020/12/30.
//

import UIKit

class tutorialTableViewCell: UITableViewCell {

    @IBOutlet weak var tutorialImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func set(title:String, index:Int){
        label.text = title
        print(title)
        if index == 0 {
            tutorialImageView.image = UIImage(named:"メンヘラ_SD_0")
        }else if index == 1{
            tutorialImageView.image = UIImage(named:"todolist_2")
        }else if index == 2{
            tutorialImageView.image = UIImage(named:"calendar_2")
        }else if index == 3{
            tutorialImageView.image = UIImage(named:"button_f2")
        }
    }
}
