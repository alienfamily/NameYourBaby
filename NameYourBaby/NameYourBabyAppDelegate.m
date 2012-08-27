//
//  NameYourBabyAppDelegate.m
//  NameYourBaby
//
//  Created by Rémy ALEXANDRE on 05/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NameYourBabyAppDelegate.h"
#import "BabiesViewController.h"

@implementation NameYourBabyAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Adding the navigation controller
    navController = [[UINavigationController alloc] init];
    navController.navigationBar.tintColor = [UIColor colorWithRed:148.f/255.f green:19.f/255.f blue:94.f/255.f alpha:1.f];
    [self.window addSubview:navController.view];
    
    if (self.managedObjectContext == nil) {
        self.managedObjectContext = [(NameYourBabyAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    /***************************************/
    /*           truncating DB             */
    /*           TO REMOVE ONCE DEVS WILL BE DONE !!!!            */
    /***************************************/
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *toDelete = [NSEntityDescription entityForName:@"Babies"
                                                inManagedObjectContext:self.managedObjectContext];
    [request setEntity:toDelete];
    [request setIncludesPropertyValues:NO];
    
    NSError *err = nil;
    NSArray *eventarray = [self.managedObjectContext executeFetchRequest:request error:&err];
    [request release];
    for (NSManagedObject *Name in eventarray) {
        [self.managedObjectContext deleteObject:Name];
    }
    for (NSManagedObject *Type in eventarray) {
        [self.managedObjectContext deleteObject:Type];
    }
    for (NSManagedObject *Fav in eventarray) {
        [self.managedObjectContext deleteObject:Fav];
    }
    
    /**********************************/
    /*   START - Initializing th DB   */
    /**********************************/
    
    // Loading plist file
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"initiateDB" ofType:@"plist"];
    NSDictionary *dico = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    // Loading girls in DB, FAV = NO, TYPE = NO, c'est des fillllleeeeeuuuuuu
    NSArray *tabGirl = [dico objectForKey:@"Filles"];
    for (NSString *n in tabGirl) {
        Babies *babie = (Babies *)[NSEntityDescription insertNewObjectForEntityForName:@"Babies" 
                                                                inManagedObjectContext:self.managedObjectContext];
        [babie setValue:n forKey:@"Name"];
        [babie setValue:[NSNumber numberWithBool:NO] forKey:@"Fav"];
        [babie setValue:[NSNumber numberWithBool:NO] forKey:@"Type"];
    }
    
    // Loading boys in DB, FAV = NO, TYPE = YES
    NSArray *tabBoy = [dico objectForKey:@"Garcons"];
    for (NSString *name in tabBoy) {
        Babies *babie = (Babies *)[NSEntityDescription insertNewObjectForEntityForName:@"Babies"
                                                                inManagedObjectContext:self.managedObjectContext];
        [babie setValue:name forKey:@"Name"];
        [babie setValue:[NSNumber numberWithBool:NO] forKey:@"Fav"];
        [babie setValue:[NSNumber numberWithBool:YES] forKey:@"Type"];
    }
    
    [dico release];
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Saving changes failed: %@", error);
    }

    // Fetching datas, Only logs
    NSFetchRequest *request1 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Babies" inManagedObjectContext:self.managedObjectContext];
    [request1 setEntity:entity];
    [request1 setIncludesPropertyValues:NO];
    [request1 release];
    
    /**********************************/
    /*    END - Initializing th DB    */
    /**********************************/

    // Setting babies view as the first one
    BabiesViewController *babiesVC = [[BabiesViewController alloc] initWithNibName:@"BabiesViewController" bundle:nil];
    babiesVC.managedObjectContext = [self managedObjectContext];
    [navController pushViewController:babiesVC animated:NO];
    [babiesVC release];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

- (void)awakeFromNib
{
    /*
     Typically you should set up the Core Data stack here, usually by passing the managed object context to the first view controller.
     self.<#View controller#>.managedObjectContext = self.managedObjectContext;
    */
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NameYourBaby" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NameYourBaby.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
