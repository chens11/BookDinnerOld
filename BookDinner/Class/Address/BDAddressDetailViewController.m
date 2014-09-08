//
//  BDAddressDetailViewController.m
//  BookDinner
//
//  Created by zqchen on 14/7/14.
//  Copyright (c) 2014 chenzq. All rights reserved.
//

#import "BDAddressDetailViewController.h"
#import "HNYDetailTableViewController.h"
#import "BDAddressSelectorViewController.h"

@interface BDAddressDetailViewController ()<HNYDetailTableViewControllerDelegate,HNYDelegate>
@property (nonatomic,strong) NSMutableArray *viewAry;
@property (nonatomic,strong) HNYDetailTableViewController *tableViewController;

@end

@implementation BDAddressDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isDefault = NO;
        _viewAry = [[NSMutableArray alloc] initWithCapacity:0];
        self.addressModel = [[BDAddressModel alloc] init];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"编辑地址";
    
    [self createTableView];
    [self setContent];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - create subview
- (void)createTableView{
    self.tableViewController = [[HNYDetailTableViewController alloc] init];
    self.tableViewController.delegate = self;
    self.tableViewController.customDelegate = self;
    self.tableViewController.nameLabelWidth = 60;
    self.tableViewController.nameTextAlignment = UITextAlignmentLeft;
    self.tableViewController.cellHeight = 50;
    self.tableViewController.cellBackGroundColor = [UIColor whiteColor];
    [self addChildViewController:self.tableViewController];
    self.tableViewController.view.frame = CGRectMake(0, self.naviBar.frame.size.height, self.view.frame.size.width, self.tableViewController.cellHeight * 7 +10);
    [self.tableViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth)];
    [self.view addSubview:self.tableViewController.view];
    [self addChildViewController:self.tableViewController];
}
- (void)setContent{
    
    HNYDetailItemModel *nameItem = [[HNYDetailItemModel alloc] init];
    nameItem.viewType = TextField;
    nameItem.editable = YES;
    nameItem.key = USER_NAME;
    nameItem.textValue = self.addressModel.name;
    nameItem.value = self.addressModel.name;
    nameItem.rightPadding = 10;
    nameItem.name = @"  称呼 ";
    nameItem.height = @"one";
    [_viewAry addObject:nameItem];
    
    HNYDetailItemModel *numItem = [[HNYDetailItemModel alloc] init];
    numItem.viewType = TextField;
    numItem.editable = YES;
    numItem.textValue = self.addressModel.tel;
    numItem.value = self.addressModel.tel;
    numItem.keyboardType = UIKeyboardTypeNumberPad;
    numItem.name = @"  手机 ";
    numItem.key = USER_PHONE_NUM;
    numItem.height = @"one";
    [_viewAry addObject:numItem];
    
    HNYDetailItemModel *codeItem = [[HNYDetailItemModel alloc] init];
    codeItem.viewType = Label;
    codeItem.editable = YES;
    codeItem.height = @"one";
    codeItem.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.addressModel.prorince.name && self.addressModel.city.name && self.addressModel.district.name)
        codeItem.textValue = [NSString stringWithFormat:@"%@ %@ %@",
                              self.addressModel.prorince.name,
                              self.addressModel.city.name,
                              self.addressModel.district.name];
    codeItem.value = self.addressModel;
    codeItem.key = USER_ADDRESS_CODE;
    codeItem.name = @"  地区";
    [_viewAry addObject:codeItem];
    
    HNYDetailItemModel *streetItem = [[HNYDetailItemModel alloc] init];
    streetItem.viewType = Label;
    streetItem.editable = YES;
    streetItem.height = @"one";
    streetItem.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.addressModel.street.name)
        streetItem.textValue = [NSString stringWithFormat:@"%@",self.addressModel.street.name];
    streetItem.value = self.addressModel;
    streetItem.key = USER_ADDRESS_STREET;
    streetItem.name = @"  街道";
    [_viewAry addObject:streetItem];
    
    HNYDetailItemModel *addreItem = [[HNYDetailItemModel alloc] init];
    addreItem.viewType = TextView;
    addreItem.editable = YES;
    addreItem.height = @"auto";
    addreItem.maxheight = 60;
    addreItem.minheight = 60;
    addreItem.textValue = self.addressModel.address;
    addreItem.value = self.addressModel.address;
    addreItem.key = USER_ADDRESS;
    addreItem.name = @"  地址";
    [_viewAry addObject:addreItem];

    HNYDetailItemModel *buttonItem = [[HNYDetailItemModel alloc] init];
    buttonItem.viewType = Customer;
    buttonItem.height = @"two";
    buttonItem.key = @"button";
    [_viewAry addObject:buttonItem];
    
    self.tableViewController.viewAry = _viewAry;
    [self.tableViewController.tableView reloadData];
}

- (void)createNaviBarItems{
    [super createNaviBarItems];
    if (!self.isAddAddress) {
        HNYNaviBarItem *barItem = [HNYNaviBarItem initWithTitle:@"删除" target:self action:@selector(touchDeleteBarItem:)];
        self.naviBar.rightItems = [NSArray arrayWithObjects:barItem, nil];
    }

}

#pragma mark - HNYDetailTableViewControllerDelegate

- (id)createViewWith:(HNYDetailItemModel *)item{
    if ([@"button" isEqualToString:item.key]) {
        UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.tableViewController.cellHeight*2)];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(15, 5 , self.view.frame.size.width - 30, 40);
        saveBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        saveBtn.titleLabel.font = ButtonTitleFont;
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(touchSaveAddressButton:) forControlEvents:UIControlEventTouchUpInside];
        [temp addSubview:saveBtn];
        
        
        UIButton *defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        defaultBtn.frame = CGRectMake(15, 50 , self.view.frame.size.width - 30, 40);
        defaultBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        defaultBtn.titleLabel.font = ButtonTitleFont;
        [defaultBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
        [defaultBtn setTitle:@"设为默认地址" forState:UIControlStateNormal];
        [defaultBtn addTarget:self action:@selector(touchDefaultAddressButton:) forControlEvents:UIControlEventTouchUpInside];
        [temp addSubview:defaultBtn];
        return temp;
    }
    return [[UIView alloc] init];
}

- (void)tableViewController:(HNYDetailTableViewController *)tableViewController didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HNYDetailItemModel *item = [self.tableViewController.viewAry objectAtIndex:indexPath.row];
    if ([item.key isEqualToString:USER_ADDRESS_CODE]) {
        BDAddressSelectorViewController *controller = [[BDAddressSelectorViewController alloc] init];
        controller.title = @"请选择地区";
        controller.delegate = self;
        controller.addressModel = self.addressModel;
        controller.customNaviController = self.customNaviController;
        [self.customNaviController pushViewController:controller animated:YES];
    }
    else if ([item.key isEqualToString:USER_ADDRESS_STREET]) {
        BDAddressSelectorViewController *controller = [[BDAddressSelectorViewController alloc] init];
        controller.title = @"请选择街道";
        controller.delegate = self;
        controller.getStreet = YES;
        controller.addressModel = self.addressModel;
        controller.customNaviController = self.customNaviController;
        [self.customNaviController pushViewController:controller animated:YES];
    }
    
}

#pragma mark - IBAction
- (void)touchSaveAddressButton:(UIButton*)sender{
    HNYDetailItemModel *nameItem = [self.tableViewController getItemWithKey:USER_NAME];
    HNYDetailItemModel *phoneItem = [self.tableViewController getItemWithKey:USER_PHONE_NUM];
    HNYDetailItemModel *codeItem = [self.tableViewController getItemWithKey:USER_ADDRESS_CODE];
    HNYDetailItemModel *addItem = [self.tableViewController getItemWithKey:USER_ADDRESS];
    if (!nameItem.value) {
        [self showTips:@"请您输入名称"];
        return;
    }
    
    if (!phoneItem.value) {
        [self showTips:@"请您输入手机号码"];
        return;
    }
    
    if (!codeItem.value) {
        [self showTips:@"请您选择地区"];
        return;
    }
    if (!addItem.value) {
        [self showTips:@"请您输入详细地址"];
        return;
    }
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:nameItem.value forKey:@"name"];
    [dictionary setValue:phoneItem.value forKey:@"tel"];
    [dictionary setValue:[NSNumber numberWithInt:self.addressModel.prorince.code]
                  forKey:@"prorince"];
    [dictionary setValue:[NSNumber numberWithInt:self.addressModel.city.code]
                  forKey:@"city"];
    [dictionary setValue:[NSNumber numberWithInt:self.addressModel.district.code]
                  forKey:@"district"];
    [dictionary setValue:[NSNumber numberWithInt:self.addressModel.street.code]
                  forKey:@"street"];
    [dictionary setValue:[NSNumber numberWithBool:self.isDefault] forKey:@"isdefault"];
    [dictionary setValue:addItem.value forKey:@"address"];

    [dictionary setValue:[AppInfo headInfo] forKey:HTTP_HEAD];
    [dictionary setValue:[[NSUserDefaults standardUserDefaults] valueForKey:HTTP_TOKEN] forKey:HTTP_TOKEN];
    if (self.isAddAddress) {
        [self addAddress:dictionary];
    }
    else{
        [dictionary setValue:[NSNumber numberWithInt:self.addressModel.id] forKey:@"id"];
        [self saveAddress:dictionary];
    }
}
- (void)touchDefaultAddressButton:(UIButton*)sender{
    self.isDefault = YES;
    [self touchSaveAddressButton:nil];
}

- (void)touchDeleteBarItem:(id)sender{
    [PXAlertView showAlertWithTitle:@"确实是否删除改地址" message:nil cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled) {
        if (!cancelled) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            [dictionary setValue:[NSNumber numberWithInt:self.addressModel.id] forKey:@"id"];
            [dictionary setValue:[AppInfo headInfo] forKey:HTTP_HEAD];
            [dictionary setValue:[[NSUserDefaults standardUserDefaults] valueForKey:HTTP_TOKEN] forKey:HTTP_TOKEN];
            [self deleteAddress:dictionary];
        }
    }];
}

#pragma mark - HNYDelegate

- (void)viewController:(UIViewController *)vController actionWitnInfo:(NSDictionary *)info{
    if ([vController isKindOfClass:[BDAddressSelectorViewController class]]) {
        
        HNYDetailItemModel *nameItem = [self.tableViewController getItemWithKey:USER_ADDRESS_CODE];
        HNYDetailItemModel *streetItem = [self.tableViewController getItemWithKey:USER_ADDRESS_STREET];
        
        nameItem.textValue = [NSString stringWithFormat:@"%@ %@ %@",self.addressModel.prorince.name,self.addressModel.city.name,self.addressModel.district.name];
        nameItem.value = self.addressModel;
        
        if (self.addressModel.street.name) {
            streetItem.textValue = [NSString stringWithFormat:@"%@",self.addressModel.street.name];
            streetItem.value = self.addressModel;
            [self.tableViewController changeViewAryObjectWith:streetItem atIndex:[self.viewAry indexOfObject:streetItem]];
        }
        
        [self.tableViewController changeViewAryObjectWith:nameItem atIndex:[self.viewAry indexOfObject:nameItem]];

        
    }
}
#pragma mark - http request
- (void)deleteAddress:(NSDictionary*)params{
    [self.view endEditing:YES];
    [self showRequestingTips:nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ServerUrl,ActionDeleteAddress];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url = %@ \n param = %@",urlString,params);
    
    NSString *jsonString = [params JSONRepresentation];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
    formRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:ActionDeleteAddress,HTTP_USER_INFO, nil];
    [formRequest appendPostData:data];
    [formRequest setDelegate:self];
    [formRequest startAsynchronous];
}

- (void)saveAddress:(NSDictionary*)params{
    [self.view endEditing:YES];
    [self showRequestingTips:nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ServerUrl,ActionSaveAddress];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url = %@ \n param = %@",urlString,params);
    
    NSString *jsonString = [params JSONRepresentation];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
    formRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:ActionSaveAddress,HTTP_USER_INFO, nil];
    [formRequest appendPostData:data];
    [formRequest setDelegate:self];
    [formRequest startAsynchronous];
}
- (void)addAddress:(NSDictionary*)params{
    [self.view endEditing:YES];
    [self showRequestingTips:nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ServerUrl,ActionAddAddress];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"url = %@ \n param = %@",urlString,params);
    
    NSString *jsonString = [params JSONRepresentation];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    ASIFormDataRequest *formRequest = [ASIFormDataRequest requestWithURL:url];
    formRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:ActionAddAddress,HTTP_USER_INFO, nil];
    [formRequest appendPostData:data];
    [formRequest setDelegate:self];
    [formRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSString *string =[[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [string JSONValue];
    NSLog(@"result = %@",string);
    [self.hud removeFromSuperview];
    if ([[dictionary objectForKey:HTTP_RESULT] intValue] == 1) {
        if ([ActionSaveAddress isEqualToString:[request.userInfo objectForKey:HTTP_USER_INFO]]) {
            [self showTips:[dictionary valueForKey:HTTP_INFO]];
        }
        else if ([ActionAddAddress isEqualToString:[request.userInfo objectForKey:HTTP_USER_INFO]]) {
            self.isAddAddress = NO;
            [self showTips:[dictionary valueForKey:HTTP_INFO]];
        }
        else if ([ActionDeleteAddress isEqualToString:[request.userInfo objectForKey:HTTP_USER_INFO]]) {
            [self showTips:[dictionary valueForKey:HTTP_INFO]];
        }
        [self.delegate viewController:self actionWitnInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"RefreshTable",@"action", nil]];
        [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.0];

    }
    else{
        if ([ActionSaveAddress isEqualToString:[request.userInfo objectForKey:HTTP_USER_INFO]]) {
            [self showTips:[dictionary valueForKey:HTTP_INFO]];
        }
        else if ([ActionAddAddress isEqualToString:[request.userInfo objectForKey:HTTP_USER_INFO]]) {
            [self showTips:[dictionary valueForKey:HTTP_INFO]];
        }
    }
}

@end
