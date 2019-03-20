//
//  RecipeViewController.swift
//  Core Data Photos
//
//  Created by Madison Williams on 3/19/19.
//  Copyright © 2019 Madison Williams. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var recipe : Recipe?
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var recipeNameLabel: UITextField!
    @IBOutlet weak var ingredientsTextField: UITextView!
    @IBOutlet weak var directionsTextField: UITextView!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        if let recipe = recipe{
            recipeNameLabel.text = recipe.title
            ingredientsTextField.text = recipe.ingredients ?? ""
            directionsTextField.text = recipe.directions ?? ""
            recipeImageView.image = recipe.image ?? nil
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func folderButtonPressed(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let alertController = UIAlertController(title: "No Camera", message: "The devide does not have a camera", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            
        } else {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            recipeImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        
         if recipe == nil{//new recipe
             let name = recipeNameLabel.text ?? "No title"
             let ingredients = ingredientsTextField.text ?? ""
             let directions = directionsTextField.text ?? ""
             let photo = recipeImageView.image
            recipe = Recipe(title: name, ingredients: ingredients, directions: directions, image: photo)
         }
         else{
            recipe?.update(title: recipeNameLabel.text ?? "No title" , ingredients: ingredientsTextField.text, directions: directionsTextField.text, image: recipeImageView.image)
        }


            if let recipe = recipe {
                do {
                    let managedContext = recipe.managedObjectContext
                    try managedContext?.save()
                } catch {
                    print("The recipe could not be saved.")
                }
                
            } else {
                print("The recipe could not be created.")
            }
            
            // Return to list of Notes.
            navigationController?.popViewController(animated: true)
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    
    }

}
