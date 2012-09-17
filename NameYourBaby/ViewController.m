//
//  ViewController.m
//  NameYourBaby
//
//  Created by Bou on 27/08/12.
//  Copyright (c) 2012 Bou. All rights reserved.
//

#import "ViewController.h"
#import "JSONKit.h"
#import "OLGhostAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize manageObjectContext, table, mutableBabies, sortedBabies, sortedKeys, sortDescriptorForBabiesForSection, descriptorsForBabiesForSection, babiesForSection, access, navBar, item;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    navBar.tintColor = [UIColor colorWithRed:148.f/255.f green:19.f/255.f blue:94.f/255.f alpha:1.f];
    item = [[UINavigationItem alloc] initWithTitle:@"Name your baby"];
    [navBar pushNavigationItem:item animated:NO];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                target:self
                                                                                 action:@selector(sendFavorites:)];
    [item setRightBarButtonItem:shareButton];
    [self.view addSubview:navBar];
    self.access = [[DBAccess alloc] initWithContext:manageObjectContext];
    self.sortedBabies = [[NSMutableDictionary alloc] init];
    sortDescriptorForBabiesForSection = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    descriptorsForBabiesForSection = [NSArray arrayWithObject:sortDescriptorForBabiesForSection];
    [self fetchrecords];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated {
    NSArray *allFavs = [self.access getFavs];
    if ([allFavs count] == 0) {
        self.navigationItem.leftBarButtonItem = nil;
        favExist = 0;
    }
    [self.table reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


/****************************************************************/
/*        fetchRecords method is used to retreive datas         */
/*        from core data and stock them into a NSMutableArray   */
/****************************************************************/
-(void)fetchrecords {
    NSPredicate *predicate;
    if (btnGirls == 1)
        predicate = [NSPredicate predicateWithFormat:@"type ==0"];
    if (btnBoys == 1)
        predicate = [NSPredicate predicateWithFormat:@"type ==1"];
    if (btnBoys == 0 && btnGirls == 0)
        predicate = [NSPredicate predicateWithFormat:@"type == 0 OR type == 1"];
    
    NSArray *fetchKeys = [self.access getKeys];

    NSMutableArray *allRecords = [self.access getAllRecords:predicate];
    [self setMutableBabies:allRecords];
    
    // Ordering records properly
    // Each letter is a key which have as value an array of Babies
    // The result is stored in a property sortedBabies
    NSMutableArray *arrayTmp = [[NSMutableArray alloc] init];
    for (NSDictionary *key in fetchKeys) {
        for (Babies *babie in mutableBabies) {
            if ([[key objectForKey:@"key"] isEqualToString:babie.key])
                [arrayTmp addObject:babie];
        }
        [self.sortedBabies setObject:[arrayTmp mutableCopy] forKey:[key objectForKey:@"key"]];
        [arrayTmp removeAllObjects];
    }
    
    sortedKeys = [NSArray arrayWithArray:[[self.sortedBabies allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    [self.table reloadData];
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
-(IBAction)sendFavorites:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSString *emailBody = [[NSString alloc] initWithFormat:@""];
                
        NSArray *allFavs = [self.access getFavs];

        if ([allFavs count] == 0) {
            OLGhostAlertView *ghost = [[OLGhostAlertView alloc] initWithTitle:@"No name selected" message:@"Select at least one name to share it :)" timeout:2 dismissible:YES];
            [ghost show];
        } else {
            for (Babies *element in allFavs)
                emailBody = [emailBody stringByAppendingString:[[element name] stringByAppendingString:@"\n"]];
            [mailer setMessageBody:emailBody isHTML:NO];
            [self presentModalViewController:mailer animated:YES];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"no mail available"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

/****************************************************************/
/*      showFavs method show a view                             */
/*      populate only with favs                                 */
/****************************************************************/
-(IBAction)showFavs:(id)sender {
    //FiltersBabies *filters = [FiltersBabies new];
    FiltersBabies *filters = [[FiltersBabies alloc] initWithNibNameAndContext:@"FiltersBabies"
                                                                       bundle:nil
                                                                      context:manageObjectContext];
    filters.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:filters animated:YES];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultFailed:
            break;
        case MFMailComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
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
    
    babiesForSection = [NSArray arrayWithArray:[self.sortedBabies objectForKey:[sortedKeys objectAtIndex:[indexPath section]]]];
    babiesForSection = [babiesForSection sortedArrayUsingDescriptors:descriptorsForBabiesForSection];
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
    NSManagedObject *babie = [[[NSArray arrayWithArray:[self.sortedBabies objectForKey:[sortedKeys objectAtIndex:[indexPath section]]]] sortedArrayUsingDescriptors:descriptorsForBabiesForSection] objectAtIndex:[indexPath row]];
    
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryView == nil) {
        UIImageView *picto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite.png"]];
        [tableView cellForRowAtIndexPath:indexPath].accessoryView = picto;
        [babie setValue:[NSNumber numberWithBool:YES] forKey:@"fav"];
        if (favExist == 0) {
            favExist = 1;
            UIBarButtonItem *showFavorites = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"favorite.png"]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(showFavs:)];
            [item setLeftBarButtonItem:showFavorites];
        }
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryView = nil;
        [babie setValue:[NSNumber numberWithBool:NO] forKey:@"fav"];

        NSArray *allFavs = [self.access getFavs];        
        if ([allFavs count] == 0) {
            [item setLeftBarButtonItem:nil];
            favExist = 0;
        }
    }
    
    NSError *error;
    if (![self.manageObjectContext save:&error])
        NSLog(@"A BIG ERROR OCCURS WHILE UPDATING FAV: %@", error);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return sortedKeys;
}

@end
