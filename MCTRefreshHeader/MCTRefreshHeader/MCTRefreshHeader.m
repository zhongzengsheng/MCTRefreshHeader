
#import "MCTRefreshHeader.h"
#import "DACircularProgressView.h"

static const CGFloat criticalY = -64.f;

#define kMCTRefreshHeaderRotateAnimationKey @"RotateAnimationKey"

@implementation MCTRefreshHeader
{
    //CABasicAnimation *_rotateAnimation;
    DACircularProgressView *circularProgress; //圆形进度条
    UIActivityIndicatorView *activityIndicator;
    CGFloat prevOrignY;
}

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center
{
    MCTRefreshHeader *header = [MCTRefreshHeader new];
    header.center = center;
    return header;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    circularProgress = [[DACircularProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width+2, self.frame.size.height)];
    circularProgress.progress = 0;
    circularProgress.hidden = YES;
    [self addSubview:circularProgress];
    
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.frame = circularProgress.frame;
    activityIndicator.hidesWhenStopped = YES;
    //activityIndicator.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    [self addSubview:activityIndicator];
}

- (void)setRefreshState:(MCTRefreshViewState)refreshState
{
    [super setRefreshState:refreshState];
    
    if (refreshState == MCTRefreshViewStateRefreshing) {
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        circularProgress.hidden = YES;
        [activityIndicator startAnimating];
    } else if (refreshState == MCTRefreshViewStateNormal) {
        circularProgress.hidden = YES;
        [activityIndicator stopAnimating];
    }
}


- (void)updateRefreshHeaderWithOffsetY:(CGFloat)y
{
    //NSLog(@"OffsetY = %@",@(y));
    CGFloat progress = MIN(1, fabs((criticalY - y))/50);
    if (y>criticalY) {
        self.refreshState = MCTRefreshViewStateWillRefresh;
        return;
    }
    if (progress == 1) {
        if (self.scrollView.isDragging && self.refreshState != MCTRefreshViewStateWillRefresh) {
            self.refreshState = MCTRefreshViewStateWillRefresh;
        } else if (!self.scrollView.isDragging && self.refreshState == MCTRefreshViewStateWillRefresh) {
            self.refreshState = MCTRefreshViewStateRefreshing;
        }
    }
    
    if (self.refreshState == MCTRefreshViewStateRefreshing) return;
    if (!self.scrollView.isDragging && prevOrignY>y) return;
    
    prevOrignY = y;
    
    circularProgress.hidden = NO;
    circularProgress.progress = progress;
    [activityIndicator stopAnimating];
}

- (void)headerBeginRefreshing{
    self.refreshState = MCTRefreshViewStateRefreshing;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (keyPath != kMCTBaseRefreshViewObserveKeyPath) return;
    
    [self updateRefreshHeaderWithOffsetY:self.scrollView.contentOffset.y];
}

@end
