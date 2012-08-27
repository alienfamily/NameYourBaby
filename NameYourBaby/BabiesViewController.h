//
//  BabiesViewController.h
//  NameYourBaby
//
//  Created by Rémy ALEXANDRE on 05/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Babies.h"

@interface BabiesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSManagedObjectContext  *managedObjectContext;
    NSMutableArray          *mutableBabies;
    IBOutlet UITableView    *table;
    NSInteger BOYS_BTN;
    NSInteger GIRLS_BTN;
}

@property (nonatomic, retain) NSManagedObjectContext    *managedObjectContext;
@property (nonatomic, retain) NSMutableArray            *mutableBabies;
@property (nonatomic, retain) UITableView               *table;

- (void)fetchRecords;
- (void)sendFavorites:(id)sender;
- (IBAction)btnPressed:(id)sender;

@end
