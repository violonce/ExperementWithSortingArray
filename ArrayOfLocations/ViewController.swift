//
//  ViewController.swift
//  OptimizedArray
//
//  Created by Илья on 15.08.2023.
//

import UIKit
import SnapKit
import KDTree

class ViewController: UIViewController {
    
    private var HUDView: UIView = UIView()
    private var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)

    var citiesModel: CitiesModel?
    var wayModels: CitiesModel?
    var service: SearchService = SearchService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        activityIndicator.isHidden = false
        activityIndicator.color = .darkGray
        view.addSubview(self.HUDView)
        HUDView.addSubview(self.activityIndicator)

        HUDView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self.HUDView)
        }

        showHUD()
        getData()
        configurateTree()
        tryToFindPoints()
        hideHUD()
    }

    private func getData() {
        if let url = Bundle.main.url(forResource: "cities10k", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                self.citiesModel = try JSONDecoder().decode(CitiesModel.self, from: data)
            } catch {
                print("error:\(error)")
            }
        }
        if let url = Bundle.main.url(forResource: "wayPoints100", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                self.wayModels = try JSONDecoder().decode(CitiesModel.self, from: data)
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    private func configurateTree() {
        guard let elements = self.citiesModel?.cities else { return }
        guard let wayElements = self.wayModels?.cities else { return }
        service.configurateWith(elements: elements, wayElements: wayElements)
    }
    
    private func tryToFindPoints() {
        guard let elements = wayModels?.cities else { return }
        var pointsInRadiusTree: [PointModel] = []
        var pointsInRadiusSet: [PointModel] = []
        var pointsInRadiusArray: [PointModel] = []
        let clockTree = SuspendingClock()
        let timeTree = clockTree.measure {
            pointsInRadiusTree = service.findPointsInRadiusUsingTree(radius: 50)
        }
//        print(pointsInRadius)
        print(timeTree)
        
        let clockSet = SuspendingClock()
        let timeSet = clockSet.measure {
            pointsInRadiusSet = service.findPointsInRadiusUsingSet(radius: 50)
        }
//        print(pointsInRadius)
        print(timeSet)
        
        let clockArray = SuspendingClock()
        let timeArray = clockArray.measure {
            pointsInRadiusArray = service.findPointsInRadiusUsingArray(radius: 50)
        }
//        print(pointsInRadius)
        print(timeArray)
        
        //
        //Получается для 10k точек и более дерево быстрей всего
        //
        //Дерево писать не стал, так как есть уже готовые решения. Зачем изобретать велосипед.
        
        //Если в пути 100 точек
        //Время для 10k точек
        //дерево - 0.064058574 seconds
        //сет - 0.140813043 seconds
        //массив - 0.27929771 seconds
        
        //Время для 100k точек
        //дерево - 0.697279197 seconds
        //сет - 2.372985368 seconds
        //массив - 2.513271734 seconds
        
        //Если в пути 10k точек
        //Время для 10k точек
        //дерево - 5.507406282 seconds
        //сет - 11.524143875 seconds
        //массив - 23.710353416 seconds
        
        //Время для 100k точек
        //дерево - 86.08578608500001 seconds
        //сет - 244.283170812 seconds
        //массив - 266.182132036 seconds
        
        
        //Можно сделать вывод, что дерево быстрей всего. Но на построение дерева уйдут некоторые ресурсы памяти.
    }

    public func showHUD() {
        DispatchQueue.main.async { [weak self] in
            self!.view.bringSubviewToFront(self!.HUDView)
            self!.activityIndicator.alpha = 1
            self!.activityIndicator.startAnimating()
            UIView.animate(withDuration: 0.5) { [weak self] in
                self!.HUDView.alpha = 1
            }
        }
    }

    public func hideHUD() {
        DispatchQueue.main.async { [weak self] in
            self!.activityIndicator.stopAnimating()
            UIView.animate(withDuration: 0.5) { [weak self] in
                self!.HUDView.alpha = 0
            }
        }
    }

    
}

