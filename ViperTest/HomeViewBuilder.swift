//
//  HomeViewBuilder.swift
//  ViperTest
//
//  Created by De La Cruz, Eduardo on 25/10/2018.
//  Copyright © 2018 De La Cruz, Eduardo. All rights reserved.
//

import UIKit

// MARK: - Home View Protocol

protocol HomeView: class {
    
    func loadCurrentColor(rgb: (CGFloat, CGFloat, CGFloat)) -> (Void)
}

// MARK: - Home Home Use Case

protocol HomeUseCase: class {
    
    func loadCurrentColor() -> (CGFloat, CGFloat, CGFloat)
    func saveCurrentColor(rgb: (CGFloat, CGFloat, CGFloat)) -> ()
}

// MARK: - Home Interactor

class HomeInteractor: HomeUseCase {
    
    var appColorDataAccessObject: AppColorDataAccessObject?
    
    init(dataAccessObject: AppColorDataAccessObject = AppColorDataAccessObject()) {
        
        appColorDataAccessObject = dataAccessObject
    }
    
    func loadCurrentColor() -> (CGFloat, CGFloat, CGFloat) {
        
        let currentRgb = appColorDataAccessObject?.fetch()
        
        return currentRgb!
    }
    
    func saveCurrentColor(rgb: (CGFloat, CGFloat, CGFloat)) {
        
        appColorDataAccessObject?.save(rgb: rgb)
    }
}

// MARK: - Home View Wireframe

protocol HomeViewWireframe: class { // Navigation
    
    var viewController: UIViewController? { get }
}

// MARK: - Home View Router

class HomeViewRouter: HomeViewWireframe { // Navigation
    
    var viewController: UIViewController?
}

// MARK: - Home View Presentation

protocol HomeViewPresentation: class {
    
    var view: HomeView? { get }
    var router: HomeViewWireframe? { get }
    var interactor: HomeUseCase? { get }
    
    func onLoadCurrentColor() -> ()
    func onColorValueChange(rgb: (CGFloat, CGFloat, CGFloat)) -> ()
}

// MARK: - Home View Presenter

class HomeViewPresenter: HomeViewPresentation {
    
    weak var view: HomeView?
    var router: HomeViewWireframe?
    var interactor: HomeUseCase?
    
    func onLoadCurrentColor() {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let `self` = self else { return }
            
            let currentRgb = self.interactor?.loadCurrentColor()
            
            DispatchQueue.main.async {
                
                self.view?.loadCurrentColor(rgb: currentRgb!)
            }
        }
    }
    
    func onColorValueChange(rgb: (CGFloat, CGFloat, CGFloat)) -> (Void) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            guard let `self` = self else { return }
            
            self.interactor?.saveCurrentColor(rgb: rgb)
        }
    }
}

// MARK: - Home View Builder

class HomeViewBuilder {
    
    static func assembleModule() -> UIViewController? {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "homeViewController") as? HomeViewController
        let presenter = HomeViewPresenter()
        let interactor = HomeInteractor()
        let router = HomeViewRouter()
        
        view?.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        router.viewController = view
        
        return view
    }
}
