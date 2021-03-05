//
//  ViewController.swift
//  ToDoApp
//
//  Created by Андрей Самаренко on 28.02.2021.
//


import CoreData
import UIKit

class RootController: UIViewController {
    
    private let cellIdentifier = String(describing: TaskTableViewCell.self)

    @IBOutlet weak var currentFilter: UISegmentedControl!
    
    private func getCurrentPredicate(request: NSFetchRequest<Task>, segment: Int){
        switch segment{
        case 1:
            request.predicate = NSPredicate(format: "status = %@", "Not Started")
        case 2:
            request.predicate = NSPredicate(format: "status = %@", "In Process")
        case 3:
            request.predicate = NSPredicate(format: "status = %@", "Done")
        default:
            break
        }
    }
    
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        let request = Task.createFetchRequest()
        getCurrentPredicate(request: request, segment: sender.selectedSegmentIndex)
        do{
            try tasks = container.viewContext.fetch(request)
            print("Got \(tasks.count) tasks!")
            taskTable.reloadData()
        }catch{
            print("Fetch failed")
        }
        
    }
    
    
    @IBAction func addButtonPressConfirmed(_ sender: Any) {
        performSegue(withIdentifier: "addTask", sender: nil)
    }
    
    @IBOutlet weak var taskTable: UITableView!
    var container: NSPersistentContainer!
    
    var tasks = [Task]()

    override func viewDidLoad() {
        super.viewDidLoad()
        container = NSPersistentContainer(name: "TaskDataModel")
        container.loadPersistentStores { storeDescription, error in self.container.viewContext.mergePolicy =
        NSMergeByPropertyObjectTrumpMergePolicy
        if let error = error {
        print("Unresolved error \(error)") }
        }
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        taskTable.delegate = self
        taskTable.dataSource = self
        taskTable.register(UINib(nibName: String(describing: TaskTableViewCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        
        title = "ToDo Tasks"
        loadSavedData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "addTask":
            guard
                let destinationController = segue.destination as? TaskViewController
            else {
                return
            }
            destinationController.saveDelegate = self
        case "ShowTask":
            guard
                let destinationController = segue.destination as? TaskViewController,
                let sentTask = sender as? Task
                else {
                return
            }
            destinationController.saveDelegate = self
            destinationController.currentTask = sentTask
        default:
            return
        }
    }
}


extension RootController{
    func setConnectionToDB(){
        container = NSPersistentContainer(name: "Task")
        
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error{
                print("Error occuried while loading presistent stores: \(error)")
            }
        })
    }
    
    func saveContext(){
        if container.viewContext.hasChanges{
            do{
                try container.viewContext.save()
            }catch{
                print("Error occuried while saving changes to DB: \(error)")
            }
        }
    }
    
    func loadSavedData(){
        let request = Task.createFetchRequest()
        getCurrentPredicate(request: request, segment: currentFilter.selectedSegmentIndex)
        do{
            try tasks = container.viewContext.fetch(request)
            print("Got \(tasks.count) tasks!")
        }catch{
            print("Fetch failed")
        }
        
    }
}

protocol SaveTaskProtocol{
    func saveTask(name: String, status: String, description: String, date: Date, image: UIImage, inputTask:Task?)
}

extension RootController : SaveTaskProtocol{
    
    func saveTask(name: String, status: String, description: String, date: Date, image: UIImage, inputTask:Task?) {
        let task = inputTask == nil ? Task(context: container.viewContext) : inputTask!
        task.date = date
        task.header = name
        task.note = description
        task.status = status
        task.image = image.pngData()!
        saveContext()
        loadSavedData()
        taskTable.reloadData()
    }
}


extension RootController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataCell = tasks[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TaskTableViewCell
        else{
            return UITableViewCell()
        }
        cell.configure(task: dataCell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
                   container.viewContext.delete(task)
                   tasks.remove(at: indexPath.row)
                   tableView.deleteRows(at: [indexPath], with: .fade)
                   saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return "Tasks"
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskTable.deselectRow(at: indexPath, animated: true)
        
        let task = tasks[indexPath.row]
        performSegue(withIdentifier:"ShowTask", sender: task)
    }
}

