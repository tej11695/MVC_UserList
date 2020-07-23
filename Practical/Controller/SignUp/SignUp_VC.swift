//
//  SignUp_VC.swift
//  Practical
//
//  Created by HariKrishna Kundariya on 14/07/20.
//  Copyright © 2020 HariKrishna Kundariya. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class SignUp_VC: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate, UITextViewDelegate  {
    
    var arrUser = Array<Any>()
    var isNetworkReach:Bool = false
    var picker:UIDatePicker!
    let placeholderText = "Description Text Here"

     @IBOutlet weak var ActivtyIndicator: UIActivityIndicatorView!
    
    @IBOutlet var imageData: UIImageView!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtContact: UITextField!
    @IBOutlet var txtBirthdate: UITextField!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet var btnAddUser: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SignUp User"
        self.txtDesc.delegate = self
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.maximumDate = Date()
        self.txtBirthdate.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
        let numberToolbar11 = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        numberToolbar11.barStyle = .default
        numberToolbar11.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneClickedForDate))]
        numberToolbar11.sizeToFit()
        self.txtBirthdate.inputAccessoryView = numberToolbar11
        
        self.imageData.layer.cornerRadius = self.imageData.frame.height / 2
        self.imageData.layer.borderWidth = 1.0
        self.imageData.layer.borderColor = UIColor.lightGray.cgColor
        self.imageData.layer.masksToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.imageData.isUserInteractionEnabled = true
        self.imageData.addGestureRecognizer(tapGestureRecognizer)
        
        txtDesc.layer.borderColor = UIColor.lightGray.cgColor
        txtDesc.layer.borderWidth = 1.0
        txtDesc.layer.cornerRadius = 5
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        if NetworkReachabilityManager()?.isReachable == true
        {
            self.retrieveData()
        }
        self.ClearTextFileds()
    }
    
    //MARK: - datePickerValueChanged Method
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtBirthdate.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func doneClickedForDate() -> Void
    {
        self.view.endEditing(true)
    }
    
    //MARK: - textView delegate Method
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == placeholderText {
            textView.text = ""
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
        }
    }
    
    
    //MARK: - Image Tap Method -
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard (info[.originalImage] as? UIImage) != nil else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.imageData.image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Extra Method -
    func DisplayAlert(Title:String , Msg:String){
        
        let alert = UIAlertController(title: Title, message: Msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
        
    }
    
    func displayAlertWithOneOptionAndAction(_ title: String, andMessage message: String , no noBlock:@escaping (() -> Void))
    {
        let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = alertWindow.windowLevel + 1
        alertWindow.makeKeyAndVisible()
        
        let alertController: UIAlertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            alertWindow.isHidden = true
            noBlock()
            
        }))
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func GotoList(){
        
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "UserList_VC") as! UserList_VC
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    func ClearTextFileds(){
        self.imageData.image = UIImage(named: "ClickHere.jpeg")
        self.txtName.text = ""
        self.txtEmail.text = ""
        self.txtContact.text = ""
        self.txtBirthdate.text = ""
        self.txtDesc.text = self.placeholderText
    }
    
    @IBAction func btnSkipAction(_ sender: Any) {
        self.GotoList()
    }
    
    
    
    //MARK: - btnAddUserAction Method -
    @IBAction func btnAddUserAction(_ sender: Any) {
        
        let arrTextFields = [self.txtName,self.txtEmail,self.txtContact,self.txtBirthdate]
        for txt in arrTextFields
        {
            if (txt?.text == "")
            {
                self.DisplayAlert(Title: "Alert", Msg: "Please Enter All Fields")
            }
        }
        
        //Email Validation
        if(self.txtEmail.text?.isValidEmail == false){
            self.DisplayAlert(Title: "Alert", Msg: "Please Enter Valid Email.")
        }
            
            //Contact Validation
        else if(self.txtContact.text?.isValidPhoneNumber == false){
            self.DisplayAlert(Title: "Alert", Msg: "Please Enter Valid Contact.")
        }
            
            //Desc Validation
        else if(self.txtDesc.text == ""){
            self.DisplayAlert(Title: "Alert", Msg: "Please Enter Desc")
        }
            
        else{
            if NetworkReachabilityManager()?.isReachable == true
            {
                self.SignUp_API()
            }
            else{
                self.createData()
            }
        }
    }
    
    //MARK: - Coredata Methods
    func createData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "UserTable", in: managedContext)!
        
        var user = NSManagedObject()
        user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        
        let image = self.imageData.image!.jpegData(compressionQuality: 0.5)as NSData?
        user.setValue(self.txtName.text, forKeyPath: "name")
        user.setValue(self.txtEmail.text, forKey: "email")
        user.setValue(self.txtContact.text, forKey: "contact")
        user.setValue(self.txtBirthdate.text, forKey: "birthdate")
        user.setValue(self.txtDesc.text, forKey: "desc")
        user.setValue(image, forKey: "image")
        
        do {
            try managedContext.save()
            
            let alertController = UIAlertController(title: "User Created", message:"Network not reachable. data stored in local storage.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.GotoList()
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserTable")
        
        do {
            self.arrUser = try managedContext.fetch(fetchRequest)
            print(self.arrUser)
            
            if(self.arrUser.count > 0){
                if NetworkReachabilityManager()?.isReachable == true
                {
                    let alertController = UIAlertController(title: "Network Available", message: "Sync Data from Local Storage to Server.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        //self.deleteData()
                        self.isNetworkReach = true
                        self.SignUp_API()
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else{
                    print("No Network")
                }
                
            }
            else{
                print("No Data in Local")
            }
        } catch {
            print("Failed")
        }
    }
    
    func deleteData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserTable")
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
                print("Data Clear")
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
    
    
    //MARK: - Register Api Call
    func SignUp_API() {
        
        let url = "https://ios-interview-test.herokuapp.com/users"
        
        if NetworkReachabilityManager()?.isReachable == true
        {
            self.ActivtyIndicator.startAnimating()
            
            var params:[String:String] = [String:String]()
            if(self.isNetworkReach == true){
                
                let dictData = self.arrUser[0] as? NSManagedObject
                let Name = dictData?.value(forKey: "name") as? String ?? ""
                let Email = dictData?.value(forKey: "email") as? String ?? ""
                let Contact = dictData?.value(forKey: "contact") as? String ?? ""
                let BirthDate = dictData?.value(forKey: "birthdate") as? String ?? ""
                let Desc = dictData?.value(forKey: "desc") as? String ?? ""
                self.imageData?.image =  UIImage(data: dictData?.value(forKey: "image") as? Data ?? Data())
                
                params = ["name": Name, "email": Email,"contact": Contact,"birthdate": BirthDate,"description": Desc]
            }
            else{
                params = ["name": self.txtName.text!, "email": self.txtEmail.text!,"contact": self.txtContact.text!,"birthdate": self.txtBirthdate.text!,"description": self.txtDesc.text!]
            }
            
            Alamofire.upload(multipartFormData:
                {
                    (multipartFormData) in
                    
                    DispatchQueue.main.sync {
                        multipartFormData.append(self.imageData.image!.jpegData(compressionQuality: 0.75)!, withName: "image", fileName: "Image.jpeg", mimeType: "image/jpg")
                        for (key, value) in params
                        {
                            multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        }
                    }
            }, to:url,headers:nil)
            { (result) in
                switch result {
                case .success(let upload,_,_):
                    upload.uploadProgress(closure: {(progress) in
                        //Print progress
                    })
                    upload.responseJSON
                        { response in
                            if response.result.value != nil
                            {
                                self.ActivtyIndicator.stopAnimating()
                                self.ClearTextFileds()
                                
                                let dict :NSDictionary = response.result.value! as! NSDictionary
                                print(dict)
                                let code = dict["response_code"] as? Int ?? 0
                                if(code == 200){
                                    
                                    if(self.isNetworkReach == true){
                                        self.isNetworkReach = false
                                        self.deleteData()
                                    }
                                    
                                    let alertController = UIAlertController(title: "Successful", message: dict["response_message"] as? String ?? "User Created", preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                        UIAlertAction in
                                        self.GotoList()
                                    }
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion: nil)
                                }
                                else{
                                    self.DisplayAlert(Title: "Error", Msg: dict["response_message"] as? String ?? "Something went wrong")
                                }
                            }
                    }
                case .failure(let encodingError):
                    print("Error : \(encodingError)")
                    break
                }
            }
        }
        else
        {
            self.DisplayAlert(Title: "Alert", Msg: "No network.")
        }
    }
    
}
