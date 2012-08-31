//
//  AppDelegate.m
//  NameYourBaby
//
//  Created by Bou on 27/08/12.
//  Copyright (c) 2012 Bou. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "JSONKit.h"

@implementation AppDelegate

@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    navController = [[UINavigationController alloc] init];
    navController.navigationBar.tintColor = [UIColor colorWithRed:148.f/255.f green:19.f/255.f blue:94.f/255.f alpha:1.f];
    [self.window addSubview:navController.view];
    
    if (self.managedObjectContext == nil)
        self.managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    #if PREPROD
    
    /************************************************************/
    /*          START - Cleaning the DB from all datas          */
    /************************************************************/
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *toDelete = [NSEntityDescription entityForName:@"Babies" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:toDelete];
    [request setIncludesPropertyValues:NO];
    NSError *err = nil;
    
    NSArray *babiesArray = [self.managedObjectContext executeFetchRequest:request error:&err];
    for (NSManagedObject *name in babiesArray)
        [self.managedObjectContext deleteObject:name];
    for (NSManagedObject *type in babiesArray)
        [self.managedObjectContext deleteObject:type];
    for (NSManagedObject *fav in babiesArray)
        [self.managedObjectContext deleteObject:fav];
    for (NSManagedObject *key in babiesArray)
        [self.managedObjectContext deleteObject:key];
    
    /************************************************************/
    /*          END - Cleaning the DB from all datas            */
    /************************************************************/
    
    /************************************************************/
    /*                  START - Initializing DB                 */
    /*      Here we parse the json file "DBName.json"           */
    /*      and store datas in core data                        */
    /************************************************************/
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"DBName" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:plistPath];
    NSDictionary *dicoFromJson = [[NSDictionary alloc] init];
    dicoFromJson = [jsonData objectFromJSONData];
    
    NSArray *keyLetters = [NSArray arrayWithArray:[dicoFromJson allKeys]];
    keyLetters = [keyLetters sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSString *letter in keyLetters) {
        for (NSString *boyName in [[[dicoFromJson objectForKey:letter] objectForKey:@"Boys"] sortedArrayUsingSelector:@selector(compare:)]) {
            Babies *babie = (Babies *)[NSEntityDescription insertNewObjectForEntityForName:@"Babies"
                                                                    inManagedObjectContext:self.managedObjectContext];
            [babie setValue:boyName forKey:@"name"];
            [babie setValue:[NSNumber numberWithBool:NO] forKey:@"fav"];
            [babie setValue:[NSNumber numberWithBool:YES] forKey:@"type"];
            [babie setValue:letter forKey:@"key"];
        }
        for (NSString *girlName in [[[dicoFromJson objectForKey:letter] objectForKey:@"Girls"] sortedArrayUsingSelector:@selector(compare:)]) {
            Babies *babie = (Babies *)[NSEntityDescription insertNewObjectForEntityForName:@"Babies"
                                                                    inManagedObjectContext:self.managedObjectContext];
            [babie setValue:girlName forKey:@"name"];
            [babie setValue:[NSNumber numberWithBool:NO] forKey:@"fav"];
            [babie setValue:[NSNumber numberWithBool:NO] forKey:@"type"];
            [babie setValue:letter forKey:@"key"];
        }
    }
    
    NSError *error;
    if (![self.managedObjectContext save:&error])
        NSLog(@"Saving changes failed : %@", error);
    
    /************************************************************/
    /*                   END - Initializing DB                  */
    /************************************************************/
    
    #endif
    
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    self.viewController.manageObjectContext = [self managedObjectContext];
    
    [navController pushViewController:self.viewController animated:NO];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Explicitly write Core Data accessors
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
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AppWithCoreData.sqlite"];
    
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
