//
//  UIAlertView+Blocks.h
//  UIKitCategoryAdditions
//

#import <Foundation/Foundation.h>


typedef void (^DismissBlock)(NSInteger buttonIndex);
typedef void (^CancelBlock)();


@interface UIAlertView (Blocks) <UIAlertViewDelegate> 

+ (UIAlertView*) showAlertViewWithTitle:(NSString*) title                    
                                message:(NSString*) message 
                      cancelButtonTitle:(NSString*) cancelButtonTitle
                      otherButtonTitles:(NSArray*) otherButtons
                              onDismiss:(DismissBlock) dismissed                   
                               onCancel:(CancelBlock) cancelled;

@end
