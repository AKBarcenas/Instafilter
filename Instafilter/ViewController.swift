//
//  ViewController.swift
//  Instafilter
//
//  Created by Alex on 6/8/16.
//  Copyright © 2016 Alex Barcenas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // The view that displays the image.
    @IBOutlet weak var imageView: UIImageView!
    // The slider that controls the intensity.
    @IBOutlet weak var intensity: UISlider!
    // The current image
    var currentImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(importPicture))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeFilter(sender: UIButton) {
    }
    
    @IBAction func save(sender: UIButton) {
    }
    @IBAction func intensityChanged(sender: UISlider) {
    }
    
    /*
     * Function Name: importPicture
     * Parameters: None
     * Purpose: This method creates an image picker controller, sets the settings for that controller,
     *   and presents that view controller.
     * Return Value: None
     */
    
    func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    /*
     * Function Name: imagePickerController
     * Parameters: picker - the image picker controller that called this method.
     *  didFinishPickingMediaWithInfo - keeps track of whether or not the user has chosen and image.
     * Purpose: This method chooses the image that the user chose to use as the current image.
     * Return Value: None
     */
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var newImage: UIImage
        
        if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        currentImage = newImage
    }
    
    /*
     * Function Name: imagePickerControllerDidCancel
     * Parameters: picker - the image picker controller that called this method.
     * Purpose: This method handles when the cancel button is pressed in when an image is
     *   being chosen by a user. This is handled by dimissing image picker view controller.
     * Return Value: None
     */
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

