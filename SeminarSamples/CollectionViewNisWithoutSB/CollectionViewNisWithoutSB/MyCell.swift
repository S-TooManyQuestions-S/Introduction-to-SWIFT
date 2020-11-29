//
//  MyCell.swift
//  CollectionViewNisWithoutSB
//
//  Created by Андрей Самаренко on 30.10.2020.
//

import UIKit

class MyCell: UICollectionViewCell {
    let profileInmageButton: UIButton = {
        let control = UIButton()
        //цвет бэкграунда
        control.backgroundColor = UIColor.black
        //закругление углов
        control.layer.cornerRadius = 4 //18
        //растягиваем под размер кнопки (под закругленные границы)
        control.clipsToBounds = true
        //подгружаем изображение
        control.setImage(UIImage(named: "Profile"), for: .normal)
        //required!
        /*
         If you want to use Auto Layout to dynamically calculate the size and position of your view, you must set this property to false, and then provide a non ambiguous, nonconflicting set of constraints for the view.
         */
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    let dateLabel:UILabel = {
        let control = UILabel()
        //настраиваем шрифт
        control.font  = UIFont.systemFont(ofSize: 16, weight: .bold)
        //настраиваем выравнивание
        control.textAlignment = .center
        //настраиваем цвет текста
        control.textColor = UIColor.red
        //текст Lable'а
        control.text = "31"
        
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    let dayLabel:UILabel = {
        let control = UILabel()
        //настраиваем шрифт
        control.font  = UIFont.systemFont(ofSize: 12)
        //настраиваем выравнивание
        control.textAlignment = .center
        //настраиваем цвет текста
        control.textColor = UIColor.systemBlue
        //текст Lable'а
        control.text = "Fri"
        
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    let distanceLabel:UILabel = {
        let control = UILabel()
        //настраиваем шрифт
        control.font  = UIFont.systemFont(ofSize: 14)
        //настраиваем выравнивание
        control.textAlignment = .left
        //настраиваем цвет текста
        control.textColor = UIColor.lightGray
        //текст Lable'а
        control.text = "2000 miles"
        
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView(){
        self.backgroundColor = UIColor.black
        addSubview(profileInmageButton)
        addSubview(distanceLabel)
        addSubview(dayLabel)
        addSubview(dateLabel)
        
        //относительно левой границы окна отступим столько то поинтов
        //положительное значение вправо и вверх
        profileInmageButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        profileInmageButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        profileInmageButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        profileInmageButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        dateLabel.centerYAnchor.constraint(equalTo: profileInmageButton.centerYAnchor, constant: -6).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: profileInmageButton.centerXAnchor).isActive = true
        
        dayLabel.centerYAnchor.constraint(equalTo: profileInmageButton.centerYAnchor, constant: 9).isActive = true
        dayLabel.centerXAnchor.constraint(equalTo: profileInmageButton.centerXAnchor).isActive = true
        
    }
}
