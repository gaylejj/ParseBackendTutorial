//
//  JKENotesListViewController.m
//  NoteApp
//
//  Created by Jeff Gayle on 8/29/14.
//  Copyright (c) 2014 Joyce Echessa. All rights reserved.
//

#import "JKENotesListViewController.h"
#import "JKENotesViewController.h"
//#import <Parse/Parse.h>

@interface JKENotesListViewController ()

@end

@implementation JKENotesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current User %@", currentUser.username);
    } else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadObjects];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithClassName:@"Post"];
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        //Class name to query on
        self.parseClassName = @"Post";
        
        //Whether built-in pull to refresh enabled
        self.pullToRefreshEnabled = YES;
        
        //Whether Pagination available
        self.paginationEnabled = YES;
        
        //Number of objects to show per page
        self.objectsPerPage = 15;
    }
    
    return self;
}

#pragma mark PFQueryTableViewController Data Source
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *cellIdentifier = @"Cell";
    
    PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[PFTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
    NSDate *date = [object createdAt];
    
    cell.textLabel.text = [object objectForKey:@"Title"];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:date];
    cell.imageView.image = [UIImage imageNamed:@"note"];
    
    return cell;
}

-(PFQuery *)queryForTable {
    //Create a query
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    //Follow Relationship
    if ([PFUser currentUser]) {
        [query whereKey:@"author" equalTo:[PFUser currentUser]];
    } else {
        [query whereKey:@"nonexistent" equalTo:@"doesn't exist"];
    }
    return query;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showNote"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        JKENotesViewController *note = (JKENotesViewController *)segue.destinationViewController;
        note.note = object;
    }
}

- (IBAction)logoutButtonPressed:(id)sender {
    
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
