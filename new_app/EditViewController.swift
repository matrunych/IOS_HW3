//
//  EditViewController.swift
//  new_app
//
//  Created by Olena on 07.11.2020.
//  Copyright © 2020 Olena. All rights reserved.
//

import UIKit

protocol EditNoteDelegate {
    func updateNote(newTitle: String, newBody: String)
}

class EditViewController: UIViewController, UITextViewDelegate{

    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        self.bodyTextValue.resignFirstResponder()
        self.saveButton.isEnabled = false
    }
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var bodyTextValue: UITextView!
    var editNoteDelegate: EditNoteDelegate?
    
    var noteBody: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bodyTextValue.delegate = self
        self.bodyTextValue.text = noteBody
        self.bodyTextValue
        .becomeFirstResponder()
        
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        if self.editNoteDelegate != nil {
            self.editNoteDelegate?.updateNote(newTitle: self.getNotesName(), newBody: self.bodyTextValue.text)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.saveButton.isEnabled = true

    }
    
    func getNotesName() -> String{
        let allNotes = self.bodyTextValue.text.components(separatedBy: "\n")
        for note in allNotes{
            if note.trimmingCharacters(in: CharacterSet.whitespaces).count > 0 {
                return note
            }
        }
        return self.navigationItem.title ?? ""
    }

}
