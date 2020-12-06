//
//  NotesTableViewController.swift
//  new_app
//
//  Created by Olena on 07.11.2020.
//  Copyright © 2020 Olena. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController, EditNoteDelegate {
    
    
    @IBAction func addNoteButtonTapped(_ sender: UIBarButtonItem) {
        self.notesManager.createNote(name: "", text: "", tags: [])
        self.tableView.reloadData()
        self.idx += 1
        performSegue(withIdentifier: "AddNoteScreen", sender: nil)
        
    }

    var notesManager = NoteDataManager()
    var idx = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notesManager.notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)
        
        cell.textLabel?.text = self.notesManager.notes[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.idx = indexPath.row
        performSegue(withIdentifier: "AddNoteScreen", sender: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDelete = self.notesManager.notes[indexPath.row]
            self.notesManager.deleteNote(noteId: toDelete.noteId)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let toDelete = self.notesManager.notes[indexPath.row]
            self.notesManager.deleteNote(noteId: toDelete.noteId)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.idx -= 1
        }

        let favourite = UITableViewRowAction(style: .normal, title: "Favourite") { (action, indexPath) in
            let toFavourite = self.notesManager.notes[indexPath.row]
            self.notesManager.makeFavourite(noteId: toFavourite.noteId)
        }

        favourite.backgroundColor = UIColor.blue

        return [delete, favourite]
    }
    
    func updateNote(newTitle: String, newBody: String){
//        self.notesManager.notes[idx].name = newTitle
//        self.notesManager.notes[idx].text = newBody

        let noteId = self.notesManager.notes[idx].noteId
        self.notesManager.updateName(noteId: idx, newName: newTitle)
        self.notesManager.updateText(noteId: idx, newText: newBody)

        self.tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destvc = segue.destination as?
        EditViewController
        destvc?.title = self.notesManager.notes[idx].name
        destvc?.noteBody = self.notesManager.notes[idx].text
        destvc?.editNoteDelegate = self 

    }
    
}
