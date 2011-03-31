//
//  ItemDetailViewController.m
//  Homepwner
//
//  Created by Lisa Ridley on 3/28/11.
//  Copyright 2011 RoveWorks. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ImageCache.h"
#import "Possession.h"

@implementation ItemDetailViewController
@synthesize nameField;
@synthesize serialNumberField;
@synthesize valueField;
@synthesize dateLabel;
@synthesize editingPossession;
@synthesize imageView;
@synthesize clearImageButton;

- (id) init {
    [super initWithNibName:@"ItemDetailViewController" bundle:nil];
    
    UIBarButtonItem *cameraBarButtonItem = [[UIBarButtonItem alloc]
               initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                    target:self
                                    action:@selector(takePicture:)];
    [[self navigationItem] setRightBarButtonItem:cameraBarButtonItem];
    [cameraBarButtonItem release];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [nameField release];
    [serialNumberField release];
    [valueField release];
    [dateLabel release];
    [editingPossession release];
    [imageView release];
    [clearImageButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    // Do any additional setup after loading the view from its nib.
    if(self.imageView == nil) {
        self.clearImageButton.enabled = NO;
    } else {
        self.clearImageButton.enabled = YES;
    }
}

- (void)viewDidUnload
{

    self.nameField = nil;
    self.serialNumberField = nil;
    self.valueField = nil;
    self.dateLabel = nil;
    self.editingPossession = nil;
    [self setImageView:nil];
    [self setClearImageButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.nameField.text = self.editingPossession.possessionName;
    self.serialNumberField.text = self.editingPossession.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d",self.editingPossession.valueInDollars];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateLabel setText:[dateFormatter stringFromDate:self.editingPossession.dateCreated]];
    [[self navigationItem] setTitle:self.editingPossession.possessionName];
    
    NSString *imageKey = [self.editingPossession imageKey];
    if (imageKey) {
        UIImage *imageToDisplay = [[ImageCache sharedImageCache] imageForKey:imageKey];
        [imageView setImage:imageToDisplay];
    } else {
        [imageView setImage:nil];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.nameField resignFirstResponder];
    [self.serialNumberField resignFirstResponder];
    [self.valueField resignFirstResponder];
    
    self.editingPossession.possessionName = self.nameField.text;
    self.editingPossession.serialNumber = self.serialNumberField.text;
    [self.editingPossession setValueInDollars:[self.valueField.text intValue]];
    
    
}

- (IBAction)clearItemPicture:(id)sender {
    NSString *oldKey = [self.editingPossession imageKey];
    if(oldKey) {
        [self.editingPossession setImageKey:@""];
        self.imageView.image = nil;
        self.clearImageButton.enabled = NO;
    }
}

- (IBAction)editingFieldComplete:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [nameField resignFirstResponder];
    [serialNumberField resignFirstResponder];
    [valueField resignFirstResponder];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *oldKey = [self.editingPossession imageKey];
    
    //check to see if an image exists already
    if(oldKey) {
        //delete the old image
        [[ImageCache sharedImageCache] deleteImageForKey:oldKey];
    }
    
    UIImage *origimage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"image width: %f; image height: %f", 
          origimage.size.width, origimage.size.height);
    //create empty image 180px square
    CGRect imageRect = CGRectMake(0,0,134,180);
    UIGraphicsBeginImageContext(imageRect.size);
    
    //get original image and render in the current image context
    [origimage drawInRect:imageRect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [image retain];
    UIGraphicsEndImageContext();
    NSLog(@"image width: %f; image height: %f", 
          image.size.width, image.size.height);
    
    //create a unique identifier (CFUUID)
    CFUUIDRef newUniqueID = CFUUIDCreate (kCFAllocatorDefault);
    
    //create a string from newUniqueID
    CFStringRef newUniqueIDString = CFUUIDCreateString (kCFAllocatorDefault, newUniqueID);
    
    //use newUniqueIDString to set possessions image key
    [self.editingPossession setImageKey:(NSString *)newUniqueIDString];
    
    //release CF objects
    CFRelease(newUniqueID);
    CFRelease(newUniqueIDString);
    
    //store in ImageCache with this key
    [[ImageCache sharedImageCache] setImage:image forKey:[self.editingPossession imageKey]];
    
    self.imageView.image = image;
    
    [self.editingPossession setThumbnailDataFromImage:image];
    [image release];
    self.clearImageButton.enabled = YES;
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Selector

- (void)takePicture:(id)sender {
    
    [[self view] endEditing:YES];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
}
@end
