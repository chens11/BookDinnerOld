//
//  BDPersonDetailViewController.m
//  BookDinner
//
//  Created by zqchen on 22/8/14.
//  Copyright (c) 2014 chenzq. All rights reserved.
//

#import "BDPersonDetailViewController.h"
#import "HNYDetailTableViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"

@interface BDPersonDetailViewController ()<UITextFieldDelegate,HNYDetailTableViewControllerDelegate,HNYPopoverViewDelegate,ELCImagePickerControllerDelegate,ELCAssetSelectionDelegate>
@property (nonatomic,strong) UITextField *sexTextField;
@property (nonatomic,strong) UITextField *newpPasswordField;
@property (nonatomic,strong) UITextField *passwordConformField;
@property (nonatomic,strong) NSMutableArray *viewAry;
@property (nonatomic,strong) NSArray *sexAry;
@property (nonatomic,strong) HNYDetailTableViewController *tableViewController;
@property (nonatomic,strong) ALAssetsLibrary *specialLibrary;
@property (nonatomic,assign) BOOL imgChange;
@property (nonatomic, copy) NSArray *chosenImages;

@end

@implementation BDPersonDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imgChange = NO;
        _viewAry = [[NSMutableArray alloc] initWithCapacity:0];
        self.sexAry = [NSArray arrayWithObjects:@"保密",@"男",@"女", nil];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人信息";
    [self createTable];
    [self setContent];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createTable{
    self.tableViewController = [[HNYDetailTableViewController alloc] init];
    self.tableViewController.delegate = self;
    self.tableViewController.customDelegate = self;
    self.tableViewController.nameLabelWidth = 60;
    self.tableViewController.nameTextAlignment = NSTextAlignmentLeft;
    self.tableViewController.cellHeight = 50;
    self.tableViewController.cellBackGroundColor = [UIColor whiteColor];
    [self addChildViewController:self.tableViewController];
    self.tableViewController.view.frame = CGRectMake(0, self.naviBar.frame.size.height, self.view.frame.size.width, self.tableViewController.cellHeight * 6);
    [self.tableViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
    [self.view addSubview:self.tableViewController.view];
    [self addChildViewController:self.tableViewController];

}
- (void)setContent{
    
    HNYDetailItemModel *imgItem = [[HNYDetailItemModel alloc] init];
    imgItem.viewType = Customer;
    imgItem.key = KUSER_IMG;
    imgItem.contentMode = UIViewContentModeScaleAspectFit;
    imgItem.height = @"two";
    imgItem.value = [UIImage imageNamed:@"AppIcon11"];
    if ([self.personModel.userimage isKindOfClass:[UIImage class]]){
        imgItem.value = self.personModel.userimage;
    }
    else if ([self.personModel.userimage isKindOfClass:[NSString class]] && self.personModel.userimage.length > 10){
        NSURL *url = [NSURL URLWithString:self.personModel.userimage];
        imgItem.value = url;
    }
    
    [self.viewAry addObject:imgItem];
    
    HNYDetailItemModel *accountItem = [[HNYDetailItemModel alloc] init];
    accountItem.viewType = TextField;
    accountItem.editable = NO;
    accountItem.key = KUSER_ACCOUNT;
    accountItem.textValue = self.personModel.account;
    accountItem.rightPadding = 10;
    accountItem.textColor = [UIColor lightGrayColor];
    accountItem.name = @"  账号";
    accountItem.height = @"one";
    [_viewAry addObject:accountItem];
    
    HNYDetailItemModel *nameItem = [[HNYDetailItemModel alloc] init];
    nameItem.viewType = TextField;
    nameItem.editable = YES;
    nameItem.textValue = self.personModel.username;
    nameItem.value = self.personModel.username;
    nameItem.name = @"  昵称";
    nameItem.key = KUSER_NAME;
    nameItem.height = @"one";
    [_viewAry addObject:nameItem];
    
    HNYDetailItemModel *sexItem = [[HNYDetailItemModel alloc] init];
    sexItem.viewType = Customer;
    sexItem.editable = YES;
    sexItem.height = @"one";
    if (self.personModel.sex < 3)
        sexItem.textValue = [self.sexAry objectAtIndex:self.personModel.sex];;
    sexItem.value = [NSNumber numberWithInt:self.personModel.sex];
    sexItem.key = KUSER_SEX;
    sexItem.name = @"  性别";
    [_viewAry addObject:sexItem];
    
    HNYDetailItemModel *buttonItem = [[HNYDetailItemModel alloc] init];
    buttonItem.viewType = Customer;
    buttonItem.height = @"one";
    buttonItem.key = @"button";
    [_viewAry addObject:buttonItem];
    
    self.tableViewController.viewAry = _viewAry;
    [self.tableViewController.tableView reloadData];
}
#pragma mark - HNYDetailTableViewControllerDelegate
- (id)createViewWith:(HNYDetailItemModel *)item{
    if ([KUSER_SEX isEqualToString:item.key]) {
        UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - self.tableViewController.nameLabelWidth, self.tableViewController.cellHeight)];
        
        self.sexTextField = [[HNYTextField alloc] initWithFrame:CGRectMake(0, self.tableViewController.cellHeight/2 - 10 , numView.frame.size.width, 20)];
        self.sexTextField.backgroundColor = [UIColor clearColor];
        self.sexTextField.textAlignment = NSTextAlignmentLeft;
        self.sexTextField.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.sexTextField.text = item.textValue;
        self.sexTextField.delegate = self;
        self.sexTextField.backgroundColor = [UIColor clearColor];
        [numView addSubview:self.sexTextField];
        
        return numView;
    }
    else if ([KUSER_IMG isEqualToString:item.key]) {
        UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.tableViewController.cellHeight * 2)];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.tableViewController.cellHeight * 2 - 16, self.tableViewController.cellHeight * 2)];
        imgView.center = CGPointMake(numView.frame.size.width/2, numView.frame.size.height/2);
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        if ([item.value isKindOfClass:[UIImage class]])
            [imgView setImage:item.value];
        else if ([item.value isKindOfClass:[NSURL class]])
            [imgView setImageWithURL:item.value];
        [numView addSubview:imgView];
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = imgView.frame;
        [addBtn addTarget:self action:@selector(touchAddButton:) forControlEvents:UIControlEventTouchUpInside];
        [numView addSubview:addBtn];
        
        return numView;
    }
    else if ([@"button" isEqualToString:item.key]) {
        UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.tableViewController.cellHeight*2)];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(15, 5, self.view.frame.size.width - 30, 40);
        saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KFONT_SIZE_MAX_16];
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
        [saveBtn setTitle:@"保存个人信息" forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(touchSaveButton:) forControlEvents:UIControlEventTouchUpInside];
        [temp addSubview:saveBtn];
        
        return temp;
    }
    return [[UIView alloc] init];
}
#pragma mark - IBAction
- (void)touchSaveButton:(UIButton*)sender{
    [self.view endEditing:YES];
    HNYDetailItemModel *nameItem = [self.tableViewController getItemWithKey:KUSER_NAME];

    if (nameItem.value == nil) {
        [self showTips:@"昵称不能为空"];
        return;
    }
    
    [self savePersonInfo];

}

#pragma mark - http request

- (void)savePersonInfo{
    [self showRequestingTips:@"正在保存..."];
    HNYDetailItemModel *sexItem = [self.tableViewController getItemWithKey:KUSER_SEX];
    HNYDetailItemModel *nameItem = [self.tableViewController getItemWithKey:KUSER_NAME];
    HNYDetailItemModel *imgItem = [self.tableViewController getItemWithKey:KUSER_IMG];
    
    

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  sexItem.value,KUSER_SEX,
                                  nameItem.value,KUSER_NAME,
                                  [AppInfo headInfo],HTTP_HEAD,nil];
    
    if (self.imgChange && [imgItem.value isKindOfClass:[UIImage class]])
    {
        NSData *imageData = UIImagePNGRepresentation(imgItem.value);
        NSString *string = [imageData base64EncodedString];
        [param setValue:string forKey:KUSER_IMG];
        [param setValue:@"png" forKey:KUSER_IMG_TYPE];
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",KAPI_ServerUrl,KAPI_ActionSavePersonInfo];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url = %@ \n param = %@",urlString,param);
    
    NSString *jsonString = [param JSONRepresentation];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
    formRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:KAPI_ActionSavePersonInfo,HTTP_USER_INFO, nil];
    [formRequest appendPostData:data];
    [formRequest setDelegate:self];
    [formRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSString *string =[[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [string JSONValue];
    NSLog(@"result = %@",dictionary);
    [self.hud removeFromSuperview];

    if ([[dictionary objectForKey:HTTP_RESULT] intValue] == 1) {
        if ([KAPI_ActionGetPersonInfo isEqualToString:[request.userInfo objectForKey:HTTP_USER_INFO]]) {
            NSDictionary *value = [dictionary valueForKey:HTTP_VALUE];
            if ([value isKindOfClass:[NSDictionary class]]) {
                HNYDetailItemModel *sexItem = [self.tableViewController getItemWithKey:KUSER_SEX];
                HNYDetailItemModel *nameItem = [self.tableViewController getItemWithKey:KUSER_NAME];
                HNYDetailItemModel *imgItem = [self.tableViewController getItemWithKey:KUSER_IMG];

                nameItem.textValue = [value valueForKey:KUSER_NAME];
                nameItem.value = [value valueForKey:KUSER_NAME];
                if ([[value valueForKey:KUSER_SEX] intValue] < 3) {
                    sexItem.textValue = [self.sexAry objectAtIndex:[[value valueForKey:KUSER_SEX] intValue]];;
                }
                sexItem.value = [value valueForKey:KUSER_SEX];
                NSString *uslStr = [value valueForKey:KUSER_IMG];
                NSURL *url = [NSURL URLWithString:uslStr];
                imgItem.value = url;
                
                [self.tableViewController changeViewAryObjectWith:sexItem atIndex:[self.viewAry indexOfObject:sexItem]];
                [self.tableViewController changeViewAryObjectWith:nameItem atIndex:[self.viewAry indexOfObject:nameItem]];
                [self.tableViewController changeViewAryObjectWith:imgItem atIndex:[self.viewAry indexOfObject:imgItem]];
            }
            
        }
        else if ([KAPI_ActionSavePersonInfo isEqualToString:[request.userInfo objectForKey:HTTP_USER_INFO]]){
            [self showTips:[dictionary valueForKey:HTTP_INFO]];
            HNYDetailItemModel *sexItem = [self.tableViewController getItemWithKey:KUSER_SEX];
            HNYDetailItemModel *nameItem = [self.tableViewController getItemWithKey:KUSER_NAME];
            
            self.personModel.sex = [sexItem.value intValue];
            self.personModel.username = nameItem.value;
            [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0];
        }
        else if ([KAPI_ActionSavePersonImg isEqualToString:[request.userInfo objectForKey:HTTP_USER_INFO]]){
            [self showTips:[dictionary valueForKey:HTTP_INFO]];
            HNYDetailItemModel *imgItem = [self.tableViewController getItemWithKey:KUSER_IMG];
            self.personModel.userimage = imgItem.value;
        }
    }
    else{
        if ([KAPI_ActionGetPersonInfo isEqualToString:[request.userInfo objectForKey:HTTP_USER_INFO]]) {
            [self showTips:[dictionary valueForKey:HTTP_INFO]];
        }
        else if ([KAPI_ActionSavePersonInfo isEqualToString:[request.userInfo objectForKey:HTTP_USER_INFO]]){
            [self showTips:[dictionary valueForKey:HTTP_INFO]];
        }
        else if ([KAPI_ActionSavePersonImg isEqualToString:[request.userInfo objectForKey:HTTP_USER_INFO]]){
            [self showTips:[dictionary valueForKey:HTTP_INFO]];
        }
    }
}
- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [HNYPopoverView presentPopoverFromRect:textField.frame inView:textField.superview withTitle:nil withStringAry:self.sexAry delegate:self];
    return NO;
}

#pragma mark - HNYPopoverViewDelegate
// caled when select the String ary
- (void)hNYPopoverView:(HNYPopoverView *)popover didSelectStringAryAtIndex:(NSInteger)index{
    HNYDetailItemModel *item = [self.tableViewController getItemWithKey:KUSER_SEX];
    item.textValue = [self.sexAry objectAtIndex:index];
    item.value = [NSString stringWithFormat:@"%ld",(long)index];
    self.sexTextField.text = item.textValue;
    [popover dismissPopoverAnimated:YES];
}

- (IBAction)launchController{
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = 1;
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
	elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (IBAction)touchAddButton:(UIButton*)sender{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    self.specialLibrary = library;
    NSMutableArray *groups = [NSMutableArray array];
    [_specialLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group)
            [groups addObject:group];
        else
            // this is the end
            [self displayPickerForGroup:[groups objectAtIndex:0]];
    } failureBlock:^(NSError *error) {
        self.chosenImages = nil;
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"A problem occured %@", [error description]);
        // an error here means that the asset groups were inaccessable.
        // Maybe the user or system preferences refused access.
    }];
}

- (void)displayPickerForGroup:(ALAssetsGroup *)group
{
	ELCAssetTablePicker *tablePicker = [[ELCAssetTablePicker alloc] initWithStyle:UITableViewStylePlain];
    tablePicker.singleSelection = YES;
    tablePicker.immediateReturn = NO;
    
	ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:tablePicker];
    elcPicker.maximumImagesCount = 1;
    elcPicker.imagePickerDelegate = self;
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
	tablePicker.parent = elcPicker;
    
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
	
    self.imgChange = NO;
	for (NSDictionary *dict in info) {
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        self.imgChange = YES;
        HNYDetailItemModel *imgItem = [self.tableViewController getItemWithKey:KUSER_IMG];
        imgItem.value = image;
        [self.tableViewController changeViewAryObjectWith:imgItem atIndex:[self.viewAry indexOfObject:imgItem]];
        break;
	}
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
