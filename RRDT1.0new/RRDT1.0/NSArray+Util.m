
#import "NSArray+Util.h"

@implementation NSArray (Util)

#pragma mark 对数组进行排序 按照propertyName属性升序排序
+ (NSArray *)sortArray:(NSArray *)beforeSortArray ByProperty:(NSString *)propertyName ascending:(BOOL)order
{
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:propertyName ascending:order];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sorter, nil];
    NSArray *sortdArray = [beforeSortArray sortedArrayUsingDescriptors:sortDescriptors];
    return sortdArray;
}

@end
