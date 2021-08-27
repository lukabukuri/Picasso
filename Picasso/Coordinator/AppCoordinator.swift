//
//  AppCoordinator.swift
//  Luka_Bukuri_Homework44
//
//  Created by Luka Bukuri on 01.07.21.
//

import UIKit

final class AppCoordinator: CoordinatorProtocol
{
   
    
    private var window: UIWindow?
    private var navigationController: UINavigationController?
    
    init(_ window: UIWindow?, navigationController: UINavigationController?) {
        self.window = window
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeViewController.instantiateFromStoryboard()
        navigationController?.pushViewController(vc, animated: true)
        vc.coordinator = self
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func proceedToDraw() {
        let vc = PaintViewController.instantiateFromStoryboard()
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func proceedToBrowse(paint: UIImage, url: URL) {
        let vc = ImageViewController.instantiateFromStoryboard()
        vc.coordinator = self
        vc.paint = paint
        vc.imageURL = url
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
