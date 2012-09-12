//
//  FiltersBabies.h
//  NameYourBaby
//
//  Created by Bou on 10/09/12.
//  Copyright (c) 2012 Bou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Babies.h"

@interface FiltersBabies : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UINavigationBar *navBar;
    NSManagedObjectContext *managedObjectContext;
    IBOutlet UITableView *table;
    NSMutableArray *mutableBabies;
}

@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *mutableBabies;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

-(IBAction)backToMainView:(id)sender;

@end
