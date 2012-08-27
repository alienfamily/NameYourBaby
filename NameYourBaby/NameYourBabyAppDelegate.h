//
//  NameYourBabyAppDelegate.h
//  NameYourBaby
//
//  Created by Rémy ALEXANDRE on 05/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameYourBabyAppDelegate : NSObject <UIApplicationDelegate> {
    UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
