import UIKit

let path = UIBezierPath()

path.move(to: CGPoint(x: 100, y: 100))
path.addLine(to: CGPoint(x: 100, y:0))
path.move(to: CGPoint(x: 85, y: 20))
path.addLine(to: CGPoint(x: 100, y: 0))
path.move(to: CGPoint(x: 115, y: 20))
path.addLine(to: CGPoint(x: 100, y: 0))

path


