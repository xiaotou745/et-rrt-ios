//
//  CitysViewController.h
//  RRDT1.0
//
//  Created by riverman on 15/12/10.
//  Copyright © 2015年 RRDT002. All rights reserved.
//

#import "BackBaseViewController.h"
#define kChooseCityNotif @"kChooseCityNotif"

#define KCitys_sectionTitle @"KCitys_sectionTitle"//段头
#define KCitys_regions @"KCitys_regions"//城市列表

#define cityName @"name"
#define cityCode @"code"

@interface CitysViewController : BackBaseViewController

@property(strong,nonatomic)NSMutableArray *modeArr;
@end
