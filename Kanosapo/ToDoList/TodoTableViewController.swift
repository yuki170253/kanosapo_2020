//
//  ViewController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/06/07.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import RealmSwift
class TodoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var todoListArray = [MyTodo]()
    var days: [String] = []
    var day_list7: [String] = []
    var indexs: [[Int]] = []
    let checkedImage = UIImage(named: "checkBox@2x")! as UIImage
    let uncheckedImage = UIImage(named: "box@2x")! as UIImage
    let realm = try! Realm()
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadView()
        //view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        // UIVisualEffectViewを生成する
        let visualEffectView = UIVisualEffectView(frame: view.frame)
        // エフェクトの種類を設定
        visualEffectView.effect = UIBlurEffect(style: .regular)
        // UIVisualEffectViewを他のビューの下に挿入する
        view.insertSubview(visualEffectView, at: 0)
        print("viewDidLoad=TodoTableViewに遷移")
        /*
        let todos = realm.objects(Todo.self).filter("title == 'テストデータ'")
        let todo = realm.object(ofType: Todo.self, forPrimaryKey: todos[0].todoid)
        //let calendars = realm.objects(Todo.self).filter("title == 'テストデータ'")
        try! realm.write {
            for d in todo!.calendars{
                realm.delete(d)
            }
            realm.delete(todo!)
        }
        */
    }
    
    // 画面に表示される直前に呼ばれます。
    // viewDidLoadとは異なり毎回呼び出されます。
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        //tableView.reloadData()
        day_list7 = daylist7()
        tableView.reloadData()
        print("テストindexs\(indexs)")
        print("viewWillApppear=TodoTableViewに遷移")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSections")
        return day_list7.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)")
        let day = day_list7[section]
        let results = realm.objects(Todo.self).filter("datestring == %@", day)
        return results.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //print("tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)")
        return day_list7[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todocell", for: indexPath) as! TodoCell
        //行番号に合ったToDoの情報を取得
        let day = day_list7[indexPath.section]
        let todo = realm.objects(Todo.self).filter("datestring == %@", day)[indexPath.row]
        //let myTodo = todoListArray[indexs[indexPath.section][indexPath.row]]
        cell.title.text = todo.title
        cell.todo = todo
        //セルのじチェックマーク状態をセット
        if todo.todoDone {
            cell.checkbutton.setImage(checkedImage, for: .normal)
        } else {
            cell.checkbutton.setImage(uncheckedImage, for: .normal)
        }
        if todo.InFlag{
            cell.run.isHidden = false
        }else{
            cell.run.isHidden = true
        }
        return cell
    }
    
    //セルが選択された時の処理
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("選択された時｜section：\(indexPath.section) row：\(indexPath.row)")
        print("選択された時のindexs：\(indexs)")
        print("選択された時のindex：\(indexs[indexPath.section][indexPath.row])")
        print("\(todoListArray[indexs[indexPath.section][indexPath.row]].todoDone)")
        print("\(todoListArray[indexs[indexPath.section][indexPath.row]].todoTitle!)")
        //days = day_list(arrays: todoList)
    }
    */
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("削除された時｜section：\(indexPath.section) row：\(indexPath.row)")
        //削除処理かどうか
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let day = day_list7[indexPath.section]
            let todo = realm.objects(Todo.self).filter("datestring == %@", day)[indexPath.row]
            try! realm.write {
                for d in todo.calendars{
                    realm.delete(d)
                }
                realm.delete(todo)
            }
            tableView.reloadData() //矛盾が生じるので描画し直す。
        }
    }
}





