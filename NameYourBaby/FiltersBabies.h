//
//  FiltersBabies.h
//  NameYourBaby
//
//  Created by Bou on 10/09/12.
//  Copyright (c) 2012 Bou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FiltersBabies : UIViewController {
    UINavigationBar *navBar;
}

@property (nonatomic, strong) UINavigationBar *navBar;

-(IBAction)backToMainView:(id)sender;

@end
