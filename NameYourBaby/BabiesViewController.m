//
//  BabiesViewController.m
//  NameYourBaby
//
//  Created by Rémy ALEXANDRE on 05/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BabiesViewController.h"
#import "Babies.h"

@implementation BabiesViewController

@synthesize managedObjectContext;
@synthesize mutableBabies;
@synthesize table;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];    
    self.title = @"Babies";
    //nbElements = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                               target:self 
                                                                               action:@selector(sendFavorites:)];
    self.navigationItem.rightBarButtonItem = sendButton;
    [sendButton release];
    
    BOYS_BTN = 1;
    GIRLS_BTN = 1;

    [self fetchRecords];
}

- (IBAction)btnPressed:(id)sender {
    if ([[(UIButton *)sender currentTitle] isEqualToString:@"Boys"]) {
        if (BOYS_BTN == 1) {
            BOYS_BTN = 0;
        } else {
            BOYS_BTN = 1;
        }
    } else {
        if (GIRLS_BTN == 1) {
            GIRLS_BTN = 0;
        } else {
            GIRLS_BTN = 1;
        }
    }
    
    [self fetchRecords];
    [table reloadData];
}

- (void)sendFavorites:(id)sender {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Fav == 1"];
    NSEntityDescription *babies = [NSEntityDescription entityForName:@"Babies" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:babies];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptor release];
    
    NSError *error;
    NSMutableArray *fetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (!fetchResults) {
        // BIG ERROR DE CHEZ BIG ERROR
    }
    
    if ([fetchResults count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nop" 
                                                        message:@"Il faut choisir au moins un prénom pour le partager." 
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [fetchResults release];
        [request release];
    } else {
    
        // nothing    
    }
}

- (void)fetchRecords {
    
    NSLog(@"boysBTN = %d, girlsBTN = %d", BOYS_BTN, GIRLS_BTN);
    
    // if boysBtn && girlsBtn then all, else boysBtn then only boys, else girlsBtn then only girls

    NSPredicate *predicate;
    if ((BOYS_BTN == 0) && (GIRLS_BTN == 1)) {
        predicate = [NSPredicate predicateWithFormat:@"Type == 0"];
    }
    if ((BOYS_BTN == 1) && (GIRLS_BTN == 0)) {
        predicate = [NSPredicate predicateWithFormat:@"Type == 1"];
    }
    if ((BOYS_BTN == 1) && (GIRLS_BTN == 1)) {
        predicate = [NSPredicate predicateWithFormat:@"Type == 1 OR Type == 0"];
    }
    if ((BOYS_BTN == 0) && (GIRLS_BTN == 0)) {
        BOYS_BTN = 1;
        GIRLS_BTN = 1;
        predicate = [NSPredicate predicateWithFormat:@"Type == 1 OR Type == 0"];
    }
    
    NSEntityDescription *babies = [NSEntityDescription entityForName:@"Babies" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:babies];
    [request setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptor release];
    
    NSError *error;
    NSMutableArray *fetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (!fetchResults) {
        // BIG ERROR DE CHEZ BIG ERROR
    }
    
    [self setMutableBabies:fetchResults];
    [fetchResults release];
    [request release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // I could have used setPropertiesToFetch to only have the Names
    NSString *firstLetter = nil;
    NSString *oldLetter = nil;
    NSInteger nbSections = 0;
    
    for (Babies *element in mutableBabies) {
        firstLetter = [element.Name substringToIndex:1];
        if ([firstLetter isEqualToString:oldLetter]) {
            // Nothing
        } else {
            nbSections++;   
        }
        oldLetter = firstLetter;
    }
    //NSLog(@"number %d", nbSections);
    return nbSections-1;
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *first = nil;
    NSString *old = nil;
    NSInteger total = 1;
    NSMutableArray *tab = [[NSMutableArray alloc] init];
    int i = 0;
    
    for (Babies *nbElements in mutableBabies) {
        first = [nbElements.Name substringToIndex:1];
        if ([first isEqualToString:old]) {
            total++;
        } else {
            if (i != 0) {
                //NSLog(@"total, %d", total);
                [tab addObject:[NSNumber numberWithInt:total]];
            }
            total = 1;
        }
        i = 1;
        old = first;
    }
    return [[tab objectAtIndex:section] intValue];
    //return [mutableBabies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Babies *babie = [mutableBabies objectAtIndex:[indexPath row]];
    
    // Adding babies names
    [cell.textLabel setText:[babie Name]];
    
    // Dealling with sex
    NSString *type = @"Garçon";
    [cell.imageView setImage:[UIImage imageNamed:@"pictoHomme.png"]];
    if ([babie.Type intValue] == 0) {
        type = @"Fille";
        [cell.imageView setImage:[UIImage imageNamed:@"pictoFemme.png"]];
    }
    
    // Dealling with favorite
    if ([babie.Fav intValue] == 1) {
        UIImage *image = [UIImage imageNamed:@"favorite.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];;
        cell.accessoryView = imageView;
        [imageView release];
    } else {
        cell.accessoryView = nil;
    }
            
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *firstLetter = nil;
    NSString *oldLetter = nil;
    NSMutableArray *listTitles;
    listTitles = [[NSMutableArray alloc] init];
    for (Babies *element in mutableBabies) {
        firstLetter = [element.Name substringToIndex:1];
        if ([firstLetter isEqualToString:oldLetter]) {
            // nothing
        } else {
            [listTitles addObject:firstLetter];
        }
        oldLetter = firstLetter;
    }
    return [listTitles objectAtIndex:section];
}
 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *babie = [mutableBabies objectAtIndex:indexPath.row];
    
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryView == nil) {
        UIImage *image = [UIImage imageNamed:@"favorite.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [tableView cellForRowAtIndexPath:indexPath].accessoryView = imageView;
        [imageView release];
        [babie setValue:[NSNumber numberWithBool:YES] forKey:@"Fav"];
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryView = nil;
        [babie setValue:[NSNumber numberWithBool:NO] forKey:@"Fav"];
    }
    NSLog(@"Updating %@", babie);
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Saving changesfailed: %@", error);
    }
}

- (void)dealloc {
    [managedObjectContext release];
    [mutableBabies release];
    [table release];
    [super dealloc];
}

@end
