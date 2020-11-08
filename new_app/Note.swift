import Foundation


struct Note {
    var noteId: Int
    var name: String
    var text: String
    var tags : Set<String>
    var isFavourite: Bool = false
    var creationDate: Date
    var deletionDate: Date?
    
    init(noteId: Int, name: String = "", text: String = ""){
        self.noteId = noteId
        self.name = name
        self.text = text
        self.tags = []
        self.creationDate = Date()
    }
    
    mutating func makeFavourite(){
        self.isFavourite = !self.isFavourite
    }
    
    mutating func makeDeleted(){
        self.deletionDate = Date()
    }
}


class NoteDataManager{
    var notes = [Note]()
    var deletedNotes = [Note]()
    var id: Int
    
    init() {
        self.notes = []
        self.deletedNotes = []
        self.id = 0
    }
    
    func createNote(name: String, text: String, tags: Set<String>){
        notes.append(Note(noteId: id, name: name, text: text))
        id += 1
    }
    
    func deleteNote(noteId: Int){
        let index = self.notes.firstIndex(where: { $0.noteId == noteId })!
        self.notes[index].makeDeleted()
        self.deletedNotes.append(self.notes[index])
        self.notes.remove(at: index)
    }
    
    func updateName(noteId: Int, newName: String){
        let index = self.notes.firstIndex(where: { $0.noteId == noteId })!
        self.notes[index].name = newName
    }
    
    func updateText(noteId: Int, newText: String){
        let index = self.notes.firstIndex(where: { $0.noteId == noteId })!
        self.notes[index].text = newText
    }
    
    func updateTags(noteId: Int, newTags: Set<String>){
        let index = self.notes.firstIndex(where: { $0.noteId == noteId })!
        self.notes[index].tags = newTags
    }
    
    func addTag(noteId: Int, tag: String){
        let index = self.notes.firstIndex(where: { $0.noteId == noteId })!
        self.notes[index].tags.insert(tag)
    }
    
    func makeFavourite(noteId: Int){
        let index = self.notes.firstIndex(where: { $0.noteId == noteId })!
        self.notes[index].makeFavourite()
    }
    
    func searchByName(name: String) -> Int?{
        for i in 0..<self.notes.count {
            if self.notes[i].name == name{
                return self.notes[i].noteId
            }
        }
        return nil
    }
    
    func sortByNameDate(){
        self.notes = self.notes.sorted{n1, n2 in
            return (n1.name.lowercased(), n1.creationDate) < (n2.name.lowercased(), n2.creationDate)}
    }
    
    func isPresented(name: String) -> Bool{
        let results = self.notes.filter { $0.name == name }
        let exists = results.isEmpty == false
        return exists
    }
    
    func filterByDate(filterDate: Date){
        self.notes = self.notes.filter({($0.creationDate == filterDate)})
    }
    
    func applyFilter(_ filter: (Note) -> Bool) {
        self.notes = self.notes.filter(filter)
    }
    
    func filterByFavourite(){
        self.notes = self.notes.filter({$0.isFavourite == true})
    }
        
}


//var man = NoteDataManager()
//man.createNote(name: "To buy", text: "buy fruits", tags: ["food", "fruits", "like"])
//man.createNote(name: "Homework", text: "deadline at 23.59", tags: ["ios", "os", "no chill"])
//man.createNote(name: "Films", text: "Leon, Pink Panther", tags: ["killer", "plant", "diamond", "chill"])
//man.createNote(name: "flowers", text: "I need flowers", tags: ["roses", "tulips", "chamomile", "like"])
//
//man.makeFavourite(noteId: 2)
//man.makeFavourite(noteId: 3)
//
//print(man.isPresented(name: "Homework"))
//
//man.sortByNameDate()
//
//man.filterByFavourite()
//print(man.notes)
//
//man.applyFilter({$0.tags.contains("like")})
//print(man.notes)
