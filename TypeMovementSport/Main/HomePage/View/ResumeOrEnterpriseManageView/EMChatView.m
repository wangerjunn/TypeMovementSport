//
//  EMChatView.m
//  TypeMovementSport
//
//  Created by XDH on 2018/12/31.
//  Copyright © 2018年 XDH. All rights reserved.
//

#import "EMChatView.h"
#import <HyphenateLite/HyphenateLite.h>
#import "IConversationModel.h"
#import "EaseConversationModel.h"
#import "ChatRoomViewController.h"
#import "UserModel.h"

#import "EaseUI.h"

@interface EMChatView ()<
    UITableViewDelegate,
    UITableViewDataSource,
    EMChatManagerDelegate> {
    UITableView *chatTable;
    NSMutableArray *messageArr;
}

@end

@implementation EMChatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
        
        if (!isAutoLogin) {
            TO_WEAK(self, weakSelf);
            NSData *data = UserDefaultsGet(kUserModel);
            UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [[EMClient sharedClient] loginWithUsername:model.username
                                              password:model.username
                                            completion:^(NSString *aUsername, EMError *aError) {
                                                if (!aError) {
                                                    NSLog(@"登录成功");
                                                    NSArray *conversations =  [[EMClient sharedClient].chatManager getAllConversations];
                                                    
                                                    [weakSelf createData:conversations];
                                                } else {
                                                    NSLog(@"登录失败");
                                                }
                                            }];
        }else {
            //自动登录
            NSArray *conversations =  [[EMClient sharedClient].chatManager getAllConversations];
            
            [self createData:conversations];
        }
        
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
        [self createUI];
    }
    
    return self;
}

- (void)createData:(NSArray *)conversations {
    
    if (messageArr == nil) {
        messageArr = [NSMutableArray array];
    }else {
        [messageArr removeAllObjects];
    }
    
    NSArray* sorted = [conversations sortedArrayUsingComparator:
                       ^(EMConversation *obj1, EMConversation* obj2){
                           EMMessage *message1 = [obj1 latestMessage];
                           EMMessage *message2 = [obj2 latestMessage];
                           if(message1.timestamp > message2.timestamp) {
                               return(NSComparisonResult)NSOrderedAscending;
                           }else {
                               return(NSComparisonResult)NSOrderedDescending;
                           }
                       }];
    
    for (EMConversation *converstion in sorted) {
        EaseConversationModel *model = nil;
        model = [[EaseConversationModel alloc] initWithConversation:converstion];
        if (model) {
            [messageArr addObject:model];
        }
    }
    
    [chatTable reloadData];
}

- (void)createUI {
    chatTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width,  self.height) style:UITableViewStyleGrouped];
    chatTable.delegate = self;
    chatTable.dataSource = self;
    chatTable.backgroundColor = [UIColor clearColor];
    
    [self addSubview:chatTable];
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [EaseConversationCell cellHeightWithModel:nil];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
    EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if ([messageArr count] <= indexPath.row) {
        return cell;
    }
    
    id<IConversationModel> model = messageArr[indexPath.row];
    
    EMMessage *receiveMessage = model.conversation.lastReceivedMessage;
    if (receiveMessage) {
        model.title = receiveMessage.ext[@"nickname"];
        model.avatarURLPath = receiveMessage.ext[@"avatar"];
    }else {
        EMMessage *lastMessage = model.conversation.latestMessage;
        model.title = lastMessage.ext[@"nickname"];
        model.avatarURLPath = lastMessage.ext[@"avatar"];
    }
    cell.model = model;
    
    
    cell.detailLabel.attributedText =  [[EaseEmotionEscape sharedInstance] attStringFromTextForChatting:[self _latestMessageTitleForConversationModel:model]textFont:cell.detailLabel.font];
    cell.timeLabel.text = [self _latestMessageTimeForConversationModel:model];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EaseConversationModel *model = [messageArr objectAtIndex:indexPath.row];
    ChatRoomViewController *chatVC = [[ChatRoomViewController alloc] initWithConversationChatter:model.conversation.conversationId conversationType:model.conversation.type];
    EMMessage *receiveMessage = model.conversation.lastReceivedMessage;
    
    if (receiveMessage) {
        chatVC.userInfoDic = @{
                               @"avatar":receiveMessage.ext[@"avatar"]?receiveMessage.ext[@"avatar"]:@"",
                               @"nickName":receiveMessage.ext[@"nickname"]?receiveMessage.ext[@"nickname"]:@""
                               };
        if (!receiveMessage.isRead) {
            EMError *aError = nil;
            [model.conversation markMessageAsReadWithId:receiveMessage.messageId error:&aError];
            [chatTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
    
    [self.viewController.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - private

//获取会话最近一条消息内容提示
- (NSString *)_latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = @"[image]";
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = @"[voice]";
            } break;
            
            
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}

//获取会话最近一条消息时间
- (NSString *)_latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp ;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
}

#pragma mark -- EMChatManagerDelegate
- (void)messagesDidReceive:(NSArray *)aMessages {
    NSArray *conversations =  [[EMClient sharedClient].chatManager getAllConversations];
    
    [self createData:conversations];
}

- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    
    NSArray *conversations =  [[EMClient sharedClient].chatManager getAllConversations];
    
    [self createData:conversations];
}

- (void)dealloc {
    [[EMClient sharedClient].chatManager removeDelegate:self];
}
@end
