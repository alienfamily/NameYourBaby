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

@synthesize navBar, mutableBabies, table, managedObjectContext, access, sortedBabies, sortedKeys, babiesForSection, sortDescriptorForBabiesForSection, descriptorsForBabiesForSection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(id)initWithNibNameAndContext:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil context:(NSManagedObjectContext *)managedObjectContextReceived {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        navBar.tintColor = [UIColor colorWithRed:156.f/255.f green:208.f/255.f blue:57.f/255.f  alpha:1.f];
        UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Favorite(s) name(s)"];
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"favorite.png"]
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(backToMainView:)];
        [item setLeftBarButtonItem:backButton];
        [navBar pushNavigationItem:item animated:NO];
        self.managedObjectContext = managedObjectContextReceived;
        access = [[DBAccess alloc] initWithContext:self.managedObjectContext];
        sortDescriptorForBabiesForSection = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        descriptorsForBabiesForSection = [NSArray arrayWithObject:sortDescriptorForBabiesForSection];
        [self.view addSubview:navBar];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sortedBabies = [[NSMutableDictionary alloc] init];
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
    NSMutableArray *allFavorites = [[self.access getFavs] mutableCopy];
    
    NSMutableArray *favsKeys = [[NSMutableArray alloc] init];
    NSString *compareFirst = [NSString stringWithFormat:@""];
    
    for (Babies *bob in allFavorites) {
        if (![bob.key isEqualToString:compareFirst])
            [favsKeys addObject:bob.key];
        compareFirst = bob.key;
    }
    
    [self setMutableBabies:allFavorites];
    
    // Ordering the records properly
    // Each letter is a key which have as value an array of Babies
    // The result is stored in a property sortedBabies
    NSMutableArray *arrayTmp = [[NSMutableArray alloc] init];
    for (NSString *key in favsKeys) {
        for (Babies *babie in mutableBabies) {
            if ([key isEqualToString:babie.key])
                [arrayTmp addObject:babie];
        }
        [self.sortedBabies setObject:[arrayTmp mutableCopy] forKey:key];
        [arrayTmp removeAllObjects];
    }
    
    sortedKeys = [NSArray arrayWithArray:[[self.sortedBabies allKeys] sortedArrayUsingSelector:@selector(compare:)]];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[sortedBabies allKeys] count];;
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
    
    babiesForSection = [NSArray arrayWithArray:[self.sortedBabies objectForKey:[sortedKeys objectAtIndex:[indexPath section]]]];
    babiesForSection = [babiesForSection sortedArrayUsingDescriptors:descriptorsForBabiesForSection];
    
    Babies *babie = [babiesForSection objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = babie.name;
    
    // Dealling with sex
    if ([babie.type intValue] == 0) {
        [cell.imageView setImage:[UIImage imageNamed:@"icogirl.png"]];
    } else {
        [cell.imageView setImage:[UIImage imageNamed:@"icoboy.png"]];
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
    NSManagedObject *babie = [[[NSArray arrayWithArray:[self.sortedBabies objectForKey:[sortedKeys objectAtIndex:[indexPath section]]]] sortedArrayUsingDescriptors:descriptorsForBabiesForSection] objectAtIndex:[indexPath row]];
    
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryView == nil) {
        UIImageView *picto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite.png"]];
        [tableView cellForRowAtIndexPath:indexPath].accessoryView = picto;
        [babie setValue:[NSNumber numberWithBool:YES] forKey:@"fav"];
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryView = nil;
        [babie setValue:[NSNumber numberWithBool:NO] forKey:@"fav"];
    }
    
    NSError *error;
    if (![self.managedObjectContext save:&error])
        NSLog(@"A BIG ERROR OCCURS WHILE UPDATING FAV: %@", error);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
