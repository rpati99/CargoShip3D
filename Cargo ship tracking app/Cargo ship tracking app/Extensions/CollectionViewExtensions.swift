//
//  CollectionViewExtensions.swift
//  Cargo ship tracking app
//
//  Created by Rachit Prajapati on 09/11/21.
//

import Foundation
import UIKit

// MARK: -  UICollectionViewDelegate & UICollectionViewDataSource methods

extension ShipDetailsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return details.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellid", for: indexPath) as! ContainerCell
        cell.containerInfo = details[indexPath.row]
        cell.transform = CGAffineTransform(scaleX: 0.9, y: 1.0)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
    

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let collectionView = scrollView as? UICollectionView {
            for cell in collectionView.visibleCells {
                UIView.animate(withDuration: 0.2) {
                    cell.layer.position.y += 100
                } completion: { (true) in
                        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 2.5, initialSpringVelocity: 1.0, options: [.curveEaseOut]) {
                            cell.layer.position.y -= 100
                    }
                }
            }
        }
    }
}

