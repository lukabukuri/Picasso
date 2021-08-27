//
//  CoordinatorProtocol.swift
//  Luka_Bukuri_Homework44
//
//  Created by Luka Bukuri on 01.07.21.
//

import UIKit

protocol CoordinatorProtocol {
   
    init(_ window: UIWindow?, navigationController: UINavigationController?)
    func start()
    func proceedToDraw()
    func proceedToBrowse(paint: UIImage, url: URL)
    
}

