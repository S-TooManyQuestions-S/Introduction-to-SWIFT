//
//  TaskViewController.swift
//  ToDoApp
//
//  Created by Андрей Самаренко on 05.03.2021.
//

import UIKit

class TaskViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let pickerController = UIImagePickerController()

    //nil в том случае, если работаем с новой задачей
    var currentTask:Task?
    //для выполнения делегируемой задачи сохранения конкретного task
    var saveDelegate:SaveTaskProtocol?
    
    //сохранение данных о задаче
    @IBAction func saveTask(_ sender: Any) {
            saveDelegate?.saveTask(name: self.getTaskName(),
                                   status: self.getTaskStatus(),
                                   description: self.getTaskDescription(),
                                   date: Date(),
                                   image: self.taskImage.image!,
                                   inputTask: currentTask)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editName(_ sender: Any) {
        taskHeader.text = taskInputName.text
    }
    
    private func getTaskName() -> String{
        guard
            let name:String = taskInputName.text,
            !name.isEmpty
        else{
            return "Unnamed task"
        }
        return name
    }
    
    private func getTaskDescription() -> String{
        guard
            let description:String = taskDescriptionInput.text,
            !description.isEmpty
            else {
            return "Task with no description provided"
        }
        return description
    }
    
    private func getTaskStatus() -> String{
        switch taskStatusInput.selectedSegmentIndex {
        case 0:
            return "Not Started"
        case 1:
            return "In Process"
        case 2:
            return "Done"
        default:
            return "no status"
        }
    }
    @IBAction func cancelTask(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerController.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        taskImage.addGestureRecognizer(tapGestureRecognizer)
        
        if let task:Task = currentTask{
            taskImage.image = UIImage(data: task.image)
            taskInputName.text = task.header
            
            switch task.status{
            case "Not Started":
                taskStatusInput.selectedSegmentIndex = 0
            case "In Process":
                taskStatusInput.selectedSegmentIndex = 1
            case "Done":
                taskStatusInput.selectedSegmentIndex = 2
            default:
                taskStatusInput.selectedSegmentIndex = 0
            }
            taskDescriptionInput.text = task.note
            taskHeader.text = task.header
        }
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
       changeImage()
        
    }
    
    private func changeImage(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
       
        alert.addAction(UIAlertAction(title: "Choose from gallery", style: .default , handler:{ (UIAlertAction)in
            self.chooseFromGallery()
        }))
        alert.addAction(UIAlertAction(title: "Make a photo", style: .default , handler:{ (UIAlertAction)in
            self.makeAPhoto()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func chooseFromGallery(){
        //проверка доступности галлереи
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "Photo library is currently unvailable", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Resume", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
    Функция реализующая логику установки фотографии профиля при выборе пользователем категории "make a photo"
    */
    func makeAPhoto(){
        //проверяем доступна ли камера
        if (UIImagePickerController.isSourceTypeAvailable(.camera)){
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        } else {
            //если камера недоступна - выводим предупреждение с соответствующей пояснительной информацией
            let alert = UIAlertController(title: "Warning", message: "Camera is currently unvailable", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Resume", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
    Функция для обработки выбора пользователем фотографии из галлереи (или сделанное фото) (отображение ее в качестве текущей фотографии профиля)
     
    **Parameters:**
        - picker: контроллер для обработки выбора
        - info: информация о выборе
    */
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        pickerController.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage{
            taskImage.image = image
        }
    }
    
    
    
    @IBOutlet weak var taskHeader: UILabel!
    @IBOutlet weak var taskImage: UIImageView!
    @IBOutlet weak var taskInputName: UITextField!
    @IBOutlet weak var taskStatusInput: UISegmentedControl!
    @IBOutlet weak var taskDescriptionInput: UITextView!
}
