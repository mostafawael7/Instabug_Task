//
//  AddMovie.swift
//  Instabug Challenge
//
//  Created by Mostafa Hendawi on 5/18/20.
//  Copyright © 2020 Hendawi. All rights reserved.
//

import UIKit

class AddMovie: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPosterButton: UIButton!
    @IBOutlet weak var movieTitleField: UITextField!
    @IBOutlet weak var movieDateField: UITextField!
    @IBOutlet weak var movieOverviewField: UITextView!
    @IBOutlet weak var addMovieButton: UIButton!
    
    var comp = NSDateComponents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        ///Customize View
        addPosterButton.tintColor = UIColor(hex: "011993")
        
        movieTitleField.layer.masksToBounds = true
        movieTitleField.layer.borderColor = UIColor(hex: "011993")?.cgColor
        movieTitleField.layer.borderWidth = 2.0
        
        movieDateField.layer.masksToBounds = true
        movieDateField.layer.borderColor = UIColor(hex: "011993")?.cgColor
        movieDateField.layer.borderWidth = 2.0
        
        movieOverviewField.layer.masksToBounds = true
        movieOverviewField.layer.borderColor = UIColor(hex: "011993")?.cgColor
        movieOverviewField.layer.borderWidth = 2.0
        
        addMovieButton.tintColor = UIColor(hex: "011993")
        addMovieButton.backgroundColor = UIColor(hex: "E8D5B5")
        addMovieButton.layer.cornerRadius = 25
        
        ///Adjust view when typing
        hideKeyboard()
        adjustViewsWhenUsingKeyboard()
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        movieDateField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        movieDateField.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func addPosterButtonClicked(_ sender: UIButton) {
        showImagePickerActionSheet()
    }
    
    @IBAction func addMovieButtonClicked(_ sender: UIButton) {
        if movieTitleField.text == "" || movieDateField.text == "" || movieOverviewField.text == "" {
            displayAlert(title: "Warning", message: "Please enter all data to be able to add your movie!")
        } else {
            if imageView.image == nil {
                imageView.image = UIImage(named: "default")
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Movies") as! Movies
            let movie = Movie(title: movieTitleField.text!, overview: movieOverviewField.text!, date: movieDateField.text!)
            Movies.customized.customMovies.append(movie)
            Movies.customized.customImages.append(imageView)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension UIViewController{
    
    func displayAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    //hide keyboard when tapping anywhere
    func hideKeyboard(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    //push the view upwards when using keyboard and bring it back down when dismissing the keyboard
    func adjustViewsWhenUsingKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension AddMovie: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func showImagePickerActionSheet(){
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.showImagePickerView(source: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showImagePickerView(source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = pickedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = originalImage
        }
        addPosterButton.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
