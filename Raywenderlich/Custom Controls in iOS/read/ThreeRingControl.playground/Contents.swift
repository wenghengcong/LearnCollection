import PlaygroundSupport
import UIKit


let ringLayer = RingLayer()
ringLayer.ringBackgroundColor = UIColor.white.cgColor
ringLayer.value = 0.7
ringLayer.ringWidth = 100
ringLayer.ringColor = UIColor.orange.cgColor

PlaygroundPage.set(layers: ringLayer)

let filterNames = CIFilter.filterNames(inCategory: kCICategoryBuiltIn) as [String]
