

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kMCTBaseRefreshViewObserveKeyPath;

typedef enum {
    MCTRefreshViewStateNormal,
    MCTRefreshViewStateWillRefresh,
    MCTRefreshViewStateRefreshing,
} MCTRefreshViewState;

@interface MCTBaseRefreshView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)endRefreshing;

@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInsets;
@property (nonatomic, assign) MCTRefreshViewState refreshState;

@end
