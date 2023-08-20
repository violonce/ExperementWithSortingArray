//
//  SearchService.swift
//  OptimizedArray
//
//  Created by Илья on 15.08.2023.
//

import UIKit
import KDTree

class SearchService: NSObject {
    
    var treePoints: KDTree<PointModel> = KDTree(values: [])
    var treeWay: KDTree<PointModel> = KDTree(values: [])
    var elements: Set<PointModel> = Set()
    var elementsWay: Set<PointModel> = Set()
    var arrayElements: [PointModel] = []
    var arrayElementsWay: [PointModel] = []
    
    func configurateWith(elements: [PointModel] = [], wayElements: [PointModel]) {
        self.treePoints = KDTree(values: elements)
        self.treeWay = KDTree(values: wayElements)
        self.elements = Set(elements)
        self.elementsWay = Set(wayElements)
        self.arrayElements = elements
        self.arrayElementsWay = wayElements
    }
    
    func findPointsInRadiusUsingTree(radius: Double) -> [PointModel] {
        var allPoints: [PointModel] = []
        
        treeWay.forEach { point in
            let points = treePoints.allPoints(within: radius, of: point)
            allPoints.append(contentsOf: points)
        }
        return allPoints
    }
    
    func findPointsInRadiusUsingSet(radius: Double) -> [PointModel] {
        var allPoints: [PointModel] = []
        
        elementsWay.forEach { model in
            let points = elements.filter{ point in
                return model.squaredDistance(to: point) <= radius
            }
            allPoints.append(contentsOf: points)
        }
       
        return allPoints
    }
    
    func findPointsInRadiusUsingArray(radius: Double) -> [PointModel] {
        var allPoints: [PointModel] = []
        arrayElementsWay.forEach { model in
            let points = arrayElements.filter{ point in
                return model.squaredDistance(to: point) < radius
            }
            allPoints.append(contentsOf: points)
        }
        
        return allPoints
    }
    
}
