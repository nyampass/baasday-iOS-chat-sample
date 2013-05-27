//
//  BSCMainViewController.h
//  BaasdaySampleChat
//
//  Created by Yuu Shimizu on 5/28/13.
//  Copyright (c) 2013 Nyampass. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <baasday/baasday.h>

@interface BSCMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	NSMutableArray *_messages;
	BDObject *_lastMessage;
	IBOutlet UITableView *_messageList;
}

- (IBAction)sendMessage:(id)sender;

@end
