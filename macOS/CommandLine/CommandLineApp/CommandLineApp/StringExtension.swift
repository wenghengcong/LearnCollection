//
//  StringExtension.swift
//  CommandLineApp
//
//  Created by WengHengcong on 2019/2/28.
//  Copyright © 2019 WengHengcong. All rights reserved.
//

import Foundation

extension String {
    func isAnagramOf(_ s: String) -> Bool {
        //1
        let lowerSelf = self.lowercased().replacingOccurrences(of: " ", with: "")
        let lowerOther = s.lowercased().replacingOccurrences(of: " ", with: "")
        //2
        return lowerSelf.sorted() == lowerOther.sorted()
    }
    
    func isPalindrome() -> Bool {
        //1
        let f = self.lowercased().replacingOccurrences(of: " ", with: "")
        //2
        let s = String(f.reversed())
        //3
        return  f == s
    }
}
