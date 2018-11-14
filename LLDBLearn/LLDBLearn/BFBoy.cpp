//
//  BFBoy.cpp
//  LLDBLearn
//
//  Created by 翁恒丛 on 2018/11/14.
//  Copyright © 2018年 翁恒丛. All rights reserved.
//

#include "BFBoy.hpp"

BFBoy::BFBoy(double a, bool handsome)
{
    this->asset = a;
    this->handsome = handsome;
};

void BFBoy::workingHard()
{
    asset = asset + 100;
}
