import Foundation
 
class MyTodo: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    var todoTitle: String? //タイトル
    var todoDone: Bool = false //タスク完了したか
    var donetime: Int = 0 //何秒タスクを完了したか
    var dotime: Int = 0 //目標時間(何秒)
    var index: Int?
    var genre: String = "その他" //ジャンル
    var stamp: Bool = false //スタンプ化するか
    var date: String = "指定なし" //タスクを行う日付
    var date_bool: Bool = false //日付が指定されたかどうか(初期値：指定されていない)
    var all_day: Bool = false //終日かどうか
    var start: String = ""
    var end: String = ""
    var repetition: Bool = false
    var week: [String]?
    var sepatime: [Int] = [0]
    var evaluation: [Double] = [0]
    var flag: Bool = false
    var In_flag: Bool = false
    var beforeTag: Int = -1
    var afterTag: Int = -1
    var color: [Double] = [0,0,0,1]
    var randomID: String = randomString(length: 10)
    var task_flag = true
    var default_allday = false
    //コンストラクタ
    override init() {
    }
    //デコード処理(取り出す時)
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
        donetime = aDecoder.decodeInteger(forKey: "donetime")
        dotime = aDecoder.decodeInteger(forKey: "dotime")
        genre = aDecoder.decodeObject(forKey: "genre") as! String
        all_day = aDecoder.decodeBool(forKey: "all_day")
        date = aDecoder.decodeObject(forKey: "date") as! String
        date_bool = aDecoder.decodeBool(forKey: "date_bool")
        start = aDecoder.decodeObject(forKey: "start") as! String
        end = aDecoder.decodeObject(forKey: "end") as! String
        repetition = aDecoder.decodeBool(forKey: "repetition")
        week = aDecoder.decodeObject(forKey: "week") as? [String]
        sepatime = aDecoder.decodeObject(forKey: "sepatime") as! [Int]
        evaluation = aDecoder.decodeObject(forKey: "evaluation") as! [Double]
        flag = aDecoder.decodeBool(forKey: "flag")
        In_flag = aDecoder.decodeBool(forKey: "In_flag")
        beforeTag = aDecoder.decodeInteger(forKey: "beforeTag")
        afterTag = aDecoder.decodeInteger(forKey: "afterTag")
        color = aDecoder.decodeObject(forKey: "color") as! [Double]
        randomID = aDecoder.decodeObject(forKey: "randomID") as! String
        task_flag = aDecoder.decodeBool(forKey: "task_flag")
        default_allday = aDecoder.decodeBool(forKey: "default_allday")
    }
    //エンコード処理(入れる時)
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
        aCoder.encode(donetime, forKey: "donetime")
        aCoder.encode(dotime, forKey: "dotime")
        aCoder.encode(genre, forKey: "genre")
        aCoder.encode(all_day, forKey: "all_day")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(date_bool, forKey: "date_bool")
        aCoder.encode(start, forKey: "start")
        aCoder.encode(end, forKey: "end")
        aCoder.encode(repetition, forKey: "repetition")
        aCoder.encode(week, forKey: "week")
        aCoder.encode(sepatime, forKey: "sepatime")
        aCoder.encode(evaluation, forKey: "evaluation")
        aCoder.encode(flag, forKey: "flag")
        aCoder.encode(In_flag, forKey: "In_flag")
        aCoder.encode(beforeTag, forKey: "beforeTag")
        aCoder.encode(afterTag, forKey: "afterTag")
        aCoder.encode(color, forKey: "color")
        aCoder.encode(randomID, forKey: "randomID")
        aCoder.encode(task_flag, forKey: "task_flag")
        aCoder.encode(default_allday, forKey: "default_allday")
    }
}
 
func randomString(length: Int) -> String {

    let letters : NSString = "123456789"
    let len = UInt32(letters.length)

    var randomString = ""

    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }

    return randomString
}



func arrayTitle(array: Array<MyTodo>) -> Array<String> {
    var arrayTitle = [String]()
    for x in array {
        if let title = x.todoTitle {
            arrayTitle.append(title)
        }
    }
    return arrayTitle
}
 
func truecount(array: Array<MyTodo>) -> Int {
    var count = 0
    for x in array {
        if x.todoDone {
            count = count + 1
        }
    }
    return count
}
 
func sum_sepatime(mytodo: MyTodo) -> Int {
    var sepatime = 0
    for x in mytodo.sepatime {
        sepatime += x
    }
    return sepatime
}
 
func evalu(mytodo: MyTodo) -> Int{
    var rate: Int = 0
    var x: Double = 0
    for i in 0..<mytodo.sepatime.count {
        x += Double(mytodo.sepatime[i]) * mytodo.evaluation[i]
    }
    rate = Int((x/Double(mytodo.dotime))*100)
    return rate
}
 
func dotime(mytodo: MyTodo) -> String{
    var ans: String = ""
    ans = String(format: "%02dh %02dm", (mytodo.dotime / 3600), (mytodo.dotime / 60) % 60)
    return ans
}
 
func convert_string(date: Date) -> String{ //Date型からString型へ変換する
    let dateFormater = DateFormatter()
    dateFormater.locale = Locale(identifier: "ja_JP")
    dateFormater.dateFormat = "yyyy/MM/dd"
    dateFormater.timeZone = TimeZone(identifier: "Asia/Tokyo")
    return dateFormater.string(from: date)
}
 
func convert_date(string: String) -> Date{ //String型からDate型へ変換する
    if string == "指定なし"{
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: DateComponents(year: 1, month: 1, day: 1))
        return date!
    }
    let dateFormater = DateFormatter()
    dateFormater.locale = Locale(identifier: "ja_JP")
    dateFormater.dateFormat = "yyyy/MM/dd"
    dateFormater.timeZone = TimeZone(identifier: "Asia/Tokyo")
    let date = dateFormater.date(from: string)
    return date!
}
 
func convert_string_details(date: Date) -> String{ //Date型からString型へ変換する
    let dateFormater = DateFormatter()
    print(date)
    dateFormater.locale = Locale(identifier: "ja_JP")
    dateFormater.dateFormat = "yyyy/MM/dd HH:mm"
    dateFormater.timeZone = TimeZone(identifier: "Asia/Tokyo")
    return dateFormater.string(from: date)
}
 
func convert_date_details(string: String) -> Date{ //String型からDate型へ変換する
    let dateFormater = DateFormatter()
    //dateFormater.timeZone = TimeZone.current
    //dateFormater.locale = Locale.current
    if string == ""{
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: DateComponents(year: 2200, month: 1, day: 1))
        return date!
    }
    dateFormater.locale = Locale(identifier: "ja_JP")
    dateFormater.dateFormat = "yyyy/MM/dd HH:mm"
    dateFormater.timeZone = TimeZone(identifier: "Asia/Tokyo")
    let date = dateFormater.date(from: string)
    return date!
}


extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
    static let jst = TimeZone(identifier: "Asia/Tokyo")!
}

extension Locale {
    static let japan = Locale(identifier: "ja_JP")
}
 

extension DateFormatter {
    static func current(_ dateFormat: String) -> DateFormatter {
        let df = DateFormatter()
        df.timeZone = TimeZone.gmt
        df.locale = Locale.japan
        df.dateFormat = dateFormat
        return df
    }
}

extension Date {
    static var current: Date = Date(timeIntervalSinceNow: TimeInterval(TimeZone.jst.secondsFromGMT()))
}


func search_date(arrays: [MyTodo], date: String) -> [Int] {
    var indexs:[Int] = []
    //let string = convert_string(date: date)
    indexs = arrays.enumerated().filter { $0.1.date == date }.map { $0.0 }
    return indexs
}
func search_ids(arrays: [MyTodo], id: String) -> [Int] {
    var indexs:[Int] = []
    //let string = convert_string(date: date)
    indexs = arrays.enumerated().filter { $0.1.randomID == id }.map { $0.0 }
    return indexs
}

func search_c_index(array: [MyTodo], date: String) -> [Int] {
    var indexs:[Int] = []
    let Now = NSDate() as Date
    indexs = array.enumerated().filter { $0.1.In_flag == true && Calendar.current.dateComponents([.hour], from: Now, to: convert_date_details(string: $0.1.start)).hour! <= 24 && $0.1.task_flag == true}.map { $0.0 }
    return indexs
}

func search_todo_indexs(todoListArray: [MyTodo], date: String) -> [Int] { //振り返りに使う関数
    var indexs:[Int] = []
    indexs = todoListArray.enumerated().filter { $0.1.In_flag == true && $0.1.date == date}.map {$0.0}
    return indexs
}

func delete_c(arrays: [MyTodo], id: String){
    var index: Int = 0
    var calendarListArray: [MyTodo] = arrays
    for c in arrays{
        if c.randomID == id{
            calendarListArray.remove(at: index)
        }
        index += 1
    }
    save_data_c(arrays: calendarListArray)
}

func delete_notcurrent(arrays: [MyTodo]){
    print("delete_notcurrent")
    print("calendarListArray：\(arrays.count)")
    var index: Int = 0
    var calendarListArray: [MyTodo] = arrays
    for c in arrays{
        if(c.start != "" && !c.all_day){
            if(convert_date_details(string: c.start) < Date()){
//                calendarListArray.remove(at: index)
            }
        }
        index += 1
    }
    save_data_c(arrays: calendarListArray)
}

func search_id(arrays: [MyTodo], id: String) -> Int{ //randomIDと一致するindexを返す
    var index :Int = 0
    for x in arrays{
        if x.randomID == id{
            print("見つかりました。")
            break
        }
        index += 1
    }
    return index
}
 
func search_date_c(arrays: [MyTodo], date: String) -> [Int]{
    var indexs:[Int] = []
    let Now = NSDate() as Date
    print("search_date_c")
    indexs = arrays.enumerated().filter {Calendar.current.dateComponents([.hour], from: Now, to: convert_date_details(string: $0.1.start)).hour! <= 24 }.map { $0.0 }
//    if(Calendar.current.dateComponents([.hour], from: Now, to: convert_date_details(string: date)).hour! >= 24){
//
//    }
    //let string = convert_string(date: date)
//    indexs = arrays.enumerated().filter { $0.1.date == date }.map { $0.0 }
    return indexs
}
 
func day_list(arrays: [MyTodo]) -> [String] { //保存されているデータの日付配列
    var days:[String] = []
    for x in arrays{
        days.append(x.date)
    }
    let orderedSet:NSOrderedSet = NSOrderedSet(array: days)
    var ans = orderedSet.array as! [String]
    ans = ans.sorted(by: { (a, b) -> Bool in
        return convert_date(string: a) < convert_date(string: b)
        //return a < b
    })
    return ans
}
 
func all_data() -> [MyTodo] { //todoリストのデータ配列を返す関数
    var todoListArray = [MyTodo]()
    let userDefaults = UserDefaults.standard
    if let storedTodoList = userDefaults.object(forKey: "todoList") as? Data {
        do {
            if let unarchiveTodoList = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, MyTodo.self], from: storedTodoList) as? [MyTodo] {
                todoListArray = unarchiveTodoList
            }
        } catch {
            
        }
    }
    return todoListArray
}
 
func save_data(arrays: [MyTodo]){
    do {
        let data: Data = try NSKeyedArchiver.archivedData(withRootObject: arrays as Array, requiringSecureCoding: true)
        // UserDefaultsに保存
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "todoList")
        userDefaults.synchronize()
        print("保存できました")
    } catch {
        print("保存できませんでした")
    }
}
 
func all_data_c() -> [MyTodo] { //todoリストのデータ配列を返す関数
    var calendarArray = [MyTodo]()
    let userDefaults = UserDefaults.standard
    if let storedTodoList = userDefaults.object(forKey: "CalendarList") as? Data {
        do {
            if let unarchiveTodoList = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, MyTodo.self], from: storedTodoList) as? [MyTodo] {
                calendarArray = unarchiveTodoList
            }
        } catch {
            
        }
    }
    return calendarArray
}
 
func save_data_c(arrays: [MyTodo]){
    do {
        let data: Data = try NSKeyedArchiver.archivedData(withRootObject: arrays as Array, requiringSecureCoding: true)
        // UserDefaultsに保存
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "CalendarList")
        userDefaults.synchronize()
        print("保存できました")
    } catch {
        print("保存できませんでした")
    }
}

func sort_array(arrays: [MyTodo]) -> [MyTodo]{
    var index: Int = 0
    var cnt = 0
    var calendarListArray: [MyTodo] = arrays
    for list in calendarListArray{
        print("before",list.start)
        if(list.start == ""){
            cnt += 1
        }
    }
    for i in 0..<calendarListArray.count {
        for j in 1..<calendarListArray.count {
            if calendarListArray[j].start < calendarListArray[j-1].start {
                let tmp = calendarListArray[j-1]
                calendarListArray[j-1] = calendarListArray[j]
                calendarListArray[j] = tmp
            }
        }
    }
    calendarListArray = calendarListArray.reversed()
    for list in calendarListArray{
        print("reserve",list.start)
    }
    for i in 0..<arrays.count - cnt {
        for j in 1..<arrays.count - cnt {
            if calendarListArray[j].start < calendarListArray[j-1].start {
                let tmp = calendarListArray[j-1]
                calendarListArray[j-1] = calendarListArray[j]
                calendarListArray[j] = tmp
            }
        }
    }
    for list in calendarListArray{
        print("after",list.start)
    }
    return calendarListArray
}

func debug(todo_array: [MyTodo], c_array: [MyTodo]){
    print("==================todoListArray=================")
    for d in todo_array{
        print("タイトル：\(d.todoTitle!)  In_flag：\(d.In_flag)  task_flag：\(d.task_flag)  date：\(d.date)  start：\(d.start)  id：\(d.randomID) default_allday:\(d.default_allday)")
    }
    print("================calendarListArray================")
    for d in c_array{
        print("タイトル：\(d.todoTitle!)  In_flag：\(d.In_flag)  task_flag：\(d.task_flag)  start：\(d.start)  id：\(d.randomID) default_allday:\(d.default_allday)")
    }
}

func debug_todo(todo_array: [MyTodo]){
    print("==================todoListArray=================")
    for d in todo_array{
        print("タイトル：\(d.todoTitle!)  In_flag：\(d.In_flag)  task_flag：\(d.task_flag)  start：\(d.start) default_allday:\(d.default_allday)")
    }
}

 
