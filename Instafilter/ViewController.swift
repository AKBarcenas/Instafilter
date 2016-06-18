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
    // Handles rendering
    var context: CIContext!
    // The current filter that is being used.
    var currentFilter: CIFilter!
    
    /*
     * Function Name: viewDidLoad
     * Parameters: None
     * Purpose: This method loads all the view for the application and sets the default filter and context.
     * Return Value: None
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(importPicture))
        
        context = CIContext(options: nil)
        currentFilter = CIFilter(name: "CISepiaTone")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * Function Name: changeFilter
     * Parameters: sender - the button that called this function.
     * Purpose: This method presents an alert to the user that allows them to choose the filter to
     *   manipulate the image with.
     * Return Value: None
     */
    
    @IBAction func changeFilter(sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .ActionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .Default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    /*
     * Function Name: save
     * Parameters: sender - the button that called this function.
     * Purpose: This method saves all of the changes that the user has made to the image with the current filter.
     * Return Value: None
     */
    
    @IBAction func save(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    /*
     * Function Name: intensityChanged
     * Parameters: sender - the slider that called this method.
     * Purpose: This method applies processing to the picture every time the intensity on the slider changes.
     * Return Value: None
     */
    
    @IBAction func intensityChanged(sender: UISlider) {
        applyProcessing()
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
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
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
    
    /*
     * Function Name: applyProcessing
     * Parameters: None
     * Purpose: This method applies processing to the picture using the current filter with the constraints
     *   of the filter.
     * Return Value: None
     */
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        
        let cgimg = context.createCGImage(currentFilter.outputImage!, fromRect: currentFilter.outputImage!.extent)
        let processedImage = UIImage(CGImage: cgimg)
        
        self.imageView.image = processedImage
    }
    
    /*
     * Function Name: setFilter
     * Parameters: action - the action that is attatched to the
     * Purpose: This method creates an image picker controller, sets the settings for that controller,
     *   and presents that view controller.
     * Return Value: None
     */
    
    func setFilter(action: UIAlertAction!) {
        currentFilter = CIFilter(name: action.title!)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    /*
     * Function Name: image
     * Parameters: image - the image that this method was called by.
     *   error - the error that possibly occured when saving this image.
     *   contextInfo - information about the context that may have been used with this method call.
     * Purpose: This method checks to see if an error occurred when the user saved their image and displays
     *   a message to user letting them know if the save was successful or not.
     * Return Value: None
     */
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }

}

