

#import <UIKit/UIKit.h>
#import "MCTBaseRefreshView.h"

@interface MCTRefreshHeader : MCTBaseRefreshView

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center;
- (void)headerBeginRefreshing;
@property (nonatomic, copy) void(^refreshingBlock)();

@end
