
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
    var todoid: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerCell: UITableViewCell = tableview.dequeueReusableCell(withIdentifier: "HeaderCell")!
        let headerView: UIView = headerCell.contentView
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        tableview.tableHeaderView = headerView
        
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
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewCustomTableViewCell
        let rate = resultArray[indexPath.row].rate
        
        cell.set(taskname: resultArray[indexPath.row].title, target_time: "\(rate)％", achi_rate: resultArray[indexPath.row].dotime_string)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.index = search_id(arrays: todoListArray, id: calendarListArray[indexs_c[indexPath.row]].randomID)
        todoid = resultArray[indexPath.row].todoid
        //myTodo = todoListArray[self.index]
        performSegue(withIdentifier: "to_evalu", sender: nil)
    }
    
    //画面遷移の処理
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "to_evalu") {
            let vc = segue.destination as! EvaluViewController
            vc.todoid = todoid
        }
    }
}
