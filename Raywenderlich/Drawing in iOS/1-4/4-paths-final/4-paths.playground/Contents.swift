import UIKit
import PlaygroundSupport
let view = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
view.backgroundColor = .lightGray
PlaygroundPage.current.liveView = view


let shapeLayer = CAShapeLayer()
view.layer.addSublayer(shapeLayer)

let path = UIBezierPath()


path.move(to: CGPoint(x: 5, y: 5))
path.addLine(to: CGPoint(x: 5, y: 130))
path.addLine(to: CGPoint(x: 127, y: 130))

path.addLine(to: CGPoint(x: 127, y: 28))
path.addLine(to: CGPoint(x:86, y: 96))
path.addLine(to: CGPoint(x:68, y: 70))
path.addLine(to: CGPoint(x: 48, y: 96))
path.addLine(to: CGPoint(x: 32, y: 59))


path.addQuadCurve(to: CGPoint(x: 5, y: 5), controlPoint: CGPoint(x: 95, y: 5))

path.close()

shapeLayer.path = path.cgPath
shapeLayer.lineJoin = kCALineJoinRound
shapeLayer.fillColor = UIColor.yellow.cgColor
shapeLayer.strokeColor = UIColor.black.cgColor
shapeLayer.lineWidth = 6

shapeLayer.bounds = path.bounds

shapeLayer.position
shapeLayer.anchorPoint

shapeLayer.position.x = view.bounds.midX
shapeLayer.position.y = view.bounds.midY

let layer2 = CALayer()
layer2.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
view.layer.addSublayer(layer2)
layer2.backgroundColor = UIColor.blue.cgColor

layer2.position = shapeLayer.position

shapeLayer.zPosition = 10
layer2.zPosition = 5






















