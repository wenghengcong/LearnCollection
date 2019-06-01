//
//  CAShapeLayerViewController.swift
//  LayerPlayer
//
//  Created by Scott Gardner on 11/17/14.
//  Copyright (c) 2014 Scott Gardner. All rights reserved.
//

import UIKit

class CAShapeLayerViewController: UIViewController {
  
  // FIXME: Unsatisfiable constraints in compact width, compact height (e.g., iPhone 5 in landscape)
  
  @IBOutlet weak var viewForShapeLayer: UIView!
  @IBOutlet weak var closePathSwitch: UISwitch!
  @IBOutlet weak var hueSlider: UISlider!
  @IBOutlet weak var fillSwitch: UISwitch!
  @IBOutlet weak var fillRuleSegmentedControl: UISegmentedControl!
  @IBOutlet weak var lineWidthSlider: UISlider!
  @IBOutlet weak var lineDashSwitch: UISwitch!
  @IBOutlet weak var lineCapSegmentedControl: UISegmentedControl!
  @IBOutlet weak var lineJoinSegmentedControl: UISegmentedControl!
  
  enum FillRule: Int {
    case nonZero, evenOdd
  }
  enum LineCap: Int {
    case butt, round, square, cap
  }
  enum LineJoin: Int {
    case miter, round, bevel
  }
  
  let shapeLayer = CAShapeLayer()
  var color = swiftOrangeColor
  let openPath = UIBezierPath()
  let closedPath = UIBezierPath()
  
  // MARK: - Quick reference
  
  func setUpOpenPath() {
    openPath.move(to: CGPoint(x: 30, y: 196))
    openPath.addCurve(to: CGPoint(x: 112.0, y: 12.5), controlPoint1: CGPoint(x: 110.56, y: 13.79), controlPoint2: CGPoint(x: 112.07, y: 13.01))
    openPath.addCurve(to: CGPoint(x: 194, y: 196), controlPoint1: CGPoint(x: 111.9, y: 11.81), controlPoint2: CGPoint(x: 194, y: 196))
    openPath.addLine(to: CGPoint(x: 30.0, y: 85.68))
    openPath.addLine(to: CGPoint(x: 194.0, y: 48.91))
    openPath.addLine(to: CGPoint(x: 30, y: 196))
  }
  
  func setUpClosedPath() {
    closedPath.cgPath = openPath.cgPath.mutableCopy()!
    closedPath.close()
  }
  
  func setUpShapeLayer() {
    shapeLayer.path = openPath.cgPath
    shapeLayer.fillColor = nil
    shapeLayer.fillRule = CAShapeLayerFillRule.nonZero
    shapeLayer.lineCap = CAShapeLayerLineCap.butt
    shapeLayer.lineDashPattern = nil
    shapeLayer.lineDashPhase = 0.0
    shapeLayer.lineJoin = CAShapeLayerLineJoin.miter
    shapeLayer.lineWidth = CGFloat(lineWidthSlider.value)
    shapeLayer.miterLimit = 4.0
    shapeLayer.strokeColor = color.cgColor
  }
  
  // MARK: - View life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpOpenPath()
    setUpClosedPath()
    setUpShapeLayer()
    viewForShapeLayer.layer.addSublayer(shapeLayer)
  }
  
  // MARK: - IBActions
  
  @IBAction func closePathSwitchChanged(_ sender: UISwitch) {
    var selectedSegmentIndex: Int!
    
    if sender.isOn {
        selectedSegmentIndex = UISegmentedControl.noSegment
      shapeLayer.path = closedPath.cgPath
    } else {
      switch shapeLayer.lineCap {
      case CAShapeLayerLineCap.butt:
        selectedSegmentIndex = LineCap.butt.rawValue
      case CAShapeLayerLineCap.round:
        selectedSegmentIndex = LineCap.round.rawValue
      default:
        selectedSegmentIndex = LineCap.square.rawValue
      }
      
      shapeLayer.path = openPath.cgPath
    }
    
    lineCapSegmentedControl.selectedSegmentIndex = selectedSegmentIndex
  }
  
  @IBAction func hueSliderChanged(_ sender: UISlider) {
    let hue = CGFloat(sender.value / 359.0)
    let color = UIColor(hue: hue, saturation: 0.81, brightness: 0.97, alpha: 1.0)
    shapeLayer.fillColor = fillSwitch.isOn ? color.cgColor : nil
    shapeLayer.strokeColor = color.cgColor
    self.color = color
  }
  
  @IBAction func fillSwitchChanged(_ sender: UISwitch) {
    var selectedSegmentIndex: Int
    
    if sender.isOn {
      shapeLayer.fillColor = color.cgColor
      
        if shapeLayer.fillRule == CAShapeLayerFillRule.nonZero {
        selectedSegmentIndex = FillRule.nonZero.rawValue
      } else {
        selectedSegmentIndex = FillRule.evenOdd.rawValue
      }
    } else {
        selectedSegmentIndex = UISegmentedControl.noSegment
      shapeLayer.fillColor = nil
    }
    
    fillRuleSegmentedControl.selectedSegmentIndex = selectedSegmentIndex
  }
  
  @IBAction func fillRuleSegmentedControlChanged(_ sender: UISegmentedControl) {
    fillSwitch.isOn = true
    shapeLayer.fillColor = color.cgColor
    var fillRule = CAShapeLayerFillRule.nonZero
    
    if sender.selectedSegmentIndex != FillRule.nonZero.rawValue {
        fillRule = CAShapeLayerFillRule.evenOdd
    }
    
    shapeLayer.fillRule = fillRule
  }
  
  @IBAction func lineWidthSliderChanged(_ sender: UISlider) {
    shapeLayer.lineWidth = CGFloat(sender.value)
  }
  
  @IBAction func lineDashSwitchChanged(_ sender: UISwitch) {
    if sender.isOn {
      shapeLayer.lineDashPattern = [50, 50]
      shapeLayer.lineDashPhase = 25.0
    } else {
      shapeLayer.lineDashPattern = nil
      shapeLayer.lineDashPhase = 0
    }
  }
  
  @IBAction func lineCapSegmentedControlChanged(_ sender: UISegmentedControl) {
    closePathSwitch.isOn = false
    shapeLayer.path = openPath.cgPath
    var lineCap = CAShapeLayerLineCap.butt
    
    switch sender.selectedSegmentIndex {
    case LineCap.round.rawValue:
        lineCap = CAShapeLayerLineCap.round
    case LineCap.square.rawValue:
        lineCap = CAShapeLayerLineCap.square
    default:
      break
    }
    
    shapeLayer.lineCap = lineCap
  }
  
  @IBAction func lineJoinSegmentedControlChanged(_ sender: UISegmentedControl) {
    var lineJoin = CAShapeLayerLineJoin.miter
    
    switch sender.selectedSegmentIndex {
    case LineJoin.round.rawValue:
        lineJoin = CAShapeLayerLineJoin.round
    case LineJoin.bevel.rawValue:
        lineJoin = CAShapeLayerLineJoin.bevel
    default:
      break
    }
    
    shapeLayer.lineJoin = lineJoin
  }
  
}
