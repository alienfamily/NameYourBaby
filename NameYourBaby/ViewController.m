//
//  ViewController.m
//  NameYourBaby
//
//  Created by Bou on 27/08/12.
//  Copyright (c) 2012 Bou. All rights reserved.
//

#import "ViewController.h"
#import "JSONKit.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize manageObjectContext, table, mutableBabies, sortedBabies, sortedKeys;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    /****************************************************************/
    /*                     START - Setting UI                       */
    /****************************************************************/
    
    [self setTitle:@"Babies"];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                target:self
                                                                                 action:@selector(sendFavorites:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    /****************************************************************/
    /*                     END - Setting UI                         */
    /****************************************************************/
    
    /****************************************************************/
    /*   START - Retrieving datas from core data to tableView UI    */
    /****************************************************************/
    self.sortedBabies = [[NSMutableDictionary alloc] init];
    [self fetchrecords];
    
    /****************************************************************/
    /*    END - Retrieving datas from core data to tableView UI     */
    /****************************************************************/
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/****************************************************************/
/*        fetchRecords method is used to retreive datas         */
/*        from core data and stock them into a NSMutableArray   */
/****************************************************************/
-(void)fetchrecords {
    NSEntityDescription *babiesEntity = [NSEntityDescription entityForName:@"Babies" inManagedObjectContext:manageObjectContext];
    
    // Setting the main request to
    // get every records from scratch
    NSPredicate *predicate;
    if (btnGirls == 1)
        predicate = [NSPredicate predicateWithFormat:@"type ==0"];
    if (btnBoys == 1)
        predicate = [NSPredicate predicateWithFormat:@"type ==1"];
    if (btnBoys == 0 && btnGirls == 0)
        predicate = [NSPredicate predicateWithFormat:@"type == 0 OR type == 1"];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:babiesEntity];
    [request setPredicate:predicate];
    NSSortDescriptor *keyDescriptor = [[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:keyDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    // Setting and executing a second
    // request to get the keys
    NSFetchRequest *getKeys = [[NSFetchRequest alloc] init];
    [getKeys setEntity:babiesEntity];
    [getKeys setResultType:NSDictionaryResultType];
    [getKeys setReturnsDistinctResults:YES];
    [getKeys setPropertiesToFetch:[NSArray arrayWithObject:@"key"]];
    NSError *err;
    NSArray *keys = [manageObjectContext executeFetchRequest:getKeys error:&err];
    if (!keys)
        NSLog(@"A BIG ERROR OCCURS WHILE GETTING KEYS: %@", err);
    
    // Executing the first request
    NSError *error;
    NSMutableArray *fetchResults = [[manageObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (!fetchResults)
        NSLog(@"A BIG ERROR OCCURS WHILE GETTING ALL RECORDS: %@", error);
    
    [self setMutableBabies:fetchResults];
    
    // Ordering the records properly
    // Each letter is a key which have as value an array of Babies
    // The result is stored in a property sortedBabies
    NSMutableArray *arrayTmp = [[NSMutableArray alloc] init];
    for (NSDictionary *key in keys) {
        for (Babies *babie in mutableBabies) {
            if ([[key objectForKey:@"key"] isEqualToString:babie.key])
                [arrayTmp addObject:babie];
        }
        [self.sortedBabies setObject:[arrayTmp mutableCopy] forKey:[key objectForKey:@"key"]];
        [arrayTmp removeAllObjects];
    }
    
    sortedKeys = [NSArray arrayWithArray:[[sortedBabies allKeys] sortedArrayUsingSelector:@selector(compare:)]];
}

/****************************************************************/
/*      genderSelected method is used to filter by gender       */
/****************************************************************/
-(IBAction)genderSelected:(id)sender {
    if ([[(UIButton *)sender currentTitle] isEqualToString:@"Boys"]) {
        switch (btnBoys) {
            case 0:
                btnBoys = 1;
                btnGirls = 0;
                break;
            case 1:
                btnBoys = 0;
                break;
            default:
                break;
        }
    } else {
        switch (btnGirls) {
            case 0:
                btnGirls = 1;
                btnBoys = 0;
                break;
            case 1:
                btnGirls = 0;
                break;
            default:
                break;
        }
    }
    
    [self fetchrecords];
    [table reloadData];
}

/****************************************************************/
/*      sendFavorites method create an e-mail                   */
/*      with a list of babie's names                            */
/****************************************************************/
-(void)sendFavorites:(id)sender {
    
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[sortedBabies allKeys] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[sortedBabies objectForKey:[sortedKeys objectAtIndex:section]] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    NSArray *babiesForSection = [NSArray arrayWithArray:[sortedBabies objectForKey:[sortedKeys objectAtIndex:[indexPath section]]]];
    Babies *babie = [babiesForSection objectAtIndex:[indexPath row]];

    [cell.textLabel setText:[babie name]];
    
    // Dealling with sex
    if ([babie.type intValue] == 0) {
        [cell.imageView setImage:[UIImage imageNamed:@"pictoFemme.png"]];
    } else {
        [cell.imageView setImage:[UIImage imageNamed:@"pictoHomme.png"]];
    }
    
    // Dealling with favorites
    if ([babie.fav intValue] == 1) {
        UIImageView *picto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite.png"]];
        cell.accessoryView = picto;
    } else {
        cell.accessoryView = nil;
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sortedKeys objectAtIndex:section];
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *babie = [[NSArray arrayWithArray:[sortedBabies objectForKey:[sortedKeys objectAtIndex:[indexPath section]]]] objectAtIndex:[indexPath row]];
    
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryView == nil) {
        UIImageView *picto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite.png"]];
        [tableView cellForRowAtIndexPath:indexPath].accessoryView = picto;
        [babie setValue:[NSNumber numberWithBool:YES] forKey:@"fav"];
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryView = nil;
        [babie setValue:[NSNumber numberWithBool:NO] forKey:@"fav"];
    }
    
    NSError *error;
    if (![self.manageObjectContext save:&error]) {
        NSLog(@"A BIG ERROR OCCURS WHILE UPDATING FAV: %@", error);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return sortedKeys;
}

@end
