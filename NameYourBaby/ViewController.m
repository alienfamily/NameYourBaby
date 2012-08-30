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

@synthesize manageObjectContext, table, mutableBabies;

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
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:babiesEntity];
    NSSortDescriptor *keyDescriptor = [[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:keyDescriptor];
    [request setSortDescriptors:sortDescriptors];
    //[request setResultType:NSDictionaryResultType];
    //[request setReturnsDistinctResults:YES];
    //[request setPropertiesToFetch:[NSArray arrayWithObject:@"key"]];
    
    NSFetchRequest *getKeys = [[NSFetchRequest alloc] init];
    [getKeys setEntity:babiesEntity];
    [getKeys setResultType:NSDictionaryResultType];
    [getKeys setReturnsDistinctResults:YES];
    [getKeys setPropertiesToFetch:[NSArray arrayWithObject:@"key"]];
    NSError *err;
    NSArray *keys = [manageObjectContext executeFetchRequest:getKeys error:&err];
    if (!keys)
        NSLog(@"A BIG ERROR OCCURS %@", err);
    
    
    NSError *error;
    NSMutableArray *fetchResults = [[manageObjectContext executeFetchRequest:request error:&error] mutableCopy];

    if (!fetchResults)
        NSLog(@"A BIG ERROR OCCURS %@", error);
    
    [self setMutableBabies:fetchResults];
    
    NSMutableDictionary *tempo = [[NSMutableDictionary alloc] init];
    NSMutableArray *tab = [[NSMutableArray alloc] init];
    for (NSDictionary *key in keys) {
        for (Babies *babie in mutableBabies) {
            if ([[key objectForKey:@"key"] isEqualToString:babie.key]) {
                [tab addObject:babie];
            }
        }
        [tempo setObject:[tab mutableCopy] forKey:[key objectForKey:@"key"]];
        [tab removeAllObjects];
    }
    NSLog(@"%@", tempo);
    
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSString *firstKey, *oldKey;
    NSInteger nbSections=0;
    
    for (Babies *babie in mutableBabies) {
        firstKey = babie.key;
        if ([firstKey isEqualToString:oldKey]) {
            
        } else {
            nbSections++;
        }
        oldKey = firstKey;
    }
    
    return nbSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"title";
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
