//
//  RecipesViewController.swift
//  Core Data Photos
//
//  Created by Madison Williams on 3/19/19.
//  Copyright © 2019 Madison Williams. All rights reserved.
//

import UIKit
import CoreData

class RecipesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    var recipes = [Recipe]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipesTableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        cell.textLabel?.text = recipes[indexPath.row].title
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            recipes = [Recipe]()
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        do {
            let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
            recipes = try managedContext.fetch(fetchRequest)
        } catch {
            print( "Fetch for notes failed.")
        }
        
        recipesTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? RecipeViewController else{
            return
        }
        
        if let segueIdentifier = segue.identifier, segueIdentifier == "recipe", let indexPathForSelectedRow = recipesTableView.indexPathForSelectedRow {
            destination.recipe = recipes[indexPathForSelectedRow.row]
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRecipe(at: indexPath)
        }
    }
    
    
    func deleteRecipe(at indexPath: IndexPath){
        let recipe = recipes[indexPath.row]
        
        if let managedObjectContext = recipe.managedObjectContext {
            managedObjectContext.delete(recipe)
            
            do {
                try managedObjectContext.save()
                self.recipes.remove(at: indexPath.row)
                recipesTableView.reloadData()
            } catch {
                print("Delete failed.")
                recipesTableView.reloadData()
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
