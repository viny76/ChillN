//
//  Person.h
//  ChillN
//
//  Created by Vincent Jardel on 30/07/2015.
//  Copyright (c) 2015 ChillCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) id recordID;

@end