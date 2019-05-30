import PlaygroundSupport
import ThreeRingControl
import UIKit

let threeRingView = ThreeRingView(
  frame: CGRect(
    x: 0,
    y: 0,
    width: 300,
    height: 300
  )
)

threeRingView.innerRingValue = 2
threeRingView.middleRingValue = 2
threeRingView.outerRingValue = 2

threeRingView.animationDuration = 2

threeRingView.ringWidth = 30
threeRingView.ringPadding = 5

threeRingView.ringBackgroundColor = #colorLiteral(red: 0.2176739573, green: 0.2006060183, blue: 0.2606677413, alpha: 1)

threeRingView.innerRingColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
threeRingView.middleRingColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
threeRingView.outerRingColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)


let newValues: [CGFloat] = [
  0.55,
  1.2,
  0.8
]

for (ring, value) in zip(rings, newValues) {
  threeRingView.animate(
    ring: ring,
    value: value
  )
}

PlaygroundPage.current.liveView = threeRingView
