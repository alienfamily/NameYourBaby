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
/*        from core data and stock them into a NSDictionary     */
/****************************************************************/
-(void)fetchrecords {
    /*
    NSEntityDescription *babiesEntity = [NSEntityDescription entityForName:@"Babies" inManagedObjectContext:manageObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:babiesEntity];
    
    // Get boys in an array
    [request setPredicate:predicateBoys];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *boys = [NSArray arrayWithArray:[manageObjectContext executeFetchRequest:request error:&error]];
    NSLog(@"%@", boys);
    
    NSString* st = [boys JSONString];
    NSLog(@"JSON String: %@",st);
    
    //NSError *error;
    //NSMutableDictionary *fetchResults = [[manageObjectContext executeFetchRequest:request error:&error] mutableCopy];
    //if (!fetchResults)
      //  NSLog(@"A BIG ERROR OCCURS %@", error);
    
    //[self setMutableBabies:fetchResults];
     */
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // UPDATE ME
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // UPDATE ME
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
