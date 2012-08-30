//
//  Babies.h
//  NameYourBaby
//
//  Created by Bou on 27/08/12.
//  Copyright (c) 2012 Bou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Babies : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * fav;

@end
