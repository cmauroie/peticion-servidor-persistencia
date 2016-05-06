//
//  BookDetailsViewController.swift
//  Consulta ISBN Persistencia
//
//  Created by Carlos Mauricio Idárraga Espitia on 5/4/16.
//  Copyright © 2016 Carlos Mauricio Idárraga Espitia. All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController {
    
    var book : Book!
    
    @IBOutlet weak var bookTitle : UILabel!
    @IBOutlet weak var bookISBN : UILabel!
    @IBOutlet weak var bookAuthors : UILabel!
    @IBOutlet weak var bookCover : UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        bookCover.layer.borderColor = UIColor.blackColor().CGColor
        bookCover.layer.borderWidth = 1.0
        bookTitle.text = self.book.title
        bookISBN.text = "ISBN: " + self.book.isbnCode
        bookAuthors.text = self.createAuthorList(self.book.authors)
        bookCover.image = self.book.cover
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func createAuthorList (authors: [String]) -> String {
        
        var prefix = String()
        var authorList = String()
        
        for author in authors {
            
            authorList = authorList + prefix + author
            prefix = "\n"
        }
        
        return authorList
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
