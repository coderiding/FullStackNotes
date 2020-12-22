//
//  ViewController.swift
//  ChartsDemo
//
//  Created by coderiding on 2020/11/30.
//

import UIKit
import Charts
import TinyConstraints

class ViewController: UIViewController, ChartViewDelegate {
    
    lazy var chartView:BarChartView = {
        let chartView = BarChartView()
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        
        chartView.rightAxis.enabled = false
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true
        chartView.delegate = self
        chartView.maxVisibleCount = 60
        
        return chartView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(chartView)
        chartView.leftToSuperview(offset: 32)
        chartView.rightToSuperview(offset: -32)
        chartView.height(600)
        chartView.center(in: view)
        
        setData()
        setDataCount()
    }
    
    func setData() {
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        //xAxis.valueFormatter = DayAxisValueFormatter(chart: chartView)
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " $"
        leftAxisFormatter.positiveSuffix = " $"
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
//        chartView.legend = l

        /*
         let marker = XYMarkerView(color: UIColor(white: 180/250, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8),
                                   xAxisValueFormatter: chartView.xAxis.valueFormatter!)
         marker.chartView = chartView
         marker.minimumSize = CGSize(width: 80, height: 40)
         chartView.marker = marker
         */
        
    }
    
    func setDataCount() {
        let start = 1
        
        let yVals = (start..<start+3+1).map { (i) -> BarChartDataEntry in
            let mult = 3 + 1
            let val = Double(arc4random_uniform(UInt32(mult)))
            if arc4random_uniform(100) < 25 {
                return BarChartDataEntry(x: Double(i), y: val, icon: UIImage(named: "icon"))
            } else {
                return BarChartDataEntry(x: Double(i), y: val)
            }
        }
        
        var set1: BarChartDataSet! = nil
        set1 = BarChartDataSet(entries: yVals, label: "The year 2017")
        set1.colors = ChartColorTemplates.material()
        // 在柱状图上绘制数据
        set1.drawValuesEnabled = true
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data.barWidth = 0.9
        chartView.data = data
    }
}

