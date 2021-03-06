//
//  ViewController.h
//  NameYourBaby
//
//  Created by Bou on 27/08/12.
//  Copyright (c) 2012 Bou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Babies.h"
#import "FiltersBabies.h"
#import "DBAccess.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate> {
    NSManagedObjectContext  *manageObjectContext;
    IBOutlet UITableView    *table;
    NSMutableArray *mutableBabies;
    NSMutableDictionary *sortedBabies;
    NSArray *sortedKeys;
    NSInteger btnBoys;
    NSInteger btnGirls;
    NSInteger favExist;
    NSSortDescriptor *sortDescriptorForBabiesForSection;
    NSArray *descriptorsForBabiesForSection;
    NSArray *babiesForSection;
    UINavigationBar *navBar;
    UINavigationItem *item;
    DBAccess *access;
}

@property (nonatomic, strong) NSManagedObjectContext *manageObjectContext;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *mutableBabies;
@property (nonatomic, strong) NSMutableDictionary *sortedBabies;
@property (nonatomic, strong) UINavigationItem *item;
@property (nonatomic, strong) NSArray *sortedKeys;
@property (nonatomic, strong) NSSortDescriptor *sortDescriptorForBabiesForSection;
@property (nonatomic, strong) NSArray *descriptorsForBabiesForSection;
@property (nonatomic, strong) NSArray *babiesForSection;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) DBAccess *access;

-(void)fetchrecords;
-(IBAction)genderSelected:(id)sender;
-(IBAction)sendFavorites:(id)sender;
-(IBAction)showFavs:(id)sender;

@end
