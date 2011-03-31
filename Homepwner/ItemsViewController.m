//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Lisa Ridley on 3/28/11.
//  Copyright 2011 RoveWorks. All rights reserved.
//

#import "ItemsViewController.h"
#import "Possession.h"
#import "ItemDetailViewController.h"
#import "HomepwnerItemCell.h"

@implementation ItemsViewController

@synthesize possessions;

#pragma mark -
#pragma mark Initialization methods

- (id) init {
    [super initWithStyle:UITableViewStyleGrouped];
    
    [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    [[self navigationItem] setTitle:@"Homepwner"];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(presentInputView)];
    [[self navigationItem] setRightBarButtonItem:addButton];
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark Memory Management
- (void)dealloc {
    self.possessions = nil;
    [possessions release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    NSLog(@"Calling ItemsViewController::didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
#pragma mark -
#pragma mark UITableViewDataSource protocol methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    int numberOfRows = [possessions count];
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomepwnerItemCell *cell = (HomepwnerItemCell *)[tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    if(!cell) {
        cell = [[[HomepwnerItemCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"HomepwnerItemCell"] autorelease];
    }
    Possession *p = [possessions objectAtIndex:[indexPath row]];
    [cell setPossession:p];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [possessions removeObjectAtIndex:[indexPath row]];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        [possessions addObject:[Possession randomPossession]];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    //object being moved
    Possession *p = [possessions objectAtIndex:[sourceIndexPath row]];
    
    //increase retain count so array does not get dealloced when object is removed
    [p retain];
    
    //remove object from array
    [possessions removeObjectAtIndex:[sourceIndexPath row]];
    
    //insert object at new position
    [possessions insertObject:p atIndex:[destinationIndexPath row]];
    
    //decrease retain count by 1
    [p release];
}


- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] < [possessions count]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -
#pragma mark Table View cell methods
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    //always call first
    [super setEditing:editing animated:animated];
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
        return UITableViewCellEditingStyleDelete;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if([proposedDestinationIndexPath row] < [possessions count]) {
        return proposedDestinationIndexPath;
    } else {
        NSIndexPath *betterIndexPath = [NSIndexPath indexPathForRow:[possessions count] - 1 inSection:0];
        return betterIndexPath;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!detailViewController) {
        detailViewController = [[ItemDetailViewController alloc] init];
    }
    
    detailViewController.editingPossession = [possessions objectAtIndex:indexPath.row];
    
    [[self navigationController] pushViewController:detailViewController 
                                           animated:YES];
}

#pragma mark -
#pragma mark UIView methods
- (UIView *)headerView {
    if(!headerView) {
        UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
        float w = [[UIScreen mainScreen] bounds].size.width;
                   
        CGRect editButtonFrame = CGRectMake(8.0, 8.0, w - 16.0, 30.0);
        [editButton setFrame:editButtonFrame];
        
        [editButton addTarget:self 
                       action:@selector(editingButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        
        CGRect headerViewFrame = CGRectMake(0,0,w,48);
        headerView = [[UIView alloc] initWithFrame:headerViewFrame];
        
        [headerView addSubview:editButton];
    }
    return headerView;
}

#pragma mark headerView selector method
- (void) editingButtonPressed:(id)sender {
    if([self isEditing]) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}
- (void) presentInputView {
    if(!detailViewController) {
        detailViewController = [[ItemDetailViewController alloc] init];
    }
    [possessions addObject:[Possession randomPossession]];
        

    detailViewController.editingPossession = [possessions objectAtIndex:[possessions count] - 1];
    
    [[self navigationController] pushViewController:detailViewController 
                                           animated:YES];
}
@end
