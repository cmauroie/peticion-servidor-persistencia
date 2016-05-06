//
//  BookListTableViewController.swift
//  Consulta ISBN Persistencia
//
//  Created by Carlos Mauricio Idárraga Espitia on 5/4/16.
//  Copyright © 2016 Carlos Mauricio Idárraga Espitia. All rights reserved.
//

import UIKit
import CoreData

class BookListTableViewController: UITableViewController {

    var books = [Book]()
    var context : NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let bookEntidad = NSEntityDescription.entityForName("Book", inManagedObjectContext: self.context!)
        
        let peticion = bookEntidad?.managedObjectModel.fetchRequestTemplateForName("petBooks")
        
        do{
            let booksEntidad = try self.context?.executeFetchRequest(peticion!)
            
            for bookEntidad2 in booksEntidad!{
                let isbn = bookEntidad2.valueForKey("isbn") as! String
                let titulo = bookEntidad2.valueForKey("title") as! String
                let autor = bookEntidad2.valueForKey("author") as! [String]
                let portada = bookEntidad2.valueForKey("cover")
                
                /*var autores = [String]()
                for autorEntidad in autoresEntidad {
                    let autor = autorEntidad.valueForKey("contenido") as! String
                    autores.append(autor)
                }*/
                
                var book = Book(isbnCode: isbn, title: titulo, authors: autor, cover: UIImage())
                
                if portada != nil {
                    
                    book.cover = UIImage(data: portada as! NSData)!
                }
                
                self.books.append(book)
                
            }
            
            
        }catch{
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = books[indexPath.row].title

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (sender is UITableViewCell) {
            
            (segue.destinationViewController as! BookDetailsViewController).book = books[tableView.indexPathForSelectedRow!.row]
        }
        
        if (sender is UIBarButtonItem) {
            (segue.destinationViewController as! BookSearchViewController).bookList = self
        }
    }
    

}
