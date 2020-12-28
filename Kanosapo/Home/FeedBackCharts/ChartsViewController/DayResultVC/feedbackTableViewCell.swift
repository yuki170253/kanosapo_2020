//
//  feedbackTableViewCell.swift
//  Kanosapo
//
//  Created by 古府侑樹 on 2020/12/28.
//

import UIKit

class feedbackTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var rate: UILabel!
    
    @IBOutlet weak var evaluation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func feedbackset(title: String, rate: String, evaluation: String){
        self.title.text = title
        self.rate.text = rate
        if evaluation == "1.0"{
            self.evaluation.text = "♡"
        }else if evaluation == "2.0"{
            self.evaluation.text = "♡♡"
        }else if evaluation == "3.0"{
            self.evaluation.text = "♡♡♡"
        }else if evaluation == "4.0"{
            self.evaluation.text = "♡♡♡♡"
        }else if evaluation == "5.0"{
            self.evaluation.text = "♡♡♡♡♡"
        }else if evaluation == "0.0"{
            self.evaluation.text = "評価なし"
        }
    }
}
