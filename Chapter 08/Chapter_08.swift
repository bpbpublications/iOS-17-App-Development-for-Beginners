/*
 Chapter - 08
 User Interface Design with UIKit
 */

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
    }
    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration
    {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
     
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
            // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

class ViewController: UIViewController {
 
    override func viewDidLoad() {
            super.viewDidLoad()
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        }
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
        }
        override func viewDidLayoutSubviews() {
            super.viewWillLayoutSubviews()
        }
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        }
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
            print("Memory Warning %@", children)
        }
}

// UITableView
import Foundation
import UIKit
 
class MPViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var tableView: UITableView = UITableView()
    let country = ["AF|Afghanistan","AL|Albania","DZ|Algeria","AS|American Samoa","AD|Andorra","AO|Angola","AI|Anguilla","AQ|Antarctica","AG|Antigua And Barbuda","AR|Argentina","AM|Armenia","AW|Aruba","AU|Australia","AT|Austria","AZ|Azerbaijan","BS|Bahamas","BH|Bahrain","BD|Bangladesh","BB|Barbados","BY|Belarus","BE|Belgium","BZ|Belize","BJ|Benin","BM|Bermuda","BT|Bhutan","BO|Bolivia","BA|Bosnia And Herzegovina","BW|Botswana","BV|Bouvet Island","BR|Brazil","IO|British Indian Ocean Territory","BN|Brunei Darussalam","BG|Bulgaria","BF|Burkina Faso","BI|Burundi","KH|Cambodia","CM|Cameroon","CA|Canada","CV|Cape Verde","KY|Cayman Islands","CF|Central African Republic","TD|Chad","CL|Chile","CN|China","CX|Christmas Island","CC|Cocos (keeling) Islands","CO|Colombia","KM|Comoros","CG|Congo","CD|Congo, The Democratic Republic Of The","CK|Cook Islands","CR|Costa Rica","CI|Côte D'ivoire","HR|Croatia","CU|Cuba","CY|Cyprus","CZ|Czech Republic","DK|Denmark","DJ|Djibouti","DM|Dominica","DO|Dominican Republic","TP|East Timor","EC|Ecuador","EG|Egypt","SV|El Salvador","GQ|Equatorial Guinea","ER|Eritrea","EE|Estonia","ET|Ethiopia"]
    let cellReuseIdentifier = "cell"
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        tableView.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
 
        self.view.addSubview(tableView)
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return country.count
    }
 
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
 
        cell.textLabel?.text = country[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        cell.backgroundColor = UIColor.white
        return cell
    }
 
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        print("You tapped cell number \(indexPath.row).")
    }
}


// UICollectionView
import UIKit
 
class UCViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    let leftAndRightPaddings: CGFloat = 80.0
    let numberOfItemsPerRow: CGFloat = 7.0
    let screenSize: CGRect = UIScreen.main.bounds
    private let cellReuseIdentifier = "collectionCell"
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.cyan
 
        self.view.addSubview(collectionView)
    }
 
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath)
        cell.backgroundColor = UIColor.clear
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 40))
        title.textColor = UIColor.black
        title.textAlignment = .center
        title.text = items[indexPath.row]
        cell.contentView.addSubview(title)
        return cell      //return your cell
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // When user selects the cell
    }
 
    func collectionView(_collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        // When user deselects the cell
    }
}


