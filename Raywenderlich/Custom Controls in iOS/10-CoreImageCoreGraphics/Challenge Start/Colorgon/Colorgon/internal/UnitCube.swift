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

enum UnitCube {
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

//MARK:-
private struct Face {
  let origin: float2
  let basisInverse: float2x2
}
