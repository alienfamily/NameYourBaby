//
//  ViewController.h
//  NameYourBaby
//
//  Created by Bou on 27/08/12.
//  Copyright (c) 2012 Bou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Babies.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSManagedObjectContext  *manageObjectContext;
    IBOutlet UITableView    *table;
    NSMutableArray *mutableBabies;
    NSMutableDictionary *sortedBabies;
    NSArray *sortedKeys;
}

@property (nonatomic, strong) NSManagedObjectContext *manageObjectContext;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *mutableBabies;
@property (nonatomic, strong) NSMutableDictionary *sortedBabies;
@property (nonatomic, strong) NSArray *sortedKeys;

-(void)fetchrecords;

@end
