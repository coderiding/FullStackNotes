//
//  ViewController.swift
//  ChartsDemo
//
//  Created by coderiding on 2020/11/30.
//

import UIKit
import Charts
import TinyConstraints

class ViewController: UIViewController {
    
    lazy var pieChartView:PieChartView = {
        let pieChartV = PieChartView()
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "144000\n订单收入")
        
        centerText.addAttributes([.font : UIFont(name: "PingFangSC-Regular", size: 15)!,
                                  .foregroundColor : UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1)], range: NSRange(location: 0, length: centerText.length - 4))
        centerText.addAttributes([.font : UIFont(name: "PingFangSC-Regular", size: 12)!,
                                  .foregroundColor : UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)], range: NSRange(location: centerText.length - 4, length: 4))
        pieChartV.centerAttributedText = centerText;
        //指示是否启用旋转
        pieChartV.rotationEnabled = false
        //中心的图表孔旁边的透明圆的半径
        pieChartV.transparentCircleRadiusPercent = 0;
        
        return pieChartV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pieChartView)
        pieChartView.leftToSuperview(offset: 32)
        pieChartView.rightToSuperview(offset: -32)
        pieChartView.height(600)
        pieChartView.center(in: view)
        
        setData()
    }
    
    func setData() {
        let entry1 = PieChartDataEntry(value: 87.5,
                                       label: "")
        let entry2 = PieChartDataEntry(value: 12.5,
                                       label: "")
        
        let set = PieChartDataSet(entries: [entry1,entry2], label: "Election Results")
        set.sliceSpace = 2
        set.valueLinePart1OffsetPercentage = 0.8
        //当valuePosition为OutsideSlice时，表示行的前半部分的长度。
        set.valueLinePart1Length = 0.6
        //当valuePosition为OutsideSlice时，表示行的后半部分的长度。
        set.valueLinePart2Length = 0.8
        //名字显示在外面
        set.xValuePosition = .outsideSlice
        //百分比显示在外面
        set.yValuePosition = .outsideSlice
        //百分比不绘制
        set.drawValuesEnabled = false
        
        set.colors = [
            NSUIColor(red: 0.5, green: 0.84, blue: 1, alpha: 1.0),
            NSUIColor(red: 255/255.0, green: 213/255.0, blue: 76/255.0, alpha: 1.0)
        ]
        //当valuePosition为OutsideSlice并启用时，线条的颜色将与切片相同。
        set.useValueColorForLine = true
        set.valueLineWidth = 2
        set.entryLabelFont = UIFont(name: "PingFangSC-Regular", size: 14)
        set.entryLabelColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1)
        //表示饼片的选择距离,设置为0后，不会有前后选择的效果
        set.selectionShift = 0
        
        let data = PieChartData(dataSet: set)
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        pieChartView.data = data
        pieChartView.highlightValues(nil)
    }
}

