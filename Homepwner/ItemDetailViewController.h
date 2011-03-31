//
//  ItemDetailViewController.h
//  Homepwner
//
//  Created by Lisa Ridley on 3/28/11.
//  Copyright 2011 RoveWorks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageCache;
@class Possession;

@interface ItemDetailViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    
    UITextField *nameField;
    UITextField *serialNumberField;
    UITextField *valueField;
    UILabel *dateLabel;
    
    Possession *editingPossession;
    UIImageView *imageView;
    UIButton *clearImageButton;
}
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *serialNumberField;
@property (nonatomic, retain) IBOutlet UITextField *valueField;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, assign) Possession *editingPossession;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *clearImageButton;
- (IBAction)clearItemPicture:(id)sender;
- (IBAction)editingFieldComplete:(id)sender;
- (IBAction)backgroundTap:(id)sender;


@end
