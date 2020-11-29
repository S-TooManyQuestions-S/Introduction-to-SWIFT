import CoreData
import UIKit
import SwiftyJSON
//cmd+A + cmd+I
class ViewController: UITableViewController {
    //специальный контейнер для работы с активными данными
    //перед их сохранением в базу данных
    var container: NSPersistentContainer!
    
    var commits = [Commit]()
    
    var commitPredicate: NSPredicate?
    
    override func numberOfSections(in tableView: UITableView) -> Int {
    return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return commits.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Commit", for: indexPath)
    
    let commit = commits[indexPath.row]
        cell.textLabel!.text = commit.message
        cell.detailTextLabel!.text = "By \(commit.author.name) on \(commit.date.description)"
    return cell }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(changeFilter))
        //NSPersistentContainer выполняет следующие функции
        /*
         1. Создание NSManagedObjectModel из описанной модели данных
         2. Создание экземпляра класса NSPersistentStoreCoordinator, чья основная функция - чтение и запись данных на диск
         3. Задание ссылки на удаленную SQLite базу данных для хранения данных (CommitsApp.sqlite)
         4. Установление связи между NSPersistentStoreCoordinator и базой данных
         5. Создание ссылки для работы с координатором (NSManagedObjectContext)
         */
        container = NSPersistentContainer(name: "CommitsApp")
        //загружает или создает базу данных (если ее не существует)
        container.loadPersistentStores { storeDescription, error in self.container.viewContext.mergePolicy =
        NSMergeByPropertyObjectTrumpMergePolicy
        if let error = error {
        print("Unresolved error \(error)") }
        }
        
        performSelector(inBackground: #selector(fetchCommits), with: nil)
        
        loadSavedData()
    }
    
    @objc func fetchCommits() {
        if let data = try? Data(contentsOf: URL(string: "https://api.github.com/repos/apple/swift/commits?per_page=100")!) {

            //в туториале не хэндлится исключение -
            //считаю, что значение всегда не nil
            
            //скачивание информации в виде JSON
            let jsonCommits = try! JSON(data:data)
            //получение реузльтатов парсинга в виде массива значений (с помощью
            //Swifty-JSON
            let jsonCommitArray = jsonCommits.arrayValue
            //уведомление о результате операции
            print("Received \(String(describing: jsonCommitArray.count)) new commits.")
            //асинхронно выполняем
            DispatchQueue.main.async { [unowned self] in for jsonCommit in jsonCommitArray {
                
                let commit = Commit(context: self.container.viewContext)
                //непосредственно преобразование в объект
                self.configure(commit: commit, usingJSON: jsonCommit)
            }
            self.saveContext()
            loadSavedData()
            }
            
        }
    }
    //метод для сохранения изменений после работы с активными данными
    func saveContext() {
        //если изменения зарегестрированы - коммит в базу данных
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                //отслеживание ошибки
                print("An error occurred while saving: \(error)") }
        } }
    
    func configure(commit: Commit, usingJSON json: JSON) {
        //Note: SwiftyJSON - не выкинет исключения если произойдет ошибка парсинга, а просто вернет пустую строку,что делает использование опциональных типов данных излишним
        //получение значения поля sha
        commit.sha = json["sha"].stringValue
        //получение значения поля message (элемента массива commit)
        commit.message = json["commit"]["message"].stringValue
        //получение значения поля html_url
        commit.url = json["html_url"].stringValue
        //задание форматтера для определенного типа даты
        let formatter = ISO8601DateFormatter()
        //получение даты путем применения форматтера, в противном случае - возвращаем текущую дату (если возникли ошибки)
        commit.date = formatter.date(from: json["commit"]["comitter"] ["date"].stringValue) ?? Date()
        var commitAuthor: Author!
        // see if this author exists already
        let authorRequest = Author.createfetchRequest()
        authorRequest.predicate = NSPredicate(format: "name == %@", json["commit"] ["committer"]["name"].stringValue)
        if let authors = try? container.viewContext.fetch(authorRequest) { if authors.count > 0 {
                // we have this author already
        commitAuthor = authors[0] }
        }
        if commitAuthor == nil {
        // we didn't find a saved author - create a new one!
            let author = Author(context: container.viewContext)
            author.name = json["commit"]["committer"]["name"].stringValue
            author.email = json["commit"]["committer"]["email"].stringValue
            commitAuthor = author
            }
            // use the author, either saved or new
        commit.author = commitAuthor

    }

    func loadSavedData() {
        let request = Commit.createfetchRequest()
        //специальный дескриптор для сортировки по конкретному значению (key)
//        let sort = NSSortDescriptor(key: "date", ascending: false)
        //добавление дескриптора в массив дескрипторов
        request.predicate = commitPredicate

        do {
            //отображаем активные данные согласно условию
            commits = try container.viewContext.fetch(request)
            print("Got \(commits.count) commits")
            //обновляем информацию в таблице
            tableView.reloadData()
        } catch {
            print("Fetch failed") }
        }

    @objc func changeFilter() {
    let ac = UIAlertController(title: "Filter commits...", message: nil,
    preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Show only fixes", style: .default) { [unowned self] _ in
        self.commitPredicate = NSPredicate(format: "message CONTAINS[c] 'fix'")
        self.loadSavedData() })
        ac.addAction(UIAlertAction(title: "Ignore Pull Requests", style: .default) { [unowned self] _ in
        self.commitPredicate = NSPredicate(format: "NOT message BEGINSWITH 'Merge pull request'")
        self.loadSavedData() })
        ac.addAction(UIAlertAction(title: "Show only recent", style: .default) { [unowned self] _ in
        let twelveHoursAgo = Date().addingTimeInterval(-43200)
        self.commitPredicate = NSPredicate(format: "date > %@", twelveHoursAgo as NSDate)
        self.loadSavedData() })
        ac.addAction(UIAlertAction(title: "Show all commits", style: .default) { [unowned self] _ in
        self.commitPredicate = nil
        self.loadSavedData() })
        ac.addAction(UIAlertAction(title: "Show only Durian commits", style: .default) { [unowned self] _ in
        self.commitPredicate = NSPredicate(format: "author.name == 'Joe Groff'")
        self.loadSavedData() })
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
       present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
    IndexPath) {
    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
    vc.detailItem = commits[indexPath.row]
    navigationController?.pushViewController(vc, animated: true)
        
    }
     }
}

