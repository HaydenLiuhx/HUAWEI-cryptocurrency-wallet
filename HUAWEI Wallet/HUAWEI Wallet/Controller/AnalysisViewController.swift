//
//  AnalysisViewController.swift
//  HUAWEI Wallet
//
//  Created by Zhangwei Chen on 27/5/20.
//  Copyright © 2020 hayden. All rights reserved.
//

import UIKit
import Charts
import TinyConstraints

class AnalysisViewController: UIViewController, ChartViewDelegate {
    
    let pieChartView = PieChartView()
    let lineChartView = LineChartView()
    var screenWidth:UInt32 {
        return UInt32(UIScreen.main.bounds.width)
    }
    var screenHeight:UInt32 {
        return UInt32(UIScreen.main.bounds.height)
    }
    
    var yDataIncome = [Double]()//Data for Piechart
    var yDataExpend = [Double]()//Data for Piechart
    var titles = [String]()
    //Data for Linechart
    var yDataAIncome = [Double]()//bitcoin
    var yDataAExpend = [Double]()
    var yDataBIncome = [Double]()//ethereum
    var yDataBExpend = [Double]()
    var yDataCIncome = [Double]()//ripple
    var yDataCExpend = [Double]()
    
    
    @IBOutlet weak var switchControl: UISegmentedControl!
    
    
    
    @IBAction func switchAnalysis(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
//            view.backgroundColor = UIColor.blue
            switchControl.selectedSegmentTintColor = UIColor.init(displayP3Red: 0.4157, green: 0.498, blue: 0.5686, alpha: 1)
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//               switchControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
            switchControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
            incomeAnalysisPie()
            drawPieChartViewIncome()
            drawLineChartViewIncome()
            
            
        } else if sender.selectedSegmentIndex == 1 {
            switchControl.selectedSegmentTintColor = UIColor.init(displayP3Red: 0.1569, green: 0.4667, blue: 0.4588, alpha: 1)
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            switchControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
            expendAnalysisPie()
            drawPieChartViewExpend()
            drawLineChartViewExpend()
        }
        
    }
    
    
    func drawPieChartViewIncome() {
        let titles = ["Bitcoin","Ethereum","Ripple"]
        var yVals = [PieChartDataEntry]()
        for i in 0...titles.count - 1 {
            let entry = PieChartDataEntry.init(value: Double(yDataIncome[i]), label: titles[i])
            yVals.append(entry)
            }
        
        let dataSet = PieChartDataSet.init(entries: yVals, label:"")
        dataSet.colors = [UIColor.red,UIColor.yellow,UIColor.blue,UIColor.orange,UIColor.green] //设置名称和数据的位置 都在内就没有折线了
//        dataSet.colors = [UIColor(red: 0.7961, green: 0.898, blue: 0.3922, alpha: 1.0),UIColor(red: 0.949, green: 0.5686, blue: 0.4157, alpha: 1.0),UIColor(red: 0.4196, green: 0.7961, blue: 0.9569, alpha: 1.0) ]
        dataSet.colors = [UIColor(red: 0, green: 0.3922, blue: 0, alpha: 1),UIColor(red: 0.8039, green: 0, blue: 0, alpha: 1), UIColor(red: 1, green: 0.7255, blue: 0.0588, alpha: 1) ]
        dataSet.xValuePosition = .insideSlice
        dataSet.yValuePosition = .outsideSlice
        dataSet.sliceSpace = 1 //相邻块的距离
        dataSet.selectionShift = 6.66  //选中放大半径
            
        //指示折线样式
        dataSet.valueLinePart1OffsetPercentage = 0.8 //折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
        dataSet.valueLinePart1Length = 0.4 //折线中第一段长度占比
        dataSet.valueLinePart2Length = 0.4 //折线中第二段长度最大占比
        dataSet.valueLineWidth = 1 //折线的粗细
        dataSet.valueLineColor = UIColor.white //折线颜色
            
        let data = PieChartData.init(dataSets: [dataSet])
//       data.setValueFormatter(VDChartAxisValueFormatter.init(yVals)) //格式化值（添加个%）
//        data.setValueFormatter()
//        data.setValueFont(UIFont.systemFont(ofSize: 10.0))
        pieChartView.usePercentValuesEnabled = true
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(UIFont.boldSystemFont(ofSize: 20.0))
        data.setValueTextColor(UIColor.white)
        pieChartView.data = data
            }
    
    func incomeAnalysisPie() {
        
        pieChartView.frame = CGRect(x: Int(screenWidth/2)-200, y: 100, width: 400, height: 350)
        self.view.addSubview(pieChartView)
        pieChartView.backgroundColor =  UIColor.init(displayP3Red: 0.4157, green: 0.498, blue: 0.5686, alpha: 1)
        pieChartView.setExtraOffsets(left: 30, top: -20, right: 30, bottom: 30)  //设置这块饼的位置
        pieChartView.chartDescription?.text = "Proportion of income summary" //描述文字
        pieChartView.chartDescription?.font = UIFont.boldSystemFont(ofSize: 10)
        pieChartView.chartDescription?.textColor = UIColor.white
        pieChartView.chartDescription?.position = CGPoint(x: Int(screenWidth/2)+100, y: 320)
               
        //    pieChartView.usePercentValuesEnabled = true  //转化为百分比
        pieChartView.dragDecelerationEnabled = true //把拖拽效果关了
        pieChartView.drawEntryLabelsEnabled = true //显示区块文本
        pieChartView.entryLabelFont = UIFont.systemFont(ofSize: 15) //区块文本的字体
        pieChartView.entryLabelColor = UIColor.white
        pieChartView.drawSlicesUnderHoleEnabled = true
        pieChartView.drawHoleEnabled = true  //这个饼是空心的
        pieChartView.holeRadiusPercent = 0.382  //空心半径黄金比例
        pieChartView.holeColor = UIColor.white //空心颜色设置为白色
        pieChartView.transparentCircleRadiusPercent = 0.5  //半透明空心半径
        pieChartView.drawCenterTextEnabled = true //显示中心文本
        pieChartView.centerText = "Income"  //设置中心文本,你也可以设置富文本`centerAttributedText`
        //图例样式设置
        pieChartView.legend.maxSizePercent = 1  //图例的占比
        pieChartView.legend.form = .circle //图示：原、方、线
        pieChartView.legend.formSize = 8 //图示大小
        pieChartView.legend.formToTextSpace = 4 //文本间隔
        pieChartView.legend.font = UIFont.systemFont(ofSize: 10)
    
        pieChartView.legend.textColor = UIColor.white
//        pieChartView.legend.horizontalAlignment = .left
        pieChartView.legend.horizontalAlignment = .center
        pieChartView.legend.verticalAlignment = .top
        self.pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBack)
        self.drawPieChartViewIncome()
    }
    
    
     func drawPieChartViewExpend() {
        
        let titles = ["Bitcoin","Ethereum","Ripple"]
        var yVals = [PieChartDataEntry]()
        for i in 0...titles.count - 1 {
            let entry = PieChartDataEntry.init(value: Double(yDataExpend[i]), label: titles[i])
            yVals.append(entry)
            }
            
        let dataSet = PieChartDataSet.init(entries: yVals, label:"")
        dataSet.colors = [UIColor.red,UIColor.yellow,UIColor.blue,UIColor.orange,UIColor.green] //设置名称和数据的位置 都在内就没有折线了
//        dataSet.colors = [UIColor(red: 0.7961, green: 0.898, blue: 0.3922, alpha: 1.0),UIColor(red: 0.949, green: 0.5686, blue: 0.4157, alpha: 1.0),UIColor(red: 0.4196, green: 0.7961, blue: 0.9569, alpha: 1.0) ]
        dataSet.colors = [UIColor(red: 0, green: 0.3922, blue: 0, alpha: 1),UIColor(red: 0.8039, green: 0, blue: 0, alpha: 1), UIColor(red: 1, green: 0.7255, blue: 0.0588, alpha: 1) ]
        
        dataSet.xValuePosition = .insideSlice
        dataSet.yValuePosition = .outsideSlice
        dataSet.sliceSpace = 1 //相邻块的距离
        dataSet.selectionShift = 6.66  //选中放大半径
                
            //指示折线样式
        dataSet.valueLinePart1OffsetPercentage = 0.8 //折线中第一段起始位置相对于区块的偏移量, 数值越大, 折线距离区块越远
        dataSet.valueLinePart1Length = 0.4 //折线中第一段长度占比
        dataSet.valueLinePart2Length = 0.4 //折线中第二段长度最大占比
        dataSet.valueLineWidth = 1 //折线的粗细
        dataSet.valueLineColor = UIColor.white //折线颜色
                
        let data = PieChartData.init(dataSets: [dataSet])
    //       data.setValueFormatter(VDChartAxisValueFormatter.init(yVals)) //格式化值（添加个%）
    //        data.setValueFormatter()
    //        data.setValueFont(UIFont.systemFont(ofSize: 10.0))
        pieChartView.usePercentValuesEnabled = true
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(UIFont.boldSystemFont(ofSize: 20.0))
        data.setValueTextColor(UIColor.white)
        pieChartView.data = data
            }
        
    func expendAnalysisPie() {
        pieChartView.frame = CGRect(x: Int(screenWidth/2)-200, y: 100, width: 400, height: 350)
        self.view.addSubview(pieChartView)
        pieChartView.backgroundColor =  UIColor.init(displayP3Red: 0.1569, green: 0.4667, blue: 0.4588, alpha: 1)
        pieChartView.setExtraOffsets(left: 30, top: -20, right: 30, bottom: 30)  //设置这块饼的位置
        pieChartView.chartDescription?.text = "Proportion of expenditure summary" //描述文字
        pieChartView.chartDescription?.font = UIFont.systemFont(ofSize: 10)
        pieChartView.chartDescription?.textColor = UIColor.white
        pieChartView.chartDescription?.position = CGPoint(x: Int(screenWidth/2)+100, y: 320)
                   
            //    pieChartView.usePercentValuesEnabled = true  //转化为百分比
        pieChartView.dragDecelerationEnabled = true //把拖拽效果关了
        pieChartView.drawEntryLabelsEnabled = true //显示区块文本
        pieChartView.entryLabelFont = UIFont.boldSystemFont(ofSize: 15) //区块文本的字体
        pieChartView.entryLabelColor = UIColor.white
        pieChartView.drawSlicesUnderHoleEnabled = true
        pieChartView.drawHoleEnabled = true  //这个饼是空心的
        pieChartView.holeRadiusPercent = 0.382  //空心半径黄金比例
        pieChartView.holeColor = UIColor.white //空心颜色设置为白色
        pieChartView.transparentCircleRadiusPercent = 0.5  //半透明空心半径
        pieChartView.drawCenterTextEnabled = true //显示中心文本
        pieChartView.centerText = "Expenditure"  //设置中心文本,你也可以设置富文本`centerAttributedText`
            //图例样式设置
        pieChartView.legend.maxSizePercent = 1  //图例的占比
        pieChartView.legend.form = .circle //图示：原、方、线
        pieChartView.legend.formSize = 8 //图示大小
        pieChartView.legend.formToTextSpace = 4 //文本间隔
        pieChartView.legend.font = UIFont.systemFont(ofSize: 10)
        
        pieChartView.legend.textColor = UIColor.white
    //        pieChartView.legend.horizontalAlignment = .left
        pieChartView.legend.horizontalAlignment = .center
        pieChartView.legend.verticalAlignment = .top
        self.pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBack)
        self.drawPieChartViewExpend()
    }
        
    
    func drawLineChartViewIncome() {
        
        
//        lineChartView.frame = CGRect(x: Int(screenWidth/2)-Int((self.view.bounds.width - 40)/2), y: 450, width: Int(self.view.bounds.width - 40), height: Int(screenHeight-600))
        lineChartView.frame = CGRect(x: Int(screenWidth/2)-200, y: 450, width: 400, height: 350)
        
        self.view.addSubview(lineChartView)
        lineChartView.delegate = self
            
        lineChartView.backgroundColor = UIColor.init(displayP3Red: 0.4157, green: 0.498, blue: 0.5686, alpha: 1)
        lineChartView.noDataText = "No Data"
            
        //设置交互样式
        lineChartView.scaleYEnabled = false //取消Y轴缩放
        lineChartView.doubleTapToZoomEnabled = true //双击缩放
        lineChartView.dragEnabled = true //启用拖动手势
        lineChartView.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        lineChartView.dragDecelerationFrictionCoef = 0.9  //拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        
        //设置X轴样式
        let xAxis = lineChartView.xAxis
//        xAxis.axisLineWidth = 1.0/UIScreen.main.scale //设置X轴线宽
        xAxis.axisLineWidth = 1.0
        xAxis.axisLineColor = UIColor.white
        xAxis.forceLabelsEnabled = true
        
        xAxis.labelPosition = .bottom //X轴的显示位置，默认是显示在上面的
        xAxis.drawGridLinesEnabled = true//不绘制网格线
//        xAxis.spaceMin = 4;//设置label间隔
//        xAxis.axisMinimum = 0
//        xAxis.labelTextColor = UIColor.white//label文字颜色
        xAxis.drawLabelsEnabled = false//不绘制x轴
            
        //设置Y轴样式
        lineChartView.rightAxis.enabled = false  //不绘制右边轴
        let leftAxis = lineChartView.leftAxis
        leftAxis.labelCount = 16 //Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        leftAxis.forceLabelsEnabled = false //不强制绘制指定数量的label
        leftAxis.axisMinimum = 0 //设置Y轴的最小值
        leftAxis.drawZeroLineEnabled = true //从0开始绘制
        //leftAxis.axisMaximum = 1000 //设置Y轴的最大值
        leftAxis.inverted = false //是否将Y轴进行上下翻转
        leftAxis.axisLineWidth = 1.0/UIScreen.main.scale //设置Y轴线宽
        leftAxis.axisLineColor = UIColor.white//Y轴颜色
        //leftAxis.valueFormatter = NumberFormatter()//自定义格式
        //leftAxis.s  //数字后缀单位
        leftAxis.labelPosition = .outsideChart//label位置
        leftAxis.labelTextColor = UIColor.white//文字颜色
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10)//文字字体
            
            
        //设置网格样式
        leftAxis.gridLineDashLengths = [3.0,3.0]  //设置虚线样式的网格线
        leftAxis.gridColor = UIColor.init(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        //网格线颜色
        leftAxis.gridAntialiasEnabled = true //开启抗锯齿
            
            
//        //添加限制线
//        let litmitLine = ChartLimitLine(limit: 260, label: "限制线")
//        litmitLine.lineWidth = 2
//        litmitLine.lineColor = UIColor.green
//        litmitLine.lineDashLengths = [5.0,5.0] //虚线样式
//        litmitLine.labelPosition = .topRight // 限制线位置
//        litmitLine.valueTextColor = UIColor.brown
//        litmitLine.valueFont = UIFont.systemFont(ofSize: 12)
//        leftAxis.addLimitLine(litmitLine)
//        leftAxis.drawLimitLinesBehindDataEnabled = true  //设置限制线绘制在折线图的后面
            
        //设置折线图描述及图例样式
        lineChartView.chartDescription?.text = "Last five income record" //折线图描述
        lineChartView.chartDescription?.textColor = UIColor.white  //描述字体颜色
//        lineChartView.chartDescription?.position = CGPoint(x: Int(screenWidth/2)+100, y: 400)
//        lineChartView.chartDescription?.textAlign = .left
        lineChartView.chartDescription?.font = UIFont.boldSystemFont(ofSize: 10)
        lineChartView.legend.form = .line  // 图例的样式
        lineChartView.legend.formSize = 20  //图例中线条的长度
        lineChartView.legend.textColor = UIColor.white
        lineChartView.legend.font = UIFont.systemFont(ofSize: 10)
        lineChartView.legend.verticalAlignment = .top
        lineChartView.legend.horizontalAlignment = .center
        //设置折线图的数据
        let xValues = ["1","2","3","4","5"]
//        lineChartView.xAxis.valueFormatter = KMChartAxisValueFormatter.init(xValues as NSArray)
        lineChartView.xAxis.labelCount = 5
        //lineChartView.leftAxis.valueFormatter = KMChartAxisValueFormatter.init()
        //在这里如果不需要自定义x轴的数据格式，可以使用原生的格式如下：
//        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter.init(values: xValues)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        let leftValueFormatter = NumberFormatter()  //自定义格式
//        leftValueFormatter.positiveSuffix = ""  //数字后缀单位
            
        lineChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: leftValueFormatter)
            
        var yDataArray1 = [ChartDataEntry]()
        for i in 0...(yDataAIncome.count-1) {
            let y = yDataAIncome[i]
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            
            yDataArray1.append(entry)
        }
            
            
        let set1 = LineChartDataSet.init(entries: yDataArray1, label: "Bitcoin")
//        set1.colors = [UIColor(red: 0.7961, green: 0.898, blue: 0.3922, alpha: 1.0)]
        set1.colors = [UIColor(red: 0, green: 0.3922, blue: 0, alpha: 1)]
        set1.drawCirclesEnabled = false //是否绘制转折点
        set1.lineWidth = 1.0
//        set1.mode = .horizontalBezier  //设置曲线是否平滑
        set1.circleColors = [UIColor.white]
        set1.circleRadius = 1.0
        set1.drawCirclesEnabled = true
        set1.valueColors = [UIColor.white]
        set1.valueFont = UIFont.systemFont(ofSize:10)
            
        var yDataArray2 = [ChartDataEntry]()
        for i in 0...(yDataBIncome.count-1) {
            let y = yDataBIncome[i]
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            yDataArray2.append(entry)
        }
        let set2 = LineChartDataSet.init(entries: yDataArray2, label: "Ethereum")
//        set2.colors = [UIColor(red: 0.949, green: 0.5686, blue: 0.4157, alpha: 1.0)]
        set2.colors = [UIColor(red: 0.8039, green: 0, blue: 0, alpha: 1)]
        set2.drawCirclesEnabled = false
        set2.lineWidth = 1.0
        set2.circleColors = [UIColor.white]
        set2.circleRadius = 1.0
        set2.drawCirclesEnabled = true
        set2.valueColors = [UIColor.white]
        set2.valueFont = UIFont.systemFont(ofSize:10)
        

        
        
        var yDataArray3 = [ChartDataEntry]()
        for i in 0...(yDataCIncome.count-1) {
            let y = yDataCIncome[i]
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            yDataArray3.append(entry);
        }
        
        
        let set3 = LineChartDataSet.init(entries: yDataArray3, label: "Ripple")
//        set3.colors = [UIColor(red: 0.4196, green: 0.7961, blue: 0.9569, alpha: 1.0)]
        set3.colors = [UIColor(red: 1, green: 0.7255, blue: 0.0588, alpha: 1)]
        set3.drawCirclesEnabled = false //是否绘制转折点
        set3.lineWidth = 1.0
        set3.circleColors = [UIColor.white]
        set3.circleRadius = 1.0
        set3.drawCirclesEnabled = true
        set3.valueColors = [UIColor.white]
        set3.valueFont = UIFont.systemFont(ofSize:10)

        
//       set3.mode = .horizontalBezier  //设置曲线是否平滑
        
            
        
        
        
        let data = LineChartData.init(dataSets: [set1,set2,set3])
        lineChartView.data = data
            //lineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBack)
            lineChartView.animate(xAxisDuration: 1)  //设置动画时间
            
        }


        func showMarkerView(value:String)
        {
            let marker = MarkerView.init(frame: CGRect(x: 20, y: 20, width: 60, height: 20))
            marker.chartView = self.lineChartView
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
            label.text = value
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 12)
            label.backgroundColor = UIColor.gray
            label.textAlignment = .center
            marker.addSubview(label)
            self.lineChartView.marker = marker
        }

        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight)
        {
            self.showMarkerView(value: "\(entry.y)")
        }
       
            
       func drawLineChartViewExpend() {
        
        lineChartView.frame = CGRect(x: Int(screenWidth/2)-200, y: 450, width: 400, height: 350)
              
        self.view.addSubview(lineChartView)
        lineChartView.delegate = self
            
        lineChartView.backgroundColor = UIColor.init(displayP3Red: 0.1569, green: 0.4667, blue: 0.4588, alpha: 1)
        lineChartView.noDataText = "No Data"
                  
              //设置交互样式
        lineChartView.scaleYEnabled = false //取消Y轴缩放
        lineChartView.doubleTapToZoomEnabled = true //双击缩放
        lineChartView.dragEnabled = true //启用拖动手势
        lineChartView.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        lineChartView.dragDecelerationFrictionCoef = 0.9  //拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
              
              //设置X轴样式
        let xAxis = lineChartView.xAxis
    
        xAxis.axisLineWidth = 1.0
        xAxis.axisLineColor = UIColor.white
        xAxis.forceLabelsEnabled = true
              
        xAxis.labelPosition = .bottom //X轴的显示位置，默认是显示在上面的
        xAxis.drawGridLinesEnabled = true//不绘制网格线
    
        xAxis.drawLabelsEnabled = false//不绘制x轴
                  
              //设置Y轴样式
        lineChartView.rightAxis.enabled = false  //不绘制右边轴
        let leftAxis = lineChartView.leftAxis
        leftAxis.labelCount = 16 //Y轴label数量，数值不一定，如果forceLabelsEnabled等于YES, 则强制绘制制定数量的label, 但是可能不平均
        leftAxis.forceLabelsEnabled = false //不强制绘制指定数量的label
        leftAxis.axisMinimum = 0 //设置Y轴的最小值
        leftAxis.drawZeroLineEnabled = true //从0开始绘制
            
        leftAxis.inverted = false //是否将Y轴进行上下翻转
        leftAxis.axisLineWidth = 1.0/UIScreen.main.scale //设置Y轴线宽
        leftAxis.axisLineColor = UIColor.white//Y轴颜色
            
        leftAxis.labelPosition = .outsideChart//label位置
        leftAxis.labelTextColor = UIColor.white//文字颜色
        leftAxis.labelFont = UIFont.systemFont(ofSize: 10)//文字字体
                  
                  
              //设置网格样式
        leftAxis.gridLineDashLengths = [3.0,3.0]  //设置虚线样式的网格线
        leftAxis.gridColor = UIColor.init(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
              //网格线颜色
        leftAxis.gridAntialiasEnabled = true //开启抗锯齿
                  
                  
     
        lineChartView.chartDescription?.text = "Last five expenditure record" //折线图描述
        lineChartView.chartDescription?.textColor = UIColor.white  //描述字体颜色
        lineChartView.chartDescription?.font = UIFont.boldSystemFont(ofSize: 10)
        lineChartView.legend.form = .line  // 图例的样式
        lineChartView.legend.formSize = 20  //图例中线条的长度
        lineChartView.legend.textColor = UIColor.white
        lineChartView.legend.font = UIFont.systemFont(ofSize: 10)
        lineChartView.legend.verticalAlignment = .top
        lineChartView.legend.horizontalAlignment = .center
              //设置折线图的数据
        let xValues = ["1","2","3","4","5"]
    
        lineChartView.xAxis.labelCount = 5
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        let leftValueFormatter = NumberFormatter()  //自定义格式

                  
        lineChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter.init(formatter: leftValueFormatter)
                  
        var yDataArray1 = [ChartDataEntry]()
        for i in 0...(yDataAExpend.count-1) {
            let y = yDataAExpend[i]
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
                  
            yDataArray1.append(entry)
        }
                  
                  
        let set1 = LineChartDataSet.init(entries: yDataArray1, label: "Bitcoin")
//        set1.colors = [UIColor(red: 0.7961, green: 0.898, blue: 0.3922, alpha: 1.0)]
        set1.colors = [UIColor(red: 0, green: 0.3922, blue: 0, alpha: 1)]
        set1.drawCirclesEnabled = false //是否绘制转折点
        set1.lineWidth = 1.0
        set1.circleColors = [UIColor.white]
        set1.circleRadius = 1.0
        set1.drawCirclesEnabled = true
        set1.valueColors = [UIColor.white]
        set1.valueFont = UIFont.systemFont(ofSize:10)
                  
        var yDataArray2 = [ChartDataEntry]()
        for i in 0...(yDataBExpend.count-1) {
            let y = yDataBExpend[i]
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            yDataArray2.append(entry)
        }
        let set2 = LineChartDataSet.init(entries: yDataArray2, label: "Ethereum")
//        set2.colors = [UIColor(red: 0.949, green: 0.5686, blue: 0.4157, alpha: 1.0)]
        set2.colors = [UIColor(red: 0.8039, green: 0, blue: 0, alpha: 1)]
        set2.drawCirclesEnabled = false
        set2.lineWidth = 1.0
        set2.circleColors = [UIColor.white]
        set2.circleRadius = 1.0
        set2.drawCirclesEnabled = true
        set2.valueColors = [UIColor.white]
        set2.valueFont = UIFont.systemFont(ofSize:10)
              

        var yDataArray3 = [ChartDataEntry]()
        for i in 0...(yDataCExpend.count-1) {
            let y = yDataCExpend[i]
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            yDataArray3.append(entry);
        }
              
              
        let set3 = LineChartDataSet.init(entries: yDataArray3, label: "Ripple")
//        set3.colors = [UIColor(red: 0.4196, green: 0.7961, blue: 0.9569, alpha: 1.0)]
        set3.colors = [UIColor(red: 1, green: 0.7255, blue: 0.0588, alpha: 1)]
        set3.drawCirclesEnabled = false //是否绘制转折点
        set3.lineWidth = 1.0
        set3.circleColors = [UIColor.white]
        set3.circleRadius = 1.0
        set3.drawCirclesEnabled = true
        set3.valueColors = [UIColor.white]
        set3.valueFont = UIFont.systemFont(ofSize:10)

              
        let data = LineChartData.init(dataSets: [set1,set2,set3])
        lineChartView.data = data
        
        lineChartView.animate(xAxisDuration: 1)  //设置动画时间
                  
              }

       
    
    
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        incomeAnalysisPie()
        drawPieChartViewIncome()
        drawLineChartViewIncome()
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        switchControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        switchControl.selectedSegmentTintColor = UIColor.init(displayP3Red: 0.4157, green: 0.498, blue: 0.5686, alpha: 1)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
