//
//  DBAccess.m
//  NameYourBaby
//
//  Created by Bou on 12/09/12.
//  Copyright (c) 2012 Bou. All rights reserved.
//

#import "DBAccess.h"
#import "Babies.h"

@implementation DBAccess

@synthesize managedObjectContext, babiesEntity;

-(id)init {
    self = [super init];
    return self;
}

-(DBAccess *)initWithContext:(NSManagedObjectContext *)managedObjectContextReceived {
    self = [super init];
    
    if (self) {
        self.managedObjectContext = managedObjectContextReceived;
        babiesEntity = [NSEntityDescription entityForName:@"Babies"
                                   inManagedObjectContext:self.managedObjectContext];
    }
    
    return self;
}

-(NSArray *)getKeys {
    NSFetchRequest *fetchKeys = [[NSFetchRequest alloc] init];
    [fetchKeys setEntity:babiesEntity];
    [fetchKeys setResultType:NSDictionaryResultType];
    [fetchKeys setReturnsDistinctResults:YES];
    [fetchKeys setPropertiesToFetch:[NSArray arrayWithObject:@"key"]];
    NSError *err;
    NSArray *keys = [self.managedObjectContext executeFetchRequest:fetchKeys error:&err];
    if (!keys)
        NSLog(@"A BIG ERROR OCCURS WHILE GETTING KEYS: %@", err);
    
    return keys;
}

-(NSArray *)getFavs {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fav == 1"];
    NSFetchRequest *fetchFavs = [[NSFetchRequest alloc] init];
    [fetchFavs setEntity:babiesEntity];
    [fetchFavs setPredicate:predicate];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
    [fetchFavs setSortDescriptors:sortDescriptors];
    NSError *error;
    NSArray *favorites = [self.managedObjectContext executeFetchRequest:fetchFavs error:&error];
    if (!favorites)
        NSLog(@"A BIG ERROR OCCURS WHILE RETRIEVING FAVORITES: %@", error);
    
    return favorites;
}

-(NSMutableArray *)getAllRecords:predicateReceived {
    NSFetchRequest *fetchAllrecords = [[NSFetchRequest alloc] init];
    [fetchAllrecords setEntity:babiesEntity];
    [fetchAllrecords setPredicate:predicateReceived];
    NSSortDescriptor *keyDescriptor = [[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:keyDescriptor];
    [fetchAllrecords setSortDescriptors:sortDescriptors];
    NSError *error;
    NSMutableArray *records = [[self.managedObjectContext executeFetchRequest:fetchAllrecords error:&error] mutableCopy];
    if (!records)
        NSLog(@"A BIG ERROR OCCURS WHILE GETTING ALL RECORDS: %@", error);
    return records;
}

@end
