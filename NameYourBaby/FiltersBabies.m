//
//  FiltersBabies.m
//  NameYourBaby
//
//  Created by Bou on 10/09/12.
//  Copyright (c) 2012 Bou. All rights reserved.
//

#import "FiltersBabies.h"

@interface FiltersBabies ()

@end

@implementation FiltersBabies

@synthesize navBar, mutableBabies, table, managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        navBar.tintColor = [UIColor colorWithRed:148.f/255.f green:19.f/255.f blue:94.f/255.f alpha:1.f];
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Choosen name(s)"];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"favorite.png"]
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
                                                                         action:@selector(backToMainView:)];
        [item setLeftBarButtonItem:backButton];
        [navBar pushNavigationItem:item animated:NO];
        [self.view addSubview:navBar];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchFavsRecords];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)backToMainView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)fetchFavsRecords {
    NSEntityDescription *babiesEntity = [NSEntityDescription entityForName:@"Babies" inManagedObjectContext:managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"fav == 1"];
    NSFetchRequest *getFavs = [[NSFetchRequest alloc] init];
    [getFavs setEntity:babiesEntity];
    [getFavs setPredicate:predicate];
    NSSortDescriptor *keyDescriptor = [[NSSortDescriptor alloc] initWithKey:@"key" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:keyDescriptor];
    [getFavs setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSMutableArray *fetchResults = [[managedObjectContext executeFetchRequest:getFavs error:&error] mutableCopy];
    if (!fetchResults)
        NSLog(@"A BIG ERROR OCCURS WHILE RETREIVING FAV FOR FILTERSBABIES");
    [self setMutableBabies:fetchResults];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mutableBabies count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    Babies *babie = [mutableBabies objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = babie.name;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Title";
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
}

@end
