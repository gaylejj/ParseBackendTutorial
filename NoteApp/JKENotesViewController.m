//
//  JKENotesViewController.m
//  NoteApp
//
//  Created by Jeff Gayle on 8/29/14.
//  Copyright (c) 2014 Joyce Echessa. All rights reserved.
//

#import "JKENotesViewController.h"

@interface JKENotesViewController ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end

@implementation JKENotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.note != nil) {
        self.titleTextField.text = [self.note objectForKey:@"Title"];
        self.contentTextView.text = [self.note objectForKey:@"Content"];
    }
    
    // Do any additional setup after loading the view.
}
- (IBAction)saveWasPressed:(id)sender {
    NSString *title = [self.titleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (title.length == 0) {
        UIAlertController *alertContrller = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Your must enter a title" preferredStyle:UIAlertControllerStyleAlert];
        [alertContrller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.adjustsFontSizeToFitWidth = true;
            textField.placeholder = @"Place Title here";
        }];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self saveNote];
            [self dismissViewControllerAnimated:true completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alertContrller addAction:saveAction];
        [alertContrller addAction:cancelAction];
        [self presentViewController:alertContrller animated:true completion:nil];
    } else {
        if (self.note != nil) {
            [self updateNote];
        } else {
            [self saveNote];
        }
    }
}

-(void)saveNote {
    PFObject *newNote = [PFObject objectWithClassName:@"Post"];
    newNote[@"Title"] = self.titleTextField.text;
    newNote[@"Content"] = self.contentTextView.text;
    newNote[@"author"] = [PFUser currentUser];
    
    [newNote saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self createAlertController:error];
        }
    }];
}

-(void)updateNote {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    
    [query getObjectInBackgroundWithId:[self.note objectId] block:^(PFObject *oldNote, NSError *error) {
        if (error) {
            [self createAlertController:error];
        } else {
            oldNote[@"Title"] = self.titleTextField.text;
            oldNote[@"Content"] = self.contentTextView.text;
            
            [oldNote saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self.navigationController popViewControllerAnimated:true];
                } else {
                    [self createAlertController:error];
                }
            }];
        }
    }];
}

-(void)createAlertController:(NSError *)error {
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
