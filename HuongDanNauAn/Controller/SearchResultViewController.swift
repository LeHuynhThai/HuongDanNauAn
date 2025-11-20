//
//  SearchResultViewController.swift
//  HuongDanNauAn
//
//  Created by user on 2025/11/18.
//
import UIKit

class SearchResultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    var searchResults: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()

        // Fake Data
        searchResults = ["Món 1", "Món 2", "Món 3", "Món 4", "Món 5", "Món 6"]

        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecipeCell
        
        cell.RecipeName.text = searchResults[indexPath.row]
        cell.RecipeImageView.image = UIImage(named: "1") // ảnh giả
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 10) / 2
        return CGSize(width: size, height: size)
    }
}
