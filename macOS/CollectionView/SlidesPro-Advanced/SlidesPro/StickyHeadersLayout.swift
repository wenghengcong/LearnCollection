/*
 * StickyHeadersLayout.swift
 * SlidesPro
 *
 * Created by Gabriel Miro on 30/3/16.
 * Copyright (c) 2016 Razeware LLC
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

import Cocoa

class StickyHeadersLayout: NSCollectionViewFlowLayout {

  override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
    
    // 1
    var layoutAttributes = super.layoutAttributesForElements(in: rect)
    
    // 2
    let sectionsToMoveHeaders = NSMutableIndexSet()
    for attributes in layoutAttributes {
      if attributes.representedElementCategory == .item {
        sectionsToMoveHeaders.add(attributes.indexPath!.section)
      }
    }
    
    // 3
    for attributes in layoutAttributes {
      if let elementKind = attributes.representedElementKind, elementKind == NSCollectionView.elementKindSectionHeader {
        sectionsToMoveHeaders.remove(attributes.indexPath!.section)
      }
    }
    
    // 4
    sectionsToMoveHeaders.enumerate { (index, stop) -> Void in
      let indexPath = NSIndexPath(forItem: 0, inSection: index)
      let attributes = self.layoutAttributesForSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, at: indexPath as IndexPath)
      if attributes != nil {
        layoutAttributes.append(attributes!)
      }
    }
    
    for attributes in layoutAttributes {
      // 5
      if let elementKind = attributes.representedElementKind, elementKind == NSCollectionView.elementKindSectionHeader{
        let section = attributes.indexPath!.section
        let attributesForFirstItemInSection = layoutAttributesForItem(at: NSIndexPath(forItem: 0, inSection: section) as IndexPath)
        let attributesForLastItemInSection = layoutAttributesForItem(at: NSIndexPath(forItem: collectionView!.numberOfItems(inSection: section) - 1, inSection: section) as IndexPath)
        var frame = attributes.frame
        
        // 6
        let offset = collectionView!.enclosingScrollView?.documentVisibleRect.origin.y
        
        // 7
        let minY = (attributesForFirstItemInSection!.frame).minY - frame.height
        
        // 8
        let maxY = (attributesForLastItemInSection!.frame).maxY - frame.height
        
        // 9
        let y = min(max(offset!, minY), maxY)
        
        // 10
        frame.origin.y = y
        attributes.frame = frame
        
        // 11
        attributes.zIndex = 99
      }
    }
    
    // 12
    return layoutAttributes
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
}
