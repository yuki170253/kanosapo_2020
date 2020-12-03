//
//  EvaluDetailsViewController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/09/22.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import Cosmos
class EvaluDetailsViewController: UIViewController {
    
    @IBOutlet weak var cosmosView: CosmosView!
    var sepatime :Int = 0
    var index :Int = 0
    var myTodo: MyTodo?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func AddButton(_ sender: Any) {
        var rating :Double = cosmosView.rating
        let userDefaults = UserDefaults.standard
        //var myTodo = MyTodo()
        var todoListArray = [MyTodo]()
        if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data { //viewDidLoad()が呼び出されないのが原因?
            do {
                if let unarchiveTodoList = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, MyTodo.self], from: storedTodoList) as? [MyTodo] {
                    todoListArray.append(contentsOf: unarchiveTodoList)
                }
            } catch {
                
            }
        }
        print("This")
        print(index)
        
        switch rating {
            case 1.0:
                rating = 0.25
            case 2.0:
                rating = 0.5
            case 3.0:
                rating = 0.75
            case 4.0:
                rating = 1.0
        default:
            rating = 0
        }
        todoListArray[index].sepatime.append(sepatime)
        todoListArray[index].evaluation.append(rating)
        myTodo = todoListArray[index]
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: todoListArray, requiringSecureCoding: true)
            userDefaults.set(data, forKey: "todoList")
            userDefaults.synchronize()
            print("タスク経過を保存しました")
        } catch {
            print("保存できませんでした")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toConfirmationViewController") {
            let vc = segue.destination as! ConfirmationViewController
            if let unmyTodo = myTodo{
                vc.myTodo = unmyTodo
            }else{
                print("myTodoがありません。")
            }
        }else if (segue.identifier == "toResult"){
            let vc = segue.destination as! ResultViewController
            if let unmyTodo = myTodo{
                vc.myTodo = unmyTodo
            }else{
                print("myTodoがありません。")
            }
        }
    }
    
    
    @IBAction func SkipButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
