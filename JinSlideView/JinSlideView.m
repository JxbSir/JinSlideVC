//
//  JinSlideView.m
//  TZS
//
//  Created by Peter on 14-12-18.
//  Copyright (c) 2014年 NongFuSpring. All rights reserved.
//

#import "JinSlideView.h"

#define leftPad  10
#define BottomY  44

#define SLIDER_HEIGHT               44
#define SLIDER_TITLE_SIZE           14
#define SLIDER_BOTTOM_SIZE          2
#define SLIDER_BOTTOM_COLOR         [UIColor colorWithRed:218./255 green:32./255 blue:41./255 alpha:1]
#define SLIDER_TITLE_COLOR          [UIColor colorWithRed:218./255 green:32./255 blue:41./255 alpha:1]
#define SLIDER_UNTITLE_COLOR        [UIColor colorWithRed:153./255 green:153./255 blue:153./255 alpha:1]
#define BORDER_GRAY_COLOR           [UIColor colorWithRed:204./255 green:204./255 blue:204./255 alpha:1]

@implementation JinSlideView
@synthesize delegate,enableDragSlide;

- (id)initWithTitles:(CGRect)frame vcArray:(NSArray*)vcArray selectIndex:(int)selectIndex
{
    if(self = [super initWithFrame:frame])
    {
        corLblSelected = SLIDER_TITLE_COLOR;
        corLblUnSelected = SLIDER_UNTITLE_COLOR;
        corImgBotView = SLIDER_BOTTOM_COLOR;
        [self loadView:frame vcArray:vcArray selectIndex:selectIndex];
    }
    return self;
}

- (id)initWithTitlesAndColor:(CGRect)frame vcArray:(NSArray*)vcArray selectIndex:(int)selectIndex corSel:(UIColor*)corSel corUnSel:(UIColor*)corUnSel corBotView:(UIColor*)corBotView
{
    if(self = [super initWithFrame:frame])
    {
        corLblSelected = corSel;
        corLblUnSelected = corUnSel;
        corImgBotView = corBotView;
        [self loadView:frame vcArray:vcArray selectIndex:selectIndex];
    }
    return self;
}

- (void)loadView:(CGRect)frame vcArray:(NSArray*)vcArray selectIndex:(int)selectIndex
{
    self.backgroundColor = [UIColor whiteColor];
    nowSelectIndex = -1;
    arrOfLabels = [NSMutableArray array];
    perW = frame.size.width / vcArray.count;
    for (int i = 0; i < vcArray.count; i++)
    {
        UIViewController* vc = [vcArray objectAtIndex:i];
        UILabel* lbl = [[UILabel alloc] init];
        [lbl setText:vc.title];
        [lbl setFont:[UIFont systemFontOfSize:SLIDER_TITLE_SIZE]];
        CGSize titleSize = [self textSizeWithFont:vc.title font:[UIFont systemFontOfSize:SLIDER_TITLE_SIZE] constrainedToSize:CGSizeMake(MAXFLOAT, 30) lineBreakMode:NSLineBreakByWordWrapping];
        [lbl setFrame:CGRectMake((perW - titleSize.width)/2 + perW * i, 10, perW, 22)];
        if (i == 0)
            [lbl setTextColor:corLblSelected];
        else
            [lbl setTextColor:corLblUnSelected];
        [self addSubview:lbl];
        [arrOfLabels addObject:lbl];
        
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    UIView* bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, BottomY, frame.size.width, 1)];
    bottomLine.backgroundColor = BORDER_GRAY_COLOR;
    [self addSubview:bottomLine];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(nowSelectIndex * perW + leftPad, BottomY, perW - leftPad * 2, SLIDER_BOTTOM_SIZE)];
    bottomView.backgroundColor = corImgBotView;
    [self addSubview:bottomView];
    
    scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, BottomY + 1, frame.size.width, frame.size.height - BottomY)];
    [scView setDelegate:self];
    [scView setContentSize:CGSizeMake(frame.size.width * vcArray.count, frame.size.height - BottomY)];
    scView.backgroundColor = [UIColor whiteColor];
    scView.scrollEnabled = YES;
    scView.userInteractionEnabled = YES;
    scView.pagingEnabled = YES;
    scView.bounces = NO;
    scView.showsHorizontalScrollIndicator = NO;
    scView.showsVerticalScrollIndicator = NO;
    [self addSubview:scView];
    
    for (int i = 0 ; i < vcArray.count; i++) {
        UIViewController* vc = [vcArray objectAtIndex:i];
        UIView* v = vc.view;
        [v setFrame:CGRectMake(frame.size.width * i, 0, frame.size.width, frame.size.height - BottomY)];
        [scView addSubview:v];
    }
    
    [self setSelectIndex:selectIndex bSetOff:YES];
}

#pragma mark - UIScrollview userInteractionEnabled
- (void)setScUserInteraction:(BOOL)enable
{
    scView.userInteractionEnabled = enable;
}

#pragma mark - 滑动回调
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    fHisX = scrollView.contentOffset.x;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < fHisX)
    {
        //left
        scView.userInteractionEnabled = nowSelectIndex > 0 || !enableDragSlide;
    }
    else if (scrollView.contentOffset.x > fHisX)
    {
        //right
        scView.userInteractionEnabled = YES;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    int page = x / self.frame.size.width;
    CGFloat off = (int)x % (int)self.frame.size.width;
    if (off > 0 && off > (self.frame.size.width / 2))
    {
        page++;
    }
    [self setSelectIndex:page bSetOff:NO];
    scView.bounces = enableDragSlide && page == 0;
}

#pragma mark - 移动动画
- (void)setBottomView:(unsigned long)index
{
    void (^block)(void);
    block = ^(void){
        [bottomView setFrame:CGRectMake(index * perW + leftPad, BottomY - SLIDER_BOTTOM_SIZE, perW - leftPad * 2, SLIDER_BOTTOM_SIZE)];
    };
    if(index == -1)
        block();
    else
        [UIView animateWithDuration:0.3f delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:block
                         completion:nil];
}

#pragma mark - 选择标签动作
- (void)Actiondo:(id)sender{
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer*)sender;
    CGPoint point = [tapGesture locationInView:self];
    CGFloat x  = point.x;
    CGFloat y  = point.y;
    if (y > BottomY)
        return;
    unsigned long index = x / perW;
    if (index == nowSelectIndex)
        return;
    [self setSelectIndex:index bSetOff:YES];
    if(delegate)
        [delegate JinSliderViewSelectedChanged:(int)index];
}


#pragma mark - 注册选中区域
- (void)addGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    [super addGestureRecognizer:gestureRecognizer];
}

#pragma mark - 设置选择页数
- (void)setSelectIndex:(unsigned long)index bSetOff:(BOOL)bSetOff
{
    for (UILabel* lb in arrOfLabels) {
        [lb setTextColor:corLblUnSelected];
    }
    if(index >= arrOfLabels.count)
        index = arrOfLabels.count - 1;
    UILabel* lbl = [arrOfLabels objectAtIndex:index];
    [lbl setTextColor:corLblSelected];
    [self setBottomView:index];
    nowSelectIndex = index;
    if (bSetOff)
        [scView setContentOffset:CGPointMake(index * self.frame.size.width, 0) animated:NO];
}

#pragma mark - 更新标签页
- (void)updateTitles:(NSArray*)titles
{
    for (int i = 0; i < titles.count; i++)
    {
        if (i >= arrOfLabels.count)
            break;
        NSString* title = [titles objectAtIndex:i];
        UILabel* lbl = [arrOfLabels objectAtIndex:i];
        [lbl setText:title];
        
        CGSize titleSize = [self textSizeWithFont:title font:[UIFont systemFontOfSize:SLIDER_TITLE_SIZE] constrainedToSize:CGSizeMake(MAXFLOAT, 30) lineBreakMode:NSLineBreakByWordWrapping];
        [lbl setFrame:CGRectMake((perW - titleSize.width)/2 + perW * i, 10, titleSize.width, titleSize.height)];
    }
}

#pragma mark - 获取字符串的高度与长度
- (CGSize)textSizeWithFont:(NSString*)text font:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize textSize;
    if (CGSizeEqualToSize(size, CGSizeZero))
    {
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        textSize = [text sizeWithAttributes:attributes];
    }
    else
    {
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（译者注：字体大小+行间距=行高）
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        CGRect rect = [text boundingRectWithSize:size
                                         options:option
                                      attributes:attributes
                                         context:nil];
        
        textSize = rect.size;
    }
    return textSize;
}

@end
