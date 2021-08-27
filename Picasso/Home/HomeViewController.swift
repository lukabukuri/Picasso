//
//  ViewController.swift
//  Luka_Bukuri_Homework44
//
//  Created by Luka Bukuri on 01.07.21.
//

import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let fileManager = FileManager.default
    private var docuemntsDirectoryURL: URL? {
        try? fileManager.url(for: .documentDirectory,
                             in: .userDomainMask,
                             appropriateFor: nil,
                             create: false)
    }
 
    private var orderedURLs : [URL]?
    
    var images = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        navigationController?.navigationBar.barTintColor = .darkGray
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.isTranslucent = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(class: GalleryCollectionViewCell.self)
        collectionView.backgroundColor = .lightGray
    }

    
    override func viewWillAppear(_ animated: Bool) {
        images.removeAll()
        
        orderedURLs = try? FileManager.default.contentsOfDirectory(at: docuemntsDirectoryURL!, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles).sorted(by: {
            if let date1 = try? $0.resourceValues(forKeys: [.creationDateKey]).creationDate,
               let date2 = try? $1.resourceValues(forKeys: [.creationDateKey]).creationDate {
                return date1 < date2
            }
            return false
        })
        guard let orderedURLs = orderedURLs else { return }
        for image in orderedURLs
        {
            if fileManager.fileExists(atPath: image.path)
            {
                print("fezi", image.path)
                images.append(UIImage(contentsOfFile: image.path)!)
            }
        }
        self.collectionView.reloadData()
        
    }

    
    
    @IBAction func onDraw(_ sender: UIButton)
    {

        coordinator?.proceedToDraw()
        
    }
    
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.deque(GalleryCollectionViewCell.self, for: indexPath)
        cell.galleryImageView.image = images[indexPath.row]
        cell.backgroundColor = .white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width / 3) - 3,
                      height: (view.frame.size.width / 3) - 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        guard let url = orderedURLs?[indexPath.row] else { return }
        coordinator?.proceedToBrowse(paint: image, url: url)
    }
    
    
    
    
}

