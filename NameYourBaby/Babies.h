//
//  Babies.h
//  NameYourBaby
//
//  Created by Rémy ALEXANDRE on 06/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Babies : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * Type;
@property (nonatomic, retain) NSNumber * Fav;
@property (nonatomic, retain) NSString * Name;

@end
