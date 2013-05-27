//
//  BSCMainViewController.m
//  BaasdaySampleChat
//
//  Created by Yuu Shimizu on 5/28/13.
//  Copyright (c) 2013 Nyampass. All rights reserved.
//

#import "BSCMainViewController.h"
#import <baasday/baasday.h>

@interface BSCMainViewController ()

@end

@implementation BSCMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		_messages = [NSMutableArray array];
		_lastMessage = nil;
    }
    return self;
}

- (id)init {
	return [self initWithNibName:@"BSCMainViewController" bundle:nil];
}

- (void)receivedMessages:(NSArray *)messages {
	if (messages && messages.count > 0) {
		for (id message in messages.reverseObjectEnumerator) {
			[_messages insertObject:message atIndex:0];
		}
		[_messageList reloadData];
		_lastMessage = messages[0];
	}
	BDQuery *query = [[BDQuery alloc] init];
	query.order = @[[[BDFieldOrder alloc] initWithField:@"_createdAt" reversed:YES]];
	if (_lastMessage) query.filter = @{@"_createdAt": @{@"$gt": [_lastMessage objectForKey:@"_createdAt"]}};
	query.wait = 30;
	[BDObject fetchAllInBackgroundWithCollectionName:@"messages" query:query block:^(BDListResult *result, NSError *error) {
		[self receivedMessages:result ? result.contents : nil];
	}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	BDQuery *query = [[BDQuery alloc] init];
	query.order = @[[[BDFieldOrder alloc] initWithField:@"_createdAt" reversed:YES]];
	[BDObject fetchAllInBackgroundWithCollectionName:@"messages" query:query block:^(BDListResult *result, NSError *error) {
		[self receivedMessages:result ? result.contents : nil];
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	BDObject *message = _messages[indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@", [message objectForKey:@"body"]];
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)sendMessage:(id)sender {
	UITextField *textField = sender;
	NSString *messageBody = textField.text;
	if (messageBody.length > 0) {
		[BDObject createInBackgroundWithCollectionName:@"messages" values:@{@"body": messageBody} block:^(BDObject *object, NSError *error) {
		}];
	}
	textField.text = @"";
}

@end
