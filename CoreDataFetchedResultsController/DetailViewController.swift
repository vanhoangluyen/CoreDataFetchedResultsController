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
    
    var detailObject: Entity?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configure()
    }
    func configure() {
        if let object = detailObject {
            nameTextField.text = object.name
            ageTextField.text = String(object.age)
            photoImageView.image = object.photoImage as? UIImage
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var age : Int?
        guard let masterTableView = segue.destination as? MasterTableViewController else { return  }
        if ageTextField.text != "" {
            age = Int(ageTextField.text!)
        }
        let contex = masterTableView.fetchedResultsController.managedObjectContext
        if masterTableView.tableView.indexPathForSelectedRow == nil {
            detailObject = Entity(context: contex)
        }
        detailObject?.age = Int64(age!)
        detailObject?.name = nameTextField.text
        detailObject?.photoImage = photoImageView.image
        DataService.shared.saveToCoreData()
    }
}
