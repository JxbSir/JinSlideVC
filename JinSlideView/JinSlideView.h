//
//  JinSlideView.h
//  TZS
//
//  Created by Peter on 14-12-18.
//  Copyright (c) 2014年 NongFuSpring. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JinSliderViewDelegate
- (void)JinSliderViewSelectedChanged:(int)index;
@end

@interface JinSlideView : UIView <UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>
{
    UIScrollView*   scView;
    CGFloat         perW;
    UIView*         bottomView;
    NSMutableArray* arrOfLabels;
    unsigned long   nowSelectIndex;
    
    __weak id<JinSliderViewDelegate> delegate;
    BOOL enableDragSlide;
    
    UIColor* corLblSelected;
    UIColor* corLblUnSelected;
    UIColor* corImgBotView;
    
    
    CGFloat  fHisX;
}
@property(nonatomic,weak)id<JinSliderViewDelegate> delegate;
@property(nonatomic,assign)BOOL enableDragSlide;


- (id)initWithTitles:(CGRect)frame vcArray:(NSArray*)vcArray selectIndex:(int)selectIndex;
- (id)initWithTitlesAndColor:(CGRect)frame vcArray:(NSArray*)vcArray selectIndex:(int)selectIndex corSel:(UIColor*)corSel corUnSel:(UIColor*)corUnSel corBotView:(UIColor*)corBotView;

- (void)setSelectIndex:(unsigned long)index bSetOff:(BOOL)bSetOff;

- (void)updateTitles:(NSArray*)titles;

- (void)setScUserInteraction:(BOOL)enable;
@end
