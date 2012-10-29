//
//  ResultsViewController.h
//  StressBuster
//
//  Created by Simon Tucker on 10/27/12.
//  Copyright (c) 2012 Simon Tucker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController{
    IBOutlet UILabel *scoreLabel;
}
@property (readwrite) NSInteger score;
@end
