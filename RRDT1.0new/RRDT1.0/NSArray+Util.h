
#import <Foundation/Foundation.h>

@interface NSArray (Util)

#pragma mark 对数组进行排序 按照propertyName属性升序排序
+ (NSArray *)sortArray:(NSArray *)beforeSortArray ByProperty:(NSString *)propertyName ascending:(BOOL)order;

@end
