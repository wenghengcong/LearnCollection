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
      
          // 1 The super method returns an array of attributes for the visible elements.
          var layoutAttributes = super.layoutAttributesForElements(in: rect)
        
          // 2 The NSMutableIndexSet first aggregates all the sections that have at least one visible item.
          let sectionsToMoveHeaders = NSMutableIndexSet()
          for attributes in layoutAttributes {
              if attributes.representedElementCategory == .item {
                  sectionsToMoveHeaders.add(attributes.indexPath!.section)
              }
          }
        
          // 3 Remove all sections from the set where the header is already in layoutAttributes, leaving only the sections with “Missing Headers” in the set.
          for attributes in layoutAttributes {
              if let elementKind = attributes.representedElementKind, elementKind == NSCollectionView.elementKindSectionHeader {
                  sectionsToMoveHeaders.remove(attributes.indexPath!.section)
              }
          }
        
          // 4 Request the attributes for the missing headers and add them to layoutAttributes.
          sectionsToMoveHeaders.enumerate { (index, stop) -> Void in
              let indexPath = NSIndexPath(forItem: 0, inSection: index)
              let attributes = self.layoutAttributesForSupplementaryView(ofKind: NSCollectionView.elementKindSectionHeader, at: indexPath as IndexPath)
              if attributes != nil {
                  layoutAttributes.append(attributes!)
              }
          }
        
          for attributes in layoutAttributes {
            // 5 Iterate over layoutAttributes and process only the headers.
            if let elementKind = attributes.representedElementKind, elementKind == NSCollectionView.elementKindSectionHeader{
              let section = attributes.indexPath!.section
              let attributesForFirstItemInSection = layoutAttributesForItem(at: NSIndexPath(forItem: 0, inSection: section) as IndexPath)
              let attributesForLastItemInSection = layoutAttributesForItem(at: NSIndexPath(forItem: collectionView!.numberOfItems(inSection: section) - 1, inSection: section) as IndexPath)
              var frame = attributes.frame
              
              // 6 Set the coordinate for the top of the visible area, aka scroll offset.
              let offset = collectionView!.enclosingScrollView?.documentVisibleRect.origin.y
              
              // 7 Make it so the header never goes further up than one-header-height above the upper bounds of the first item in the section.
              let minY = (attributesForFirstItemInSection!.frame).minY - frame.height
              
              // 8 Make it so the header never goes further down than one-header-height above the lower bounds of the last item in the section.
              let maxY = (attributesForLastItemInSection!.frame).maxY - frame.height
              
              /* 9
               Let's break this into 2 statements:
                  1)maybeY = max(offset!, minY): When the top of the section is above the visible area this pins (or pushes down) the header to the top of the visible area.
                  2)y = min(maybeY, maxY): When the space between the bottom of the section to the top of the visible area is less than header height, it shows only the part of the header's bottom that fits this space.
               */
              let y = min(max(offset!, minY), maxY)
              
              // 10 Update the vertical position of the header.
              frame.origin.y = y
              attributes.frame = frame
              
              // 11 Make the items "go" under the header.
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
