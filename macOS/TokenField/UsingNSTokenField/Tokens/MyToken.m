/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Custom token class.
 */

#import "MyToken.h"

@implementation MyToken

// NSCoder routines necessary for token drag and drop

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.name];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
	_name = [decoder decodeObject];
	return self;
}

@end
