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
    NSMutableDictionary *mutableBabies;
}

@property (nonatomic, strong) NSManagedObjectContext *manageObjectContext;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableDictionary *mutableBabies;

-(void)fetchrecords;

@end
