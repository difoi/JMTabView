//  Created by Jason Morrissey

#import "JMTabView.h"
#import "JMTabContainer.h"
#import "BarBackgroundLayer.h"

@interface JMTabView()
@property (nonatomic,strong) JMTabContainer * tabContainer;
@end

@implementation JMTabView

@synthesize tabContainer = tabContainer_;
@synthesize delegate = delegate_;

- (void)dealloc;
{
    self.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self setBackgroundLayer:[[BarBackgroundLayer alloc] init]];
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.tabContainer = [[JMTabContainer alloc] initWithFrame:self.bounds];
        [self addSubview:self.tabContainer];
    }
    return self;
}

- (void)setBackgroundLayer:(CALayer *)backgroundLayer;
{
    CALayer * oldBackground = [[self.layer sublayers] objectAtIndex:0];
    if (oldBackground)
    {
        [self.layer replaceSublayer:oldBackground with:backgroundLayer];
    }
    else
    {
        [self.layer insertSublayer:backgroundLayer atIndex:0];
    }
}

- (void)layoutSubviews;
{
    [self.tabContainer centerInSuperView];
}

#pragma Mark -
#pragma Mark Notifying Delegates

- (void)didSelectItemAtIndex:(NSUInteger)itemIndex;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:didSelectTabAtIndex:)])
    {
        [self.delegate tabView:self didSelectTabAtIndex:itemIndex];
    }
}

#pragma Mark -
#pragma External Interface

- (void)setMomentary:(BOOL)momentary;
{
    [self.tabContainer setMomentary:momentary];
}

- (void)addTabItem:(JMTabItem *)tabItem;
{
    [self.tabContainer addTabItem:tabItem];
}

- (void)addTabItemWithTitle:(NSString *)title icon:(UIImage *)icon;
{
    JMTabItem * tabItem = [JMTabItem tabItemWithTitle:title icon:icon];
    [self addTabItem:tabItem];
}

#if NS_BLOCKS_AVAILABLE
- (void)addTabItemWithTitle:(NSString *)title icon:(UIImage *)icon executeBlock:(JMTabExecutionBlock)executeBlock;
{
    JMTabItem * tabItem = [JMTabItem tabItemWithTitle:title icon:icon executeBlock:executeBlock];
    [self addTabItem:tabItem];
}
#endif

- (void)setSelectedIndex:(NSUInteger)itemIndex;
{
    [self.tabContainer layoutSubviews];
    [self.tabContainer animateSelectionToItemAtIndex:itemIndex];
}

#pragma Mark -
#pragma Customisation

- (void)setSelectionView:(JMSelectionView *)selectionView;
{
    [[self.tabContainer selectionView] removeFromSuperview];
    [self.tabContainer setSelectionView:selectionView];
    [self.tabContainer insertSubview:selectionView atIndex:0];
}

- (void)setItemSpacing:(CGFloat)itemSpacing;
{
    [self.tabContainer setItemSpacing:itemSpacing];
    [self.tabContainer setNeedsLayout];
}

@end
