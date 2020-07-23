//
//  UserList_VC.swift
//  Practical
//
//  Created by HariKrishna Kundariya on 14/07/20.
//  Copyright © 2020 HariKrishna Kundariya. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class UserList_VC: UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    var UserList = UserDataList()

    var arrUser = [[String : AnyObject]]()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "User List"
        self.tableView.separatorStyle = .none
        
        if NetworkReachabilityManager()?.isReachable == true
        {
        self.getUserList()
        }
        else{
            self.arrUser = []
            self.tableView.reloadData()
            self.DisplayAlert(Title: "Network Error", Msg: "Network Not Available")
        }
        }
    
    //MARK: - getUserList Method
    func getUserList(){
        
        let url = "https://ios-interview-test.herokuapp.com/users"
        Alamofire.request(URL(string: url)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) in
            let response = self.formatResponse(data: responseObject)
            let arr = response["users"] as! [[String : AnyObject]]
            self.arrUser.append(contentsOf: arr)
            self.UserList = UserDataList(data: self.arrUser)
            self.tableView.reloadData()
        }
    }
    
    //MARK: - formatResponse Method
    func formatResponse(data:DataResponse<Any>)-> [String:AnyObject]
    {
        let responseObject = data.result.value as? [NSObject: AnyObject]
        let response = responseObject as? [String : AnyObject]
        return response ?? [:]
    }
    
    func DisplayAlert(Title:String , Msg:String){
        
        let alert = UIAlertController(title: Title, message: Msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
        
    }
    

    //MARK: - TableView DataSource Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.UserList.arrUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        cell.selectionStyle = .none
        //let dictData = self.arrUser[indexPath.row] as? NSManagedObject
        
        cell.lblName.text = self.UserList.arrUserData[indexPath.row].name
        cell.lblContact.text = self.UserList.arrUserData[indexPath.row].contact
        cell.lblEmail.text = self.UserList.arrUserData[indexPath.row].email
        cell.lblBirth.text = self.UserList.arrUserData[indexPath.row].birthdate
        cell.lblDesc.text = self.UserList.arrUserData[indexPath.row].description
        
        let DictProfile = self.UserList.arrUserData[indexPath.row].profile_photo
        let ImgURL = DictProfile["url"] as? String ?? ""
        
        if(ImgURL != ""){
            cell.imageData!.sd_setImage(with:URL(string: ImgURL)! , placeholderImage: #imageLiteral(resourceName: "ClickHere.jpeg"), options: [.continueInBackground,.refreshCached,.lowPriority]) { (image, error, type, url) in
                cell.imageData!.image = image
            }
        }
        else{
            cell.imageData?.image = UIImage(named: "ClickHere.jpeg")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
