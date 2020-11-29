//
//  ViewController.swift
//  CollectionViewNisWithoutSB
//
//  Created by Андрей Самаренко on 30.10.2020.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!
    
    //айди ячейки
    let cellId = "Cell"
    
    //количество ячеек в таблице
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    //ячейка таблицы (представление)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MyCell
    
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //положение на экране
        let layOut:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layOut.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layOut.itemSize = CGSize(width: view.frame.width, height: view.frame.height/3)
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layOut)
        //объект нашего окна будет делегатом для нашего окна
        collectionView.dataSource = self
        //делегат обрабатывает события collectionView
        collectionView.delegate = self
        
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: cellId)
        //индикатор скролла
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = UIColor.gray
        self.view.addSubview(collectionView)
    }


}

