/*
* Copyright (c) 2015 Razeware LLC
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

import UIKit

struct Book {
  
  let title: String
  let cover: UIImage
  let authors: String
  let description: String
  let chaptersRead: Int
  let chaptersTotal: Int
  
  static let all: [Book] = [
    
    Book(title: "WatchOS 2 by Tutorials", cover: UIImage(named: "w2t")!, authors: "By Ryan Nystrom, Scott Atkinson, Soheil Azarpour, Matthew Morey, Ben Morrow, Audrey Tam, and Jack Wu", description: "Making Apple Watch Apps with watchOS 2 and Swift 2!", chaptersRead: 5, chaptersTotal: 27),
    Book(title: "iOS Animations by Tutorials", cover: UIImage(named: "iat")!, authors: "By Marin Todorov", description: "Learn how to make delightful iOS animations in Swift – from beginning to advanced!", chaptersRead: 15, chaptersTotal: 27),
    Book(title: "iOS 9 by Tutorials", cover: UIImage(named: "i9t")!, authors: "By Jawwad Ahmad, Soheil Azarpour, Caroline Begbie, Evan Dekhayser, Aaron Douglas, James Frost, Vincent Ngo, Pietro Rea, Derek Selander and Chris Wagner", description: "Learn about the new APIs in iOS 9 such as App Search, UIStackView and App Thinning!", chaptersRead: 13, chaptersTotal: 15),
    Book(title: "Core Data by Tutorials", cover: UIImage(named: "cdt")!, authors: "By Aaron Douglas, Saul Mora, Matthew Morey, and Pietro Rea", description: "Take control of your data in iOS apps using Core Data, Apple’s powerful object graph and persistence framework.", chaptersRead: 1, chaptersTotal: 10),
    Book(title: "2D iOS & tvOS Games by Tutorials", cover: UIImage(named: "igt")!, authors: "By Mike Berg, Michael Briscoe, Ali Hafizji, Neil North, Toby Stephens, Rod Strougo, Marin Todorov, and Ray Wenderlich", description: "Learn how to make iOS & tvOS games using Swift 2, Sprite Kit and GameplayKit.", chaptersRead: 20, chaptersTotal: 28),
    Book(title: "iOS Apprentice", cover: UIImage(named: "ia")!, authors: "By Matthijs Hollemans", description: "Learn how to make apps with Swift! Learn how to make iPhone and iPad apps from the ground up, with a series of epic-length tutorials for beginners!", chaptersRead: 3, chaptersTotal: 4),
    Book(title: "Swift Apprentice", cover: UIImage(named: "sa")!, authors: "By Janie Clayton, Alexis Gallagher, Matt Galloway, Eli Ganem, Erik Kerber and Ben Morrow", description: "Learn how to program with Swift 2!", chaptersRead: 8, chaptersTotal: 23)
  ]
  
}