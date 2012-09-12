//
//  FiltersBabies.h
//  NameYourBaby
//
//  Created by Bou on 10/09/12.
//  Copyright (c) 2012 Bou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Babies.h"
#import "DBAccess.h"

@interface FiltersBabies : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UINavigationBar *navBar;
    NSManagedObjectContext *managedObjectContext;
    IBOutlet UITableView *table;
    NSMutableArray *mutableBabies;
    NSMutableDictionary *sortedBabies;
    NSArray *sortedKeys;
    NSArray *babiesForSection;
    NSSortDescriptor *sortDescriptorForBabiesForSection;
    NSArray *descriptorsForBabiesForSection;
    DBAccess *access;
}

@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *mutableBabies;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableDictionary *sortedBabies;
@property (nonatomic, strong) NSArray *sortedKeys;
@property (nonatomic, strong) NSArray *babiesForSection;
@property (nonatomic, strong) NSSortDescriptor *sortDescriptorForBabiesForSection;
@property (nonatomic, strong) NSArray *descriptorsForBabiesForSection;
@property (nonatomic, strong) DBAccess *access;

-(id)initWithNibNameAndContext:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil context:(NSManagedObjectContext *)managedObjectContextReceived;
-(IBAction)backToMainView:(id)sender;

@end
