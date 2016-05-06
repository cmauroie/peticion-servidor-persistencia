//
//  BookSearchViewController.swift
//  Consulta ISBN Persistencia
//
//  Created by Carlos Mauricio Idárraga Espitia on 5/4/16.
//  Copyright © 2016 Carlos Mauricio Idárraga Espitia. All rights reserved.
//

import UIKit
import CoreData

class BookSearchViewController: UIViewController {
    
    @IBOutlet weak var isbnTextField : UITextField!
    var context : NSManagedObjectContext!  = nil
    
    private let baseurl = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    
    var book : Book!
    var bookList : BookListTableViewController!


    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        self.context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        isbnTextField.text = nil
        (segue.destinationViewController as! BookDetailsViewController).book = self.book
        
    }
    
    func searchBook (isbn: String, completionHandler: (book: Book) -> Void) {

        /********************Verifica si libro existe en base de datos*******************/
        
       /* let bookEntidad = NSEntityDescription.entityForName("Book", inManagedObjectContext: self.context)
        let peticion = bookEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petBooks", substitutionVariables: ["isbn" : isbn])
               do{
            let bookEntidad2 = try self.context?.executeFetchRequest(peticion!)
                print("verifica1")

            if(bookEntidad2?.count > 0){
                print("verifica2")
                //ProgressView.sharedInstance.hideProgressView()
                return
            }
            
        }catch{
            
        }
        
        print("verifica3")*/
        /********************************************************************************/
        
        
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: baseurl + isbn)!, completionHandler: {(data, response, error) in
            
            if error != nil {
                
                dispatch_async(dispatch_get_main_queue(), {
                 ProgressView.sharedInstance.hideProgressView()
                })
                
                self.showAlertDialog("Error", message: error!.localizedDescription)
                
            } else {
                
                var book = Book(isbnCode: isbn, title: "Título No Definido", authors: [ "Autor No Definido" ], cover: UIImage())

                
                
                do {
                    
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String : AnyObject] {
                        
                        if let bookJson = json["ISBN:" + isbn] as? [String : AnyObject] {
                            
                            if let authors = bookJson["authors"] as? [AnyObject] {
                                
                                book.authors.removeAll()
                                
                                for author in authors {
                                    
                                    book.authors.append(author["name"] as! String)
                                }
                            }
                            
                            if let title = bookJson["title"] as? String {
                                
                                book.title = title
                            }
                            
                            if let cover = bookJson["cover"]?["large"] as? String {
                                
                                if let coverImg = UIImage(data: NSData(contentsOfURL: NSURL(string: cover)!)!) {
                                    
                                    book.cover = coverImg
                                }
                            }
                            
                           /********************almacena libro en base de datos*****************************/
                            print("almacena")
                            let nuevaBookEntidad = NSEntityDescription.insertNewObjectForEntityForName("Book", inManagedObjectContext: self.context)
                            nuevaBookEntidad.setValue(isbn, forKey: "isbn")
                            nuevaBookEntidad.setValue(book.title, forKey: "title")
                            nuevaBookEntidad.setValue(book.authors, forKey: "author")
                            nuevaBookEntidad.setValue(UIImagePNGRepresentation(book.cover), forKey:"cover")
                            
                            do{
                                try self.context?.save()
                                
                            }catch{
                            
                            }
                            
                           /********************************************************************************/
                            
                            completionHandler(book: book)
                            
                        } else {
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.isbnTextField.text = nil
                                ProgressView.sharedInstance.hideProgressView()
                            })
                            
                            self.showAlertDialog("Error", message: "El Libro con ISBN \(isbn) no Existe!")
                        }
                    }
                    
                } catch _ {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        ProgressView.sharedInstance.hideProgressView()
                    })
                    self.showAlertDialog("Error", message: "Respuesta invalida del servidor openlibrary.org")
                }
            }
            
        }).resume()
    }
    
    
    /*func crearAutor(autores: [String]) -> Set<NSObject>{
        
        var entidades = Set<NSObject>()
        
        for autor in autores{
            let autorEntidad = NSEntityDescription.insertNewObjectForEntityForName("Autor", inManagedObjectContext: self.context)
            autorEntidad.setValue(autor, forKey: "contenido")
            entidades.insert(autorEntidad)
        }
        
        return entidades
    }*/
    
    func showAlertDialog (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func findBookInTable (isbn: String) -> Book! {
        
        var bookFound : Book!
        
        for book in bookList.books {
            
            if isbn == book.isbnCode {
                
                bookFound = book
                break
            }
        }
        
        return bookFound
    }
    
    @IBAction func search (sender: UITextField) {
        
        sender.resignFirstResponder()
        
        if let isbn = sender.text where !isbn.isEmpty {
            
            if let book = findBookInTable(isbn) {
                
                self.book = book
                performSegueWithIdentifier("bookSegue", sender: sender)
                
            } else {
                
                ProgressView.sharedInstance.showProgressView(view)
                
                searchBook(isbn) { bookFound in
                    
                    self.book = bookFound
                    self.bookList.books.append(bookFound)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        ProgressView.sharedInstance.hideProgressView()
                        self.performSegueWithIdentifier("bookSegue", sender: sender)
                    })
                }
            }
        }
    }
    

}
