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
                                                                                action:@selector(sendFavorites)];
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


/****************************************************************/
/*        fetchRecords method is used to retreive datas         */
/*        from core data and stock them into a NSMutableArray   */
/****************************************************************/
-(void)fetchrecords {
    NSEntityDescription *babiesEntity = [NSEntityDescription entityForName:@"Babies" inManagedObjectContext:manageObjectContext];
    
    // Setting the main request to
    // get every records from scratch
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:babiesEntity];
    NSSortDescriptor *keyDescriptor = [[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:keyDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    // Setting a second request to get the keys
    NSFetchRequest *getKeys = [[NSFetchRequest alloc] init];
    [getKeys setEntity:babiesEntity];
    [getKeys setResultType:NSDictionaryResultType];
    [getKeys setReturnsDistinctResults:YES];
    [getKeys setPropertiesToFetch:[NSArray arrayWithObject:@"key"]];
    // Executing the second request
    NSError *err;
    NSArray *keys = [manageObjectContext executeFetchRequest:getKeys error:&err];
    if (!keys)
        NSLog(@"A BIG ERROR OCCURS WHILE GETTING KEYS : %@", err);
    
    // Executing the first request
    NSError *error;
    NSMutableArray *fetchResults = [[manageObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (!fetchResults)
        NSLog(@"A BIG ERROR OCCURS WHILE GETTING ALL RECORDS: %@", error);
    
    // Storing the records in the property mutableBabies
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
    
    // Populating the property sortedKeys
    sortedKeys = [NSArray arrayWithArray:[[sortedBabies allKeys] sortedArrayUsingSelector:@selector(compare:)]];
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

    // Setting babie's name
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
    
}

@end
