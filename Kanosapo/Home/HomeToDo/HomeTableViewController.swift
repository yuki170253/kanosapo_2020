
import UIKit
import UBottomSheet
import RealmSwift
class HomeTableViewController: BottomSheetController ,UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableview: UITableView!
    private var effectView : UIVisualEffectView!
    let realm = try! Realm()
    var resultsCount: Int = 0
    var resultArray:[Todo] = []
    var count: Int = 0
    @IBOutlet weak var handleBar: UIView!
    var todoid: String = ""
    var bottom:Float = 0.0
    @IBOutlet weak var HeadLeftPartition: UIView!
    @IBOutlet weak var HeadRightPartition: UIView!
    @IBOutlet weak var CellLeftPartition: UIView!
    @IBOutlet weak var CellRightPartition: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let headerCell: UITableViewCell = tableview.dequeueReusableCell(withIdentifier: "HeaderCell")!
//        let headerView: UIView = headerCell.contentView
//        tableview.tableHeaderView = headerView
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        handleBar.frame = CGRect(x: (view.frame.width/4), y: view.frame.height/250, width: view.frame.width/2, height: view.frame.height/75)
        tableview.frame = CGRect(x: 0, y: view.frame.height/50, width: view.frame.width, height: view.frame.height - (view.frame.height/50)*2)
        bottom = Float(view.frame.height/10.5)
        
        
        let results = realm.objects(Calendar24.self).filter("end >= %@ AND end <= %@", Date(), Calendar.current.date(byAdding: .hour, value: 24, to: Date())!).sorted(byKeyPath: "start", ascending: true)
        
        resultsCount = results.count
        
        for i in results{
            if !i.todo.first!.todoDone{
                resultArray.append(i.todo.first!)
            }
        }
        
        let f = DateFormatter()
        f.timeStyle = .full
        f.dateStyle = .full
        f.locale = Locale(identifier: "ja_JP")
        appDelegate.delegateResults = results
        for i in results{
            print("==============-\(f.string(from: i.start))===================")
            print("==============-\(i.start))===================")
        }
        //スコアの取得
        var score:Double = 0.0
        score = UserDefaults.standard.object(forKey: "score") as! Double //取り出し
        if score <= 25{
            registration(value:10)
            registration(value:5)
            registration(value:3)
            registration(value:1)
        }else if score <= 50{
            registration(value:10)
            registration(value:5)
        }else if score <= 75{
            registration(value:5)
        }else{
            registration(value:5)
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableview.reloadData()
    }
    override var initialPosition: SheetPosition {
        return .bottom
    }
    
    override var bottomInset: CGFloat{
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewCustomTableViewCell
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.8538099315, blue: 0.9171784912, alpha: 1)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.setHeader(taskname: "本日のタスク", target_time: "目標時間", achi_rate: "達成度")
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewCustomTableViewCell
            cell.set(taskname: resultArray[indexPath.row-1].title, target_time: "\(resultArray[indexPath.row-1].rate)％", achi_rate: resultArray[indexPath.row-1].dotime_string)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.index = search_id(arrays: todoListArray, id: calendarListArray[indexs_c[indexPath.row]].randomID
        if indexPath.row != 0 {
            todoid = resultArray[indexPath.row-1].todoid
            //myTodo = todoListArray[self.index]
            performSegue(withIdentifier: "to_evalu", sender: nil)
        }
    }
    
    //画面遷移の処理
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "to_evalu") {
            let vc = segue.destination as! EvaluViewController
            vc.todoid = todoid
        }
    }
    
    //かける　変更 12/10
    // AppDelegate -> applicationDidEnterBackgroundの通知
    func registration(value: Int){
        let results = realm.objects(Calendar24.self).filter("end >= %@ AND end <= %@", Date(), Calendar.current.date(byAdding: .hour, value: 24, to: Date())!).sorted(byKeyPath: "start", ascending: true)
        
        //デバッグよう
        var identifier = String()
        
        var trigger: UNNotificationTrigger
        let content = UNMutableNotificationContent()
        var notificationTime = DateComponents()
        if(results != nil){
            for item in results{
                let components = Calendar.current.dateComponents(in: TimeZone.current, from: item.start)
                notificationTime.hour = components.hour
                notificationTime.minute = components.minute! - value
                trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
                content.title = item.todo.first!.title
                content.body = "もうすぐタスクの時間だよ！"
                content.sound = UNNotificationSound.default
                identifier = item.calendarid + "\(value)"
                print(identifier)
                let request = UNNotificationRequest(identifier: item.calendarid + "\(value)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
            }
        }
    }
}
