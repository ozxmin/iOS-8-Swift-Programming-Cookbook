//
//  ViewController.swift
//  Taking Photos with the Camera
//
//  Created by Vandad Nahavandipoor on 7/10/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//
//  These example codes are written for O'Reilly's iOS 8 Swift Programming Cookbook
//  If you use these solutions in your apps, you can give attribution to
//  Vandad Nahavandipoor for his work. Feel free to visit my blog
//  at http://vandadnp.wordpress.com for daily tips and tricks in Swift
//  and Objective-C and various other programming languages.
//  
//  You can purchase "iOS 8 Swift Programming Cookbook" from
//  the following URL:
//  http://shop.oreilly.com/product/0636920034254.do
//
//  If you have any questions, you can contact me directly
//  at vandad.np@gmail.com
//  Similarly, if you find an error in these sample codes, simply
//  report them to O'Reilly at the following URL:
//  http://www.oreilly.com/catalog/errata.csp?isbn=0636920034254

import UIKit
import MobileCoreServices

class ViewController: UIViewController,
UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  /* We will use this variable to determine if the viewDidAppear:
  method of our view controller is already called or not. If not, we will
  display the camera view */
  var beenHereBefore = false
  var controller: UIImagePickerController?
  
  func imagePickerController(picker: UIImagePickerController!,
    didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!){
      
      println("Picker returned successfully")
      
      let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
      
      if let type:AnyObject = mediaType{
        
        if type is String{
          let stringType = type as String
          
          if stringType == kUTTypeMovie as NSString{
            let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL
            if let url = urlOfVideo{
              println("Video URL = \(url)")
            }
          }
            
          else if stringType == kUTTypeImage as NSString as NSString{
            /* Let's get the metadata. This is only for images. Not videos */
            let metadata = info[UIImagePickerControllerMediaMetadata]
              as? NSDictionary
            if let theMetaData = metadata{
              let image = info[UIImagePickerControllerOriginalImage]
                as? UIImage
              if let theImage = image{
                println("Image Metadata = \(theMetaData)")
                println("Image = \(theImage)")
              }
            }
          }
          
        }
      }
      
      picker.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
    println("Picker was cancelled")
    picker.dismissViewControllerAnimated(true, completion: nil)
  }

  func isCameraAvailable() -> Bool{
    return UIImagePickerController.isSourceTypeAvailable(.Camera)
  }
  
  func cameraSupportsMedia(mediaType: String,
    sourceType: UIImagePickerControllerSourceType) -> Bool{
      
      let availableMediaTypes =
      UIImagePickerController.availableMediaTypesForSourceType(sourceType) as
        [String]?
      
      if let types = availableMediaTypes{
        for type in types{
          if type == mediaType{
            return true
          }
        }
      }
      
      return false
  }

  func doesCameraSupportTakingPhotos() -> Bool{
    return cameraSupportsMedia(kUTTypeImage as NSString, sourceType: .Camera)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    if beenHereBefore{
      /* Only display the picker once as the viewDidAppear: method gets
      called whenever the view of our view controller gets displayed */
      return;
    } else {
      beenHereBefore = true
    }
    
    if isCameraAvailable() && doesCameraSupportTakingPhotos(){
      
      controller = UIImagePickerController()
      
      if let theController = controller{
        theController.sourceType = .Camera
        
        theController.mediaTypes = [kUTTypeImage as NSString]
        
        theController.allowsEditing = true
        theController.delegate = self
        
        presentViewController(theController, animated: true, completion: nil)
      }
      
    } else {
      println("Camera is not available")
    }
    
  }
  
}

