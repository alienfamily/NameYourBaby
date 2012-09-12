//
//  DBAccess.h
//  NameYourBaby
//
//  Created by Bou on 12/09/12.
//  Copyright (c) 2012 Bou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBAccess : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSEntityDescription *babiesEntity;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSEntityDescription *babiesEntity;

-(DBAccess *)initWithContext:(NSManagedObjectContext *)managedObjectContextReceived;
-(NSArray *)getKeys;
-(NSArray *)getFavs;
-(NSMutableArray *)getAllRecords:(NSPredicate *)predicateReceived;

@end
