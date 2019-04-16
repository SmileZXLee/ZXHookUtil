//
//  ZXBaseTableView.m
//  ZXBaseTableView
//
//  Created by 李兆祥 on 2018/8/20.
//  Copyright © 2018年 李兆祥. All rights reserved.
//  Github地址：https://github.com/SmileZXLee/ZXBaseTableView

#import "ZXBaseTableView.h"
#import "NSObject+SafeSetValue.h"
#import "UIView+GetCurrentVC.h"
#import "NSObject+Property.h"

#import "MJRefresh.h"
@interface ZXBaseTableView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)NSMutableArray *zxLastDatas;

@property(nonatomic, copy)NSString *noMoreStr;
@property(nonatomic, weak)UIView *noMoreDataView;

@property(nonatomic, assign)MJFooterStyle footerStyle;
@property(nonatomic, assign)BOOL isMJHeaderRef;
@property(nonatomic, strong)id target;
@end
@implementation ZXBaseTableView
#pragma mark 初始化(在这边做一些tableView的初始化工作)
-(void)initialize{
    self.delegate = self;
    self.dataSource = self;
    self.pageCount = 1;
    self.pageCount = PAGECOUNT;
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.showsVerticalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.backgroundColor = [UIColor clearColor];
}
-(instancetype)init{
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if(self = [super initWithFrame:frame style:style]){
        [self initialize];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self initialize];
}
-(void)dealloc{
    self.delegate = nil;
    self.dataSource = nil;
}
#pragma mark - Setter
-(void)setZxDatas:(NSMutableArray *)zxDatas{
    _zxDatas = zxDatas;
    [self reloadData];
    /*
     @ZXWeakSelf(self);
     [self.zxDatas obsKey:@"count" handler:^(id newData, id oldData, id owner) {
     @ZXStrongSelf(self);
     if(![newData integerValue]){
     //没有数据
     [self showNoMoreData];
     [self reloadData];
     }else{
     [self removeNoMoreData];
     }
     }];
     */
    
}
-(void)initDatasWithSectionCount:(NSUInteger)secCount rowCount:(NSUInteger)rowCount{
    NSMutableArray *datasArr = [NSMutableArray array];
    for(NSUInteger i = 0; i < secCount;i++){
        NSMutableArray *secArr = [NSMutableArray array];
        for(NSUInteger j = 0; j < secCount;j++){
            NSObject *model = [[NSObject alloc]init];
            [secArr addObject:model];
        }
        [datasArr addObject:secArr];
    }
    self.zxDatas = datasArr;
}

-(void)initDatasWithRowCount:(NSUInteger)rowCount{
    NSMutableArray *datasArr = [NSMutableArray array];
    for(NSUInteger i = 0; i < rowCount;i++){
        NSObject *model = [[NSObject alloc]init];
        [datasArr addObject:model];
    }
    self.zxDatas = datasArr;
}
-(void)setDisableAutomaticDimension:(BOOL)disableAutomaticDimension{
    _disableAutomaticDimension = disableAutomaticDimension;
    if(disableAutomaticDimension){
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
}
#pragma mark - UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if([self.zxDataSource respondsToSelector:@selector(cellForRowAtIndexPath:)]){
        return [self.zxDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        id model = [self getModelAtIndexPath:indexPath];
        NSString *className  = nil;
        Class cellClass = nil;
        if(self.cellClassAtIndexPath){
            cellClass = self.cellClassAtIndexPath(indexPath);
            className = NSStringFromClass(cellClass);
        }
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.nib",[[NSBundle mainBundle]resourcePath],className]];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
        if(!cell){
            if(isExist){
                cell = [[[NSBundle mainBundle]loadNibNamed:className owner:nil options:nil]lastObject];
                [cell safeSetValue:className forKeyPath:@"reuseIdentifier"];
            }else{
                if(cellClass){
                    cell = [[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
                }else{
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
                    cell.textLabel.text = @"Undefined Cell";
                }
            }
        }
        if(model){
            [model safeSetValue:indexPath forKeyPath:INDEX];
            CGFloat cellH = ((UITableViewCell *)cell).frame.size.height;
            if(cellH && ![[model safeValueForKeyPath:CELLH] floatValue]){
                if([[model getAllPropertyNames]containsObject:CELLH]){
                    [model safeSetValue:[NSNumber numberWithFloat:cellH] forKeyPath:CELLH];
                }else{
                    [model setCellHRunTime:[NSNumber numberWithFloat:cellH]];
                }
                
            }
            NSArray *proNames = [cell getAllPropertyNames];
            BOOL cellContainsModel = NO;
            for (NSString *proStr in proNames) {
                if([proStr.uppercaseString containsString:DATAMODEL.uppercaseString]){
                    [cell safeSetValue:model forKeyPath:proStr];
                    cellContainsModel = YES;
                    break;
                }
            }
        }
        /*
         if(!cellContainsModel || ![[model safeValueForKey:CELLH] doubleValue]){
         if(![[cell getAllPropertyNames]containsObject:CELLH]){
         [cell safeSetValue:[NSNumber numberWithFloat:cellH] forKey:CELLH];
         }else{
         [cell setValue:[NSNumber numberWithFloat:cellH] forUndefinedKey:CELLH];
         }
         
         }
         */
        !self.cellAtIndexPath ? : self.cellAtIndexPath(indexPath,cell,model);
        //可以在这里设置整个项目cell的属性，也可以在cellAtIndexPath的block中设置当前控制器tableview的cell属性
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.zxDataSource respondsToSelector:@selector(numberOfRowsInSection:)]){
        return [self.zxDataSource tableView:tableView numberOfRowsInSection:section];
    }else{
        if(self.numberOfRowsInSection){
            return self.numberOfRowsInSection(section);
        }else{
            if([self isMultiDatas]){
                NSArray *sectionArr = [self.zxDatas objectAtIndex:section];
                return sectionArr.count;
            }else{
                return self.zxDatas.count;
            }
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self.zxDataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]){
        return [self.zxDataSource numberOfSectionsInTableView:tableView];
    }else{
        if(self.numberOfSectionsInTableView){
            return self.numberOfSectionsInTableView(tableView);
        }else{
            return [self isMultiDatas] ? self.zxDatas.count : 1;
        }
    }
}

#pragma mark - UITableViewDelegate
#pragma mark tableView 选中某一indexPath
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.zxDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
        [self.zxDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }else{
        [self deselectRowAtIndexPath:indexPath animated:YES];
        id model = [self getModelAtIndexPath:indexPath];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        !self.didSelectedAtIndexPath ? : self.didSelectedAtIndexPath(indexPath,model,cell);
    }
}
#pragma mark tableView 取消选中某一indexPath
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.zxDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]){
        [self.zxDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
        id model = [self getModelAtIndexPath:indexPath];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        !self.didDeselectedAtIndexPath ? : self.didDeselectedAtIndexPath(indexPath,model,cell);
    }
}
#pragma mark tableView 滑动删除
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.editActionsForRowAtIndexPath){
        return self.editActionsForRowAtIndexPath(indexPath);
    }else{
        return nil;
    }
}
#pragma mark tableView 是否可以编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.editActionsForRowAtIndexPath ? YES : NO;
}
#pragma mark tableView cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.zxDelegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]) {
        return UITableViewAutomaticDimension;
    }
    if([self.zxDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]){
        return [self.zxDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }else{
        if(self.cellHAtIndexPath){
            return self.cellHAtIndexPath(indexPath);
        }else{
            id model = [self getModelAtIndexPath:indexPath];
            if(model){
                CGFloat cellH = [[model safeValueForKeyPath:CELLH] floatValue];
                if(cellH){
                    return cellH;
                }else{
                    return [[model cellHRunTime] floatValue];
                }
            }
            else{
                return CELLDEFAULTH;
            }
        }
        
    }
}
#pragma mark tableView cell 将要展示
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    !self.willDisplayCell ? : self.willDisplayCell(indexPath,cell);
}
#pragma mark tableView HeaderView & FooterView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = nil;
    if([self.zxDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]){
        headerView = [self.zxDelegate tableView:tableView viewForHeaderInSection:section];
        
    }else{
        if(self.headerClassInSection){
            headerView = [self getHeaderViewInSection:section];
            
        }else{
            if(self.viewForHeaderInSection){
                headerView = self.viewForHeaderInSection(section);
            }
        }
    }
    NSMutableArray *secArr = self.zxDatas.count ? [self isMultiDatas] ? self.zxDatas[section] : self.zxDatas : nil;
    !self.headerViewInSection ? : self.headerViewInSection(section,headerView,secArr);
    return !secArr.count ? self.showHeaderWhenNoMsg ? headerView : nil : headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = nil;
    if([self.zxDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]){
        footerView = [self.zxDelegate tableView:tableView viewForFooterInSection:section];
        
    }else{
        if(self.footerClassInSection){
            footerView = [self getFooterViewInSection:section];
            
        }else{
            if(self.viewForFooterInSection){
                footerView = self.viewForFooterInSection(section);
            }
        }
    }
    NSMutableArray *secArr = self.zxDatas.count ? [self isMultiDatas] ? self.zxDatas[section] : self.zxDatas : nil;
    !self.footerViewInSection ? : self.footerViewInSection(section,footerView,secArr);
    return footerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([self.zxDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]){
        return [self.zxDelegate tableView:tableView heightForHeaderInSection:section];
        
    }else{
        if(self.headerClassInSection){
            if(self.heightForHeaderInSection){
                return self.heightForHeaderInSection(section);
            }else{
                if(section < self.zxDatas.count || (self.showHeaderWhenNoMsg &&  section == 0)){
                    UIView *headerView = [self getHeaderViewInSection:section];
                    return headerView.frame.size.height;
                }else{
                    return CGFLOAT_MIN;
                }
            }
        }else{
            if(self.heightForHeaderInSection){
                return self.heightForHeaderInSection(section);
            }else{
                return CGFLOAT_MIN;
            }
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if([self.zxDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]){
        return [self.zxDelegate tableView:tableView heightForFooterInSection:section];
        
    }else{
        if(self.footerClassInSection){
            if(self.heightForFooterInSection){
                return self.heightForFooterInSection(section);
            }else{
                if(section < self.zxDatas.count || (self.showFooterWhenNoMsg &&  section == 0)){
                    UIView *footerView = [self getFooterViewInSection:section];
                    return footerView.frame.size.height;
                }else{
                    return CGFLOAT_MIN;
                }
                
            }
        }else{
            if(self.heightForFooterInSection){
                return self.heightForFooterInSection(section);
            }else{
                return CGFLOAT_MIN;
            }
        }
    }
}

#pragma mark scrollView相关代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([self.zxDelegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        return [self.zxDelegate scrollViewDidScroll:scrollView];
        
    }else{
        if(self.scrollViewDidScroll){
            self.scrollViewDidScroll(scrollView);
        }
    }
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if([self.zxDelegate respondsToSelector:@selector(scrollViewDidZoom:)]){
        return [self.zxDelegate scrollViewDidZoom:scrollView];
        
    }else{
        if(self.scrollViewDidZoom){
            self.scrollViewDidZoom(scrollView);
        }
    }
}
-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    if([self.zxDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]){
        return [self.zxDelegate scrollViewDidScrollToTop:scrollView];
        
    }else{
        if(self.scrollViewDidScrollToTop){
            self.scrollViewDidScrollToTop(scrollView);
        }
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if([self.zxDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]){
        return [self.zxDelegate scrollViewWillBeginDragging:scrollView];
        
    }else{
        if(self.scrollViewWillBeginDragging){
            self.scrollViewWillBeginDragging(scrollView);
        }
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if([self.zxDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]){
        return [self.zxDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
        
    }else{
        if(self.scrollViewDidEndDragging){
            self.scrollViewDidEndDragging(scrollView,decelerate);
        }
    }
}
#pragma mark - Private
#pragma mark 判断是否是多个section的情况
-(BOOL)isMultiDatas{
    return self.zxDatas.count && [[self.zxDatas objectAtIndex:0] isKindOfClass:[NSArray class]];
}
#pragma mark 获取对应indexPath的model
-(instancetype)getModelAtIndexPath:(NSIndexPath *)indexPath{
    id model = nil;;
    if([self isMultiDatas]){
        if(indexPath.section < self.zxDatas.count){
            NSArray *sectionArr = self.zxDatas[indexPath.section];
            if(indexPath.row < sectionArr.count){
                model = sectionArr[indexPath.row];
            }
        }
    }else{
        if(indexPath.row < self.zxDatas.count){
            model = self.zxDatas[indexPath.row];
        }
    }
    return model;
}
#pragma mark 根据section获取headerView
-(UIView *)getHeaderViewInSection:(NSUInteger)section{
    Class headerClass = self.headerClassInSection(section);
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.nib",[[NSBundle mainBundle]resourcePath],headerClass]];
    UIView *headerView = nil;
    if(isExist){
        headerView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(headerClass) owner:nil options:nil]lastObject];
    }else{
        headerView = [[headerClass alloc]init];
    }
    return headerView;
}
#pragma mark 根据section获取footerView
-(UIView *)getFooterViewInSection:(NSUInteger)section{
    Class footerClass = self.footerClassInSection(section);
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.nib",[[NSBundle mainBundle]resourcePath],footerClass]];
    UIView *footerView = nil;
    if(isExist){
        footerView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(footerClass) owner:nil options:nil]lastObject];
    }else{
        footerView = [[footerClass alloc]init];
    }
    return footerView;
}
#pragma mark 暂无数据 & 网络错误相关
-(void)showNoMoreDataWithStates:(PlaceImgState)state errorDic:(NSDictionary *)errorDic backSel:(SEL)backSel{
    
    int errorCode = 0;
    if([errorDic.allKeys containsObject:NETERR_CODE]){
        errorCode = [errorDic[NETERR_CODE] intValue];
    }
    
    [self removeNoMoreData];
    UIView *noMoreDataView = [[UIView alloc]init];
    CGFloat noMoreDataViewW = NOMOREDATAVIEWW;
    CGFloat noMoreDataViewH = NOMOREDATAVIEWH;
    CGFloat noMoreDataViewX = (KSCREENWIDTH - noMoreDataViewW) / 2.0;
    CGFloat noMoreDataViewY = (self.frame.size.height - self.tableHeaderView.frame.size.height - noMoreDataViewH) / 2.0;
    noMoreDataView.frame = CGRectMake(noMoreDataViewX, noMoreDataViewY, noMoreDataViewW, noMoreDataViewH);
    UIImageView *subImgV = [[UIImageView alloc]init];
    subImgV.frame = CGRectMake(0, 0, noMoreDataViewW, noMoreDataViewH);
    if(state == PlaceImgStateNoMoreData){
        //显示暂无数据
        subImgV.image = [UIImage imageNamed:NOMOREDATAIMGNAME];
        self.mj_header.hidden = NO;
        self.scrollEnabled  = YES;
        
    }else if(state == PlaceImgStateNetErr){
        //显示网络错误普遍处理
        subImgV.image = [UIImage imageNamed:NETERRIMGNAME];
    }else{
        //显示网络根据特定情况处理
        if(!self.hideReloadBtn){
            subImgV.frame = CGRectMake(0, 0, noMoreDataViewW, noMoreDataViewH - RELOADBTNH - 2 * RELOADBTNMARGIN);
            
        }
        UIButton *reloadBtn = [[UIButton alloc]init];
        reloadBtn.clipsToBounds = YES;
        CGFloat reloadBtnW = RELOADBTNW;
        CGFloat reloadBtnH = self.hideReloadBtn ? 0 : RELOADBTNH;
        CGFloat reloadBtnX = (noMoreDataViewW - RELOADBTNW) / 2.0;
        CGFloat reloadBtnY = CGRectGetMaxY(subImgV.frame) + RELOADBTNMARGIN;
        reloadBtn.frame = CGRectMake(reloadBtnX, reloadBtnY, reloadBtnW, reloadBtnH);
        [reloadBtn setTitle:RELOADBTNTEXT forState:UIControlStateNormal];
        [reloadBtn setTitleColor:UIColorFromRGB(RELOADBTNMAINCOLOR) forState:UIControlStateNormal];
        reloadBtn.titleLabel.font = [UIFont systemFontOfSize:RELOADBTNFONTSIZE];
        reloadBtn.clipsToBounds = YES;
        reloadBtn.layer.borderWidth = 1;
        reloadBtn.layer.borderColor = UIColorFromRGB(RELOADBTNMAINCOLOR).CGColor;
        reloadBtn.layer.cornerRadius = 2;
        [reloadBtn addTarget:self.target action:backSel forControlEvents:UIControlEventTouchUpInside];
        //分开写 比较清晰
        switch (errorCode)
        {   //无网络连接
            case -1009:
            {
                //无网络连接
                subImgV.image = [UIImage imageNamed:NETERRIMGNAME_NO_NET];
                if(!self.hideMsgToast){
                    ZXToast(NETERRTOAST_NO_NET);
                }
                break;
            }
            case -1000:
            {
                //请求失败
                subImgV.image = [UIImage imageNamed:NETERRIMGNAME_REQ_ERROR];
                if(!self.hideMsgToast){
                    ZXToast(NETERRTOAST_REQ_ERROR);
                }
                break;
            }
            case -1001:
            {
                //请求超时
                subImgV.image = [UIImage imageNamed:NETERRIMGNAME_TIME_OUT];
                if(!self.hideMsgToast){
                    ZXToast(NETERRTOAST_TIME_OUT);
                }
                break;
            }
            case -1002:
            {
                //请求地址出错
                subImgV.image = [UIImage imageNamed:NETERRIMGNAME_ADDRESS_ERR];
                if(!self.hideMsgToast){
                    ZXToast(NETERRTOAST_ADDRESS_ERR);
                }
                break;
            }
                
            default:
            {
                //其他错误
                subImgV.image = [UIImage imageNamed:NETERRIMGNAME_OTHER_ERR];
                if(!self.hideMsgToast){
                    if([errorDic.allKeys containsObject:@"message"]){
                        ZXToast([errorDic valueForKey:@"message"]);
                    }else{
                        ZXToast(NETERRTOAST_OTHER_ERR);
                    }
                }
                break;
            }
        }
        if(state == PlaceImgStateNetErrpecific){
            [noMoreDataView addSubview:reloadBtn];
        }
    }
    if(state != PlaceImgStateOnlyToast){
        subImgV.contentMode = UIViewContentModeScaleAspectFit;
        [noMoreDataView addSubview:subImgV];
    }
    [self addSubview:noMoreDataView];
    self.noMoreDataView = noMoreDataView;
}
-(void)removeNoMoreData{
    if(self.noMoreDataView){
        [self.noMoreDataView removeFromSuperview];
        self.noMoreDataView = nil;
    }
}
#pragma mark 重写reloadData
-(void)reloadData{
    [super reloadData];
    self.scrollEnabled = YES;
    if(!self.zxDatas.count){
        //没有数据
        NSDictionary *errDic = [NSDictionary dictionaryWithObjects:@[@0,@""] forKeys:@[NETERR_CODE,NETERR_MESSAGE]];
        [self showNoMoreDataWithStates:PlaceImgStateNoMoreData errorDic:errDic backSel:nil];
        self.mj_footer.hidden = YES;
    }else{
        [self removeNoMoreData];
        self.mj_footer.hidden = NO;
    }
}

#pragma mark - MJRefresh相关 若未使用MJRefresh 下方代码可以注释掉
-(void)setMJFooterStyle:(MJFooterStyle)style noMoreStr:(NSString *)noMoreStr{
    self.footerStyle = style;
    self.noMoreStr = noMoreStr;
}
-(void)addMJHeader:(headerBlock)block{
    @ZXWeakSelf(self);
#warning 这边可以作整个项目mj_header的初始化工作，比如自定义的mj_header，或者设置mj_header刷新文字，颜色等等
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @ZXStrongSelf(self);
        self.isMJHeaderRef = YES;
        if(self.zxDatas.count % self.pageCount){
            self.mj_footer.state = MJRefreshStateNoMoreData;
        }
        [self.zxDatas removeAllObjects];
        self.pageNo = 1;
        block();
    }];
}
-(void)addMJFooter:(footerBlock)block{
    [self addMJFooterStyle:self.footerStyle noMoreStr:self.noMoreStr block:block];
}
-(void)addMJFooterStyle:(MJFooterStyle)style noMoreStr:(NSString *)noMoreStr block:(footerBlock)block{
    if(style == MJFooterStylePlain){
        self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.isMJHeaderRef = NO;
            self.pageNo++;
            block();
        }];
        MJRefreshBackNormalFooter *foot = (MJRefreshBackNormalFooter *)self.mj_footer;
        [foot setTitle:noMoreStr forState:MJRefreshStateNoMoreData];
    }else{
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.isMJHeaderRef = NO;
            self.pageNo++;
            block();
        }];
        if(self.noMoreStr.length){
            MJRefreshAutoNormalFooter *foot = (MJRefreshAutoNormalFooter *)self.mj_footer;
            [foot setTitle:noMoreStr forState:MJRefreshStateNoMoreData];
        }
    }
}
-(void)addPagingWithReqSel:(SEL _Nullable )sel target:(id)target{
    self.target = target;
    [self addMJHeader:^{
        if([target respondsToSelector:sel]){
            ((void (*)(id, SEL))[target methodForSelector:sel])(target, sel);
        }
    }];
    [self addMJFooter:^{
        if([target respondsToSelector:sel]){
            ((void (*)(id, SEL))[target methodForSelector:sel])(target, sel);
        }
    }];
}
-(void)updateTabViewStatus:(BOOL)status{
    [self updateTabViewStatus:status errDic:nil backSel:nil];
}
-(void)updateTabViewStatus:(BOOL)status errDic:(NSDictionary *)errDic backSel:(SEL)backSel{
    [self endMjRef];
    self.mj_header.hidden = NO;
    if(!status && !self.zxDatas.count){
        if(self.hideReloadBtn){
            self.mj_header.hidden = NO;
        }else{
            self.mj_header.hidden = YES;
        }
    }
    if(!self.zxDatas.count){
        self.scrollEnabled = !self.fixWhenNetErr;
    }else{
        self.scrollEnabled = YES;
    }
    if(status){
        if(!self.zxDatas.count){
            self.mj_footer.hidden = YES;
        }else{
            self.mj_footer.hidden = NO;
            if(self.zxDatas.count % self.pageCount || self.zxLastDatas.count == self.zxDatas.count){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.mj_footer.state = MJRefreshStateNoMoreData;
                });
                
            }
        }
        if(!self.isMJHeaderRef){
            self.zxLastDatas = [self.zxDatas mutableCopy];
        }
    }else{
        if(!self.zxDatas.count){
            self.mj_footer.hidden = YES;
            if(!errDic){
                [self showNoMoreDataWithStates:PlaceImgStateNetErr errorDic:errDic backSel:backSel];
            }else{
                [self showNoMoreDataWithStates:PlaceImgStateNetErrpecific errorDic:errDic backSel:backSel];
            }
        }else{
            [self showNoMoreDataWithStates:PlaceImgStateOnlyToast errorDic:errDic backSel:backSel];
        }
        if(self.pageNo > 1){
            self.pageNo--;
            [self.zxLastDatas removeAllObjects];
        }
    }
}
-(void)endMjRef{
    [self reloadData];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

@end
