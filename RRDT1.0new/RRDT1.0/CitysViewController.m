//
//  CitysViewController.m
//  RRDT1.0
//
//  Created by riverman on 15/12/10.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "CitysViewController.h"

@interface CitysViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableV;
@end

@implementation CitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableV.delegate = self;
    self.myTableV.dataSource = self;
    self.myTableV.tableFooterView = [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modeArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.modeArr[section][KCitys_regions]count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, WIDTH, 30)];
    customView.layer.borderWidth = 1;
    customView.layer.borderColor = UIColorFromRGB(0xdfdfdf).CGColor;
    customView.backgroundColor = UIColorFromRGB(0xf3f3f3);
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = UIColorFromRGB(0x333333);
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont systemFontOfSize:14];
    headerLabel.frame = CGRectMake(12, 0.0, WIDTH - 12, 30);

    headerLabel.text=self.modeArr[section][KCitys_sectionTitle];

    [customView addSubview:headerLabel];
    
    return customView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text=self.modeArr[indexPath.section][KCitys_regions][indexPath.row][cityName];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *cityInfo;
    cityInfo=self.modeArr[indexPath.section][KCitys_regions][indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kChooseCityNotif object:cityInfo];
    [self.navigationController popViewControllerAnimated:YES];
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
