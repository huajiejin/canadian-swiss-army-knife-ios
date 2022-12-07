//
//  UnitConverterViewController.swift
//  Canadian Swiss Army Knife
//
//  Created by Jin on 2022-12-04.
//

import UIKit

class UnitConverterViewController: UIViewController {
    
    @IBOutlet weak var unitConverterCollectionView: UICollectionView!
    var unitCellMetaDataList = [["Length", "line.diagonal.arrow"], ["Area", "rectangle"], ["Volume", "cup.and.saucer"], ["More", "table.badge.more"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        unitConverterCollectionView.delegate = self
        unitConverterCollectionView.dataSource = self
    }

}

extension UnitConverterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let unitCellMetaData = unitCellMetaDataList[indexPath.row]
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if unitCellMetaData[0] == "Length" {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LengthUnitConverterDetail")
            self.present(nextViewController, animated:true, completion:nil)
        } else {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WIP")
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
}

extension UnitConverterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unitCellMetaDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = unitConverterCollectionView.dequeueReusableCell(withReuseIdentifier: "UnitConverter", for: indexPath) as! UnitConverterCollectionViewCell
        let unitCellMetaData = unitCellMetaDataList[indexPath.row]
        cell.title.text = unitCellMetaData[0]
        cell.image.image = UIImage(systemName: unitCellMetaData[1])
        return cell
    }
    
    
}

