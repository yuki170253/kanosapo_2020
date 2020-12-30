//
//  tutorialViewController.swift
//  videoPlay
//
//  Created by 古府侑樹 on 2020/12/29.
//

import UIKit
import AVKit
class TutorialViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let titleList = ["ホーム画面の説明", "ToDoリストの使い方", "カレンダーの使い方", "振り返りの使い方"]
    let filename = ["ホーム", "ToDoリスト", "カレンダー", "ふりかえり"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "tutorialCell", for: indexPath) as! tutorialTableViewCell
        
        //これでセルをタップ時、色は変化しなくなる
        //cell.selectionStyle = tutorialTableViewCell.SelectionStyle.none
        //自分で色を設定したい場合は、タップ時の色を指定したUIViewを代入
        let selectionView = UIView()
        //タップすると赤色になる
        selectionView.backgroundColor = #colorLiteral(red: 1, green: 0.7922998716, blue: 0.9171784912, alpha: 1)
        cell.selectedBackgroundView = selectionView
        
        // セルに表示する値を設定する
        cell.set(title: titleList[indexPath.row], index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bundleDataName: String = "\(filename[indexPath.row])"
        let bundleDataType: String = "mp4"
        let moviePath: String? = Bundle.main.path(forResource: bundleDataName, ofType: bundleDataType)
            playMovieFromPath(moviePath: moviePath)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func playMovieFromPath(moviePath: String?) {
        if let moviePath = moviePath {
            self.playMovieFromUrl(movieUrl: URL(fileURLWithPath: moviePath))
        } else {
            print("no such file")
        }
    }
    
    func playMovieFromUrl(movieUrl: URL?) {
        if let movieUrl = movieUrl {
            let videoPlayer = AVPlayer(url: movieUrl)
            let playerController = AVPlayerViewController()
            playerController.player = videoPlayer
            self.present(playerController, animated: true, completion: {
                videoPlayer.play()
            })
        } else {
            print("cannot play")
        }
    }
}
