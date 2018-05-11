//
//  ViewController.swift
//  CoreDataFetchedResultsController
//
//  Created by apple on 5/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ageTextField: UITextField!
    
    var index: IndexPath?
    var fetchedResultsController = DataService.shared.fetchedResultsController
    var detailObject: Entity?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configure()
    }
    func configure() {
        if let indexPath = index {
            let entity = fetchedResultsController.object(at: indexPath)
            nameTextField.text = entity.name
            ageTextField.text = String(entity.age)
            photoImageView.image = entity.photoImage as? UIImage
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    @IBAction func canCel(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    // MARK: Navigation
    @IBAction func saveCoreData(_ sender: UIBarButtonItem) {
        var ageValue: Int?
        if ageTextField.text != "" {
            ageValue = Int(ageTextField.text!)
        }
        if let indexPath = index {
            let entity = fetchedResultsController.object(at: indexPath)
            entity.name = nameTextField.text
            entity.age = Int64(ageValue!)
            entity.photoImage = photoImageView.image
        } else {
            let context = fetchedResultsController.managedObjectContext
            let entity = Entity(context: context)
            entity.name = nameTextField.text
            entity.age = Int64(ageValue!)
            entity.photoImage = photoImageView.image
        }
        DataService.shared.saveToCoreData()
        navigationController?.popViewController(animated: true)
    }
}
