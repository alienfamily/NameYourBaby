//
//  FiltersBabies.m
//  NameYourBaby
//
//  Created by Bou on 10/09/12.
//  Copyright (c) 2012 Bou. All rights reserved.
//

#import "FiltersBabies.h"
#import "ViewController.h"

@interface FiltersBabies ()

@end

@implementation FiltersBabies

@synthesize navBar;

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
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Title";
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        
}

@end
