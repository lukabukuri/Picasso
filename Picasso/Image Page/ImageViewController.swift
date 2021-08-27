//
//  ImageViewController.swift
//  Luka_Bukuri_Homework44
//
//  Created by Luka Bukuri on 27.08.21.
//

import UIKit

class ImageViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var paint: UIImage?
    var imageURL: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = paint
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(onTrash))
        navigationItem.rightBarButtonItem = deleteButton
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        navigationController?.navigationBar.isHidden = true
    }
    
    @objc func onTrash()
    {
        guard let filePath = imageURL?.path else { return }
        do{
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: filePath) {
                try fileManager.removeItem(atPath: filePath)
                navigationController?.popViewController(animated: true)
            } else {
                print("File does not exist")
            }
        } catch {
            print(error)
        }
    }
    
    
}
