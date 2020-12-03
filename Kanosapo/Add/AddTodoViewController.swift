//
//  AddTodoViewController.swift
//  MyTodoList
//
//  Created by 古府侑樹 on 2019/07/08.
//  Copyright © 2019 古府侑樹. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift
class AddTodoViewController: FormViewController {
    var todoListArray = [MyTodo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //データの読み込み
        tableView.backgroundColor = #colorLiteral(red: 1, green: 0.9324973226, blue: 0.9340327382, alpha: 1)
        let userDefaults = UserDefaults.standard
        if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data {
            do {
                if let unarchiveTodoList = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, MyTodo.self], from: storedTodoList) as? [MyTodo] {
                    todoListArray.append(contentsOf: unarchiveTodoList)
                }
            } catch {

            }
        }
        
        //フォームの作成
        var rules = RuleSet<String>()
        let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
            return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: "入力してください") : nil
        }
        rules.add(rule: ruleRequiredViaClosure)
        form +++ Section("ToDoリストの基本情報設定")
            <<< TextRow("title"){ row in
                row.title = "タイトル(必須)"
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
                }.cellSetup { cell, row in cell.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9019607843, blue: 0.9098039216, alpha: 1);
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        var errors = ""
                        for error in row.validationErrors {
                            let errorString = error.msg + "\n"
                            errors = errors + errorString
                        }
                        print(errors)
                        cell.detailTextLabel?.text = errors
                        cell.detailTextLabel?.isHidden = false
                        cell.detailTextLabel?.textAlignment = .left
                    }
            }
            <<< CountDownInlineRow("target_time"){ row in
                row.title = "目標時間"
                var dateComp = DateComponents()
                dateComp.hour = 1
                dateComp.minute = 0
                dateComp.timeZone = TimeZone.current
                row.value = Calendar.current.date(from: dateComp)
            }.cellSetup { cell, row in cell.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9019607843, blue: 0.9098039216, alpha: 1);
            }
            <<< SwitchRow("switchDate"){
                    $0.title = "日付を指定する"
                }.cellSetup { cell, row in cell.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9019607843, blue: 0.9098039216, alpha: 1);
                }
                <<< DateRow("date"){ row in

                    row.hidden = Condition.function(["switchDate"], { form in
                        return !((form.rowBy(tag: "switchDate") as? SwitchRow)?.value ?? false)
                    })
                    row.title = "日付"
                    row.value = Date()
                }.cellSetup { cell, row in cell.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9019607843, blue: 0.9098039216, alpha: 1);
                }
            +++ Section()
            <<< ButtonRow() { row in
                row.title = "追加する"
                }.onCellSelection {  cell, row in
                    print("保存ボタンが押されました。")
                    var title: String = ""
                    var errors: [String] = [""]
                    if let unwrappedtitle = self.form.values()["title"] as? String{
                        title = unwrappedtitle
                        print(title)
                        print(type(of: title))
                    }else{
                        print("title=nil")
                        errors.append("タイトルが入力されていません")
                    }
                    
                    if errors.count > 1 {
                        print("alert表示")
                        let title = "入力エラー"
                        var message = ""
                        let okText = "OK"
                        var num:Int = 1
                        for data in errors {
                            if num == 1{
                                num += 1
                            }else{
                                message += "・\(data)\n"
                            }
                        }
                        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
                        alert.addAction(okayButton)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        print("保存可能")
                        let todo = Todo()
                        let myTodo = MyTodo()
                        myTodo.todoTitle = title
                        todo.title = title
                        
                        if let target_time = self.form.values()["target_time"] as? Date{
                            print(type(of: target_time))
                            let date:Date = target_time
                            let calendar = Calendar.current
                            let hour = calendar.component(.hour, from: date)
                            let minute = calendar.component(.minute, from: date)
                            var time :Int = 0
                            let h :Int = hour
                            let m :Int = minute
                            time = (h * 3600) + (m * 60)
                            myTodo.dotime = time
                            todo.dotime = time
                        }
                        if let undate = self.form.values()["date"] as? Date{
                            print("date：\(undate)")
                            let f = DateFormatter()
                            f.timeStyle = .none
                            f.dateStyle = .full
                            f.locale = Locale(identifier: "ja_JP")
                            myTodo.date = convert_string(date: undate)
                            todo.date = undate
                            todo.datestring = f.string(from: undate)
                            print(myTodo.date)
                        }else{
                            print("date=nil")
                        }
                        let realm = try! Realm()
                        try! realm.write {
                            realm.add(todo)
                        }
                        //ToDoの配列に入力値を挿入。先頭に挿入。
                        self.todoListArray.insert(myTodo, at: 0)
                        let userDefaults = UserDefaults.standard
                        do {
                            let data = try NSKeyedArchiver.archivedData(withRootObject: self.todoListArray, requiringSecureCoding: true)
                            userDefaults.set(data, forKey: "todoList")
                            userDefaults.synchronize()
                            print("保存しました")
                        } catch {
                            print("保存できませんでした")
                        }
                        //self.performSegue(withIdentifier: "from_addview", sender: nil)
                        self.navigationController?.popViewController(animated: true)
                        //self.navigationController?.popToRootViewController(animated: true)
                    }
                }.cellSetup { cell, row in cell.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9019607843, blue: 0.9098039216, alpha: 1);
                }
    }
}

