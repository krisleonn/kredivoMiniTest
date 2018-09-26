//
//  LoginViewController.m
//  miniTest
//
//  Created by Kristian on 19/09/18.
//  Copyright © 2018 Kristian. All rights reserved.
//

#import "LoginViewController.h"
#import "QuoteViewController.h"

@interface LoginViewController ()<UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UILabel *nameAlertLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailAlertLabel;
@property (strong, nonatomic) IBOutlet UILabel *imageAlertLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameAlertHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *emailAlertHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageAlertHeightConstraint;
@property (strong, nonatomic) UIImage *dataPhotoImage;

@property (nonatomic) BOOL isPhotoInput;
@property (nonatomic) BOOL isNameInput;
@property (nonatomic) BOOL isEmailInput;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _isPhotoInput = NO;
    _isNameInput = NO;
    _isEmailInput = NO;
    self.profileImageView.layer.cornerRadius = 64.0f;
    self.profileImageView.clipsToBounds = YES;
    self.nameAlertLabel.text = @"";
    self.emailAlertLabel.text = @"";
    self.imageAlertLabel.text = @"";
    self.nameAlertHeightConstraint.constant = 0.0f;
    self.emailAlertHeightConstraint.constant = 0.0f;
    self.imageAlertHeightConstraint.constant = 0.0f;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loginButtonDidTapped:(id)sender{
 [self.view layoutIfNeeded];
 
    [UIView animateWithDuration:0.2f animations:^{
     
        
        self.nameAlertLabel.text = @"";
        self.emailAlertLabel.text = @"";
        self.imageAlertLabel.text = @"";
        self.nameAlertHeightConstraint.constant = 0.0f;
        self.emailAlertHeightConstraint.constant = 0.0f;
       self.imageAlertHeightConstraint.constant = 0.0f;
        
        if(!self.isPhotoInput){
            self.imageAlertLabel.text = @"Input your Image";
            self.imageAlertHeightConstraint.constant = 12.0f;
        }
        if([self.nameTextField.text isEqualToString:@""]){
            self.nameAlertLabel.text = @"Input your name";
            self.nameAlertHeightConstraint.constant = 12.0f;
            self.isNameInput = NO;
        }
        else {
           self.isNameInput = YES;
        }
        if([self.emailTextField.text isEqualToString:@""]){
            self.emailAlertLabel.text = @"Input your email";
            self.emailAlertHeightConstraint.constant = 12.0f;
            self.isEmailInput = NO;
        }
        else {
            if ([self.emailTextField.text rangeOfString:@"@"].location == NSNotFound || [self.emailTextField.text rangeOfString:@"."].location == NSNotFound) {
                //is not email
                self.emailAlertLabel.text = @"Input correct email";
                self.emailAlertHeightConstraint.constant = 12.0f;
                self.isEmailInput = NO;
            } else {
                //is email
                self.emailAlertLabel.text = @"";
                self.emailAlertHeightConstraint.constant = 0.0f;
                self.isEmailInput = YES;
            }
        }
         [self.view layoutIfNeeded];
  
    }];
   
    if(self.isPhotoInput && self.isEmailInput && self.isNameInput){
        NSLog(@"BERHASIL");
        [self.view endEditing:YES];
        QuoteViewController *quoteViewController = [[QuoteViewController alloc] init];
        [self.navigationController pushViewController:quoteViewController animated:YES];
    }
    
}

-(IBAction)pictureButtonDidTapped:(id)sender{
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:NSLocalizedString(@"Please Choose Image Source", @"")
                                message:NSLocalizedString(@"", @"")
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cameraButton = [UIAlertAction
                               actionWithTitle:@"Camera"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                   picker.delegate = self;
                                   picker.allowsEditing = NO;
                                   picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                   [self presentViewController:picker animated:YES completion:nil];

                               }];

    UIAlertAction* galleryButton = [UIAlertAction
                               actionWithTitle:@"Gallery"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   UIImagePickerController *pickerView = [[UIImagePickerController alloc] init];
                                   pickerView.allowsEditing = YES;
                                   pickerView.delegate = self;
                                   [pickerView setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                   [self presentViewController:pickerView animated:YES completion:nil];
                               }];
    
    [alert addAction:cameraButton];
    [alert addAction:galleryButton];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //Output image from Camera
    
    //Photo
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    
    if(chosenImage != nil) {
        self.dataPhotoImage = chosenImage;
        self.profileImageView.image = chosenImage;
        
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            //PhotoImageData
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                self.isPhotoInput = YES;
                self.imageAlertLabel.text = @"";
                self.imageAlertHeightConstraint.constant = 0.0f;
            });
        });
    }
    else {
        self.isPhotoInput = NO;
        self.imageAlertLabel.text = @"Input your Image";
        self.imageAlertHeightConstraint.constant = 12.0f;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


@end
