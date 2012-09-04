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
    NSInteger btnBoys;
    NSInteger btnGirls;
    NSSortDescriptor *sortDescriptorForBabiesForSection;
    NSArray *descriptorsForBabiesForSection;
    NSArray *babiesForSection;
}

@property (nonatomic, strong) NSManagedObjectContext *manageObjectContext;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *mutableBabies;
@property (nonatomic, strong) NSMutableDictionary *sortedBabies;
@property (nonatomic, strong) NSArray *sortedKeys;
@property (nonatomic, strong) NSSortDescriptor *sortDescriptorForBabiesForSection;
@property (nonatomic, strong) NSArray *descriptorsForBabiesForSection;
@property (nonatomic, strong) NSArray *babiesForSection;

-(void)fetchrecords;
-(IBAction)genderSelected:(id)sender;
-(void)sendFavorites:(id)sender;

@end
