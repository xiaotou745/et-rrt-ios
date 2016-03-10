//
//  CitysViewController.m
//  RRDT1.0
//
//  Created by riverman on 15/12/10.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "CitysViewController.h"

@interface CitysViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    NSMutableArray *dateSortArray; //存储排序后的数据

}

@property (weak, nonatomic) IBOutlet UITableView *myTableV;
@end

@implementation CitysViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sortCityArray];
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
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        if (dateSortArray.count )
        {
            if(section>0)
            {
                
                NSString *title = [[ALPHA1 substringFromIndex:section] substringToIndex:1];
                NSLog(@"%@",title);
                return title;
            }
        }
        return @"";

}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *indices = [NSMutableArray array];
        if (dateSortArray.count>26) {
            for (int i = 0; i < 27; i++)
            {
                if ([[dateSortArray objectAtIndex:i] count])
                {
                    [indices addObject:[[ALPHA1 substringFromIndex:i] substringToIndex:1    ]];
                    
                }
            }
            
        }
    return indices;
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
#pragma  mark 对城市列表进行排序
-(void)sortCityArray
{
    //self.modeArr[indexPath.section][KCitys_regions][indexPath.row][cityName]
    NSArray *demo=@[
  @{@"firstLetter":@"A",
    @"regionModel":@[@{@"code":@"100100",@"name":@"beijing"},
                     @{@"code":@"100100",@"name":@"beijing"}]}
  
  ,@{@"firstLetter":@"A",
     @"regionModel":@[@{@"code":@"100100",@"name":@"beijing"},
                      @{@"code":@"100100",@"name":@"beijing"}]}];
    
    NSMutableArray *cityDatas=[NSMutableArray array];
    //转拼音 增加PinYin 键值对
    for (NSDictionary *region in _modeArr) {
        for (NSDictionary* dic in region[KCitys_regions]) {
            NSString *cityNameeeee=[dic objectForKey:@"name"];
            NSString *PinYin= [ChineseToPinyin pinyinFromChiniseString:cityNameeeee];
            
            NSMutableDictionary *cityDic=[NSMutableDictionary dictionaryWithDictionary:dic];
            [cityDic setValue:PinYin forKey:@"PinYin"];
            [cityDatas addObject:cityDic];
        }
    }
    dateSortArray=[[NSMutableArray alloc]init];
    [dateSortArray removeAllObjects];
    for (int i = 0; i < 27; i++) {
        [dateSortArray addObject:[NSMutableArray array]];
    }
    NSArray *sortedArray = [NSArray sortArray:cityDatas  ByProperty:@"PinYin" ascending:YES];
    for (NSDictionary *subDic in sortedArray)
    {
        if ([subDic objectForKey:@"PinYin"])
        {
            NSUInteger firstLetterLoc = [ALPHA1 rangeOfString:[[[subDic objectForKey:@"PinYin"] substringToIndex:1] uppercaseString]].location;
            NSLog(@"%lu",(unsigned long)firstLetterLoc);
            if (firstLetterLoc != NSNotFound) {
                [[dateSortArray objectAtIndex:firstLetterLoc] addObject:subDic];
            }
            else
            {
                // 将该类联系人加入到＃一类中
                [[dateSortArray objectAtIndex:26] addObject:subDic];
            }
        } else {
            [[dateSortArray objectAtIndex:26] addObject:subDic];
        }
    }
    
    NSLog(@"  gg  %@",dateSortArray);
    NSLog(@"%lu",(unsigned long)[dateSortArray count]);
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
