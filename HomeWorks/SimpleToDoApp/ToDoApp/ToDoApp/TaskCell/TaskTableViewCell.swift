//
//  TaskTableViewCell.swift
//  ToDoApp
//
//  Created by Андрей Самаренко on 05.03.2021.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var taskHeading: UILabel!
    @IBOutlet weak var taskTimeCreation: UILabel!
    @IBOutlet weak var taskStatus: UILabel!
    @IBOutlet weak var taskImage: UIImageView!
    
    func configure(task: Task){
        taskHeading.text = task.header
        taskStatus.text = task.status
        setTaskeDate(with: task.date)
        taskImage.image = UIImage(data: task.image)
        setStatusColor(status: task.status)
    }
    
    private func setStatusColor(status:String){
        switch status{
        case "Done":
            taskStatus.textColor = .green
        case "Not Started":
            taskStatus.textColor = .red
        case "In Process":
            taskStatus.textColor = UIColor(red: 250/255.0, green: 223/255.0, blue: 75/255.0, alpha: 1)
        default:
            break
        }
    }
    
    override func prepareForReuse() {
        taskHeading.textColor = .black
    }
    
    private func setTaskeDate(with rawDate:Date?){
        guard let date:Date = rawDate else{
            taskTimeCreation.text = ""
            return
        }
        
        let dateFormatter = DateFormatter()
        if Calendar.current.compare(Date(), to: date, toGranularity: .day) == .orderedDescending{
            dateFormatter.dateFormat = "dd-MMM"
        }else{
            dateFormatter.dateFormat = "HH:mm"
        }
        
        taskTimeCreation.text =  dateFormatter.string(from: date)
    }
}
