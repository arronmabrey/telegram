//
//  FullChatManager.h
//  TelegramTest
//
//  Created by keepcoder on 04.11.13.
//  Copyright (c) 2013 keepcoder. All rights reserved.
//

#import "SharedManager.h"



@interface FullChatMembersChecker : NSObject
- (void) reloadParticipants;
@end;

@interface FullChatManager : SharedManager

@property (nonatomic,assign) BOOL isLoad;
@property (nonatomic,copy) void (^loadHandler)(void);



- (void) loadStored;
- (int) getOnlineCount:(int)chat_id;
- (void)loadIfNeed:(int)chat_id;
- (void)performLoad:(int)chat_id callback:(dispatch_block_t)callback;
- (FullChatMembersChecker *)fullChatMembersCheckerByChatId:(int)chatId;
@end
