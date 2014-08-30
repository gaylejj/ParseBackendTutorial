//
//  JKELoginViewController.m
//  NoteApp
//
//  Created by Jeff Gayle on 8/29/14.
//  Copyright (c) 2014 Joyce Echessa. All rights reserved.
//

#import "JKELoginViewController.h"
#import <Parse/Parse.h>

@interface JKELoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation JKELoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
}

- (IBAction)loginButtonPressed:(id)sender {
    
    NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (username.length == 0 || password.length == 0) {
        [self setupUsernamePasswordAlertController];
    } else {
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if (error) {
                [self setupErrorAlertController:error];
            } else {
                [self.navigationController popViewControllerAnimated:true];
            }
        }];
    }
    
}

-(void)setupUsernamePasswordAlertController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"You must enter a username and password" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)setupErrorAlertController:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:[error.userInfo objectForKey:@"error"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
