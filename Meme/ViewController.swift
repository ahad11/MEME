//
//  ViewController.swift
//  Meme
//
//  Created by ahad on 8/2/1440 A.
//  Copyright © 2019 ahad. All rights reserved.
//

import UIKit

class ViewController: UIViewController  , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate{

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var buttomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTollbar: UIToolbar!
    @IBOutlet weak var buttomToolbar: UIToolbar!

    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1),
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  Float(0.9),
      
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.delegate = self;
        buttomTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        buttomTextField.defaultTextAttributes = memeTextAttributes
    
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: this function to Present the Album

    @IBAction func albumClicked(_ sender: Any) {
        let ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
         ImagePicker.sourceType = .photoLibrary
        self.present(ImagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
 
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
      
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imagePickerView.image = image;}
        self.dismiss(animated: true, completion:nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {

         cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = !(imagePickerView.image == nil)
        cancelButton.isEnabled = !(imagePickerView.image == nil)
        subscribeToKeyboardNotifications()
        subscribeToKeyboardHideNotifications()
    }
    
  
    @IBAction func editingBegain(_ sender: Any) {
        
            topTextField.text = ""}
  
        
        
    @IBAction func buttomEditingBegain(_ sender: Any) {
        buttomTextField.text = ""
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardHideNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        
view.frame.origin.y -=  getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y =  0
    }
    
func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
             NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  
    }
    
func saveMeme(){
        var memeObj = meme(top: topTextField.text!, buttom: buttomTextField.text!,image: imagePickerView.image! , memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage {
        topTollbar.isHidden = true
        buttomTextField.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        topTollbar.isHidden = false
        buttomTextField.isHidden = false
        
        return memedImage
    }
    
    

    @IBAction func ShareMemeImg(_ sender: Any) {
        let ImageToBeShare = [generateMemedImage()]
        let ac = UIActivityViewController(activityItems: ImageToBeShare, applicationActivities: nil)
        ac.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }
            self.saveMeme()
        }
        present(ac, animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        imagePickerView.image = nil
        topTextField.text = "TOP"
        buttomTextField.text = "BUTTOM"
        
        
    }
}
    


