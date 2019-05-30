//import DeluxeButton
//import Colorgon
//import PlaygroundSupport
//import Scribble
//import UIKit
//
//// Fill Button
//let fillButton = DeluxeButton(
//  frame: CGRect(
//    x: 265,
//    y: 80,
//    width: 125,
//    height: 125
//  )
//)
//fillButton.image = #imageLiteral(resourceName: "PaintBucketIcon.png")
//fillButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//fillButton.unpressedBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//fillButton.pressedBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//fillButton.borderWidth = 5
//fillButton.imagePadding = 5
//fillButton.text = "Fill"
//fillButton.fontSize = 26
//
//let colorgonView = Colorgon.View(
//  frame: CGRect(
//    x: 5,
//    y: 5,
//    width: 250,
//    height: 250
//  )
//)
//
//// Canvas
//let canvas = CanvasView(
//  frame: CGRect(
//    x: 0,
//    y: 300,
//    width: 400,
//    height: 250
//  )
//)
//canvas.canvasColor = #colorLiteral(red: 1, green: 0.9907965064, blue: 0.894860208, alpha: 1)
//
//final class ActionHolder {
//  @objc func handleFillButtonTapped() {
//    canvas.canvasColor = fillButton.unpressedBackgroundColor
//  }
//}
//let actionHolder = ActionHolder()
//
//
//let sketchPadView = UIView(
//  frame: CGRect(
//    x: 0,
//    y: 0,
//    width: 400,
//    height: 500
//  )
//)
//sketchPadView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//
//sketchPadView.addSubview(fillButton)
//sketchPadView.addSubview(canvas)
//sketchPadView.addSubview(colorgonView)
//
//fillButton.addTarget(
//  actionHolder,
//  action: #selector(actionHolder.handleFillButtonTapped),
//  for: .touchUpInside
//)
//
//PlaygroundPage.current.liveView = sketchPadView
