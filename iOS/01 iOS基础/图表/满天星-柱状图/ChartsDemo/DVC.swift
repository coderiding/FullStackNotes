//
//  DVC.swift
//  ChartsDemo
//
//  Created by coderiding on 2020/11/30.
//

import UIKit

class DVC: UIViewController {
    
    lazy var pieChartView:DVPieChart = {
        let pieChartV = DVPieChart()
        return pieChartV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pieChartView)
        pieChartView.leftToSuperview(offset: 0)
        pieChartView.rightToSuperview(offset: 0)
        pieChartView.height(320)
        pieChartView.center(in: view)
        
        setupData()
    }
    
    func setupData() {
        let m1 = DVFoodPieModel()
        m1.rate = 0.78
        m1.name = "美团"
        m1.color = UIColor(red: 0.5, green: 0.84, blue: 1, alpha: 1.0)
        
        let m2 = DVFoodPieModel()
        m2.rate = 0.22
        m2.name = "饿了么"
        m2.color = UIColor(red: 255/255.0, green: 213/255.0, blue: 76/255.0, alpha: 1.0)
        
        pieChartView.dataArray = [m1,m2]
        pieChartView.draw()
    }
    
}
