/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import simd
import QuartzCore

enum UnitCube {
    static let whiteColor = float3(repeating: 1)
  
  static func getColor(
    positionInView: CGPoint,
    viewSize: CGSize
  ) -> float3 {
    let
      yFlippedPositionInView = float2(
        Float(positionInView.x),
        Float(viewSize.height - positionInView.y)
      ),
      normalizedPositionInView =
        yFlippedPositionInView
          / float2( Float(viewSize.width), Float(viewSize.height) ),
    position = 2 * normalizedPositionInView - float2(repeating: 1)
    
    
    if let redFacePosition = faces.red[position] {
      return [1, redFacePosition.y, redFacePosition.x]
    }
    else if let greenFacePosition = faces.green[position] {
      return [greenFacePosition.x, 1, greenFacePosition.y]
    }
    else if let blueFacePosition = faces.blue[position] {
      return [blueFacePosition.x, blueFacePosition.y, 1]
    }
    else {
      // If something unexpected goes wrong…
      return UnitCube.whiteColor
    }
  }
  
//MARK: private
  private static let faces: (
    red: Face,
    green: Face,
    blue: Face
  ) = {
    let
      edgeRadians: Float = .pi / 6,
      cyanVertexPosition: float2 = [cos(edgeRadians), sin(edgeRadians)],
      rightVertexXInverse = 1 / cyanVertexPosition.x
    
    return (
      red: Face(
        origin: -cyanVertexPosition,
        basisInverse: float2x2([
          [rightVertexXInverse, cyanVertexPosition.y * rightVertexXInverse],
          [0, 1]
        ])
      ),
      green: Face(
        origin: [0, 1],
        basisInverse: {
          let xContribution = rightVertexXInverse * cyanVertexPosition.y
          return float2x2([
            [-xContribution, xContribution],
            [-1, -1]
          ])
        }()
      ),
      blue: Face(
        origin: [cyanVertexPosition.x, -cyanVertexPosition.y],
        basisInverse: float2x2([
          [-rightVertexXInverse, cyanVertexPosition.y * -rightVertexXInverse],
          [0, 1]
        ])
      )
    )
  }()
}

//MARK:
private struct Face {
  let origin: float2
  let basisInverse: float2x2
}

extension Face {
  subscript(position: float2) -> float2? {
    let position = basisInverse * (position - origin)
    
    guard max(position.x, position.y) <= 1
    else {return nil}
    
    return position
  }
}
