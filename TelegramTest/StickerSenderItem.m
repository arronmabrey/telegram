//
//  StickerSenderItem.m
//  Telegram
//
//  Created by keepcoder on 19.12.14.
//  Copyright (c) 2014 keepcoder. All rights reserved.
//

#import "StickerSenderItem.h"

@implementation StickerSenderItem


-(id)initWithDocument:(TLDocument *)document forConversation:(TL_conversation*)conversation {
    if(self = [super initWithConversation:conversation]) {
        
        self.message = [MessageSender createOutMessage:@"" media:[TL_messageMediaDocument createWithDocument:document] conversation:conversation];
        
        [self.message save:YES];
    }
    
    return self;
}

-(void)performRequest {
    
    id request;
    
    id media = [TL_inputMediaDocument createWithN_id:[TL_inputDocument createWithN_id:self.message.media.document.n_id access_hash:self.message.media.document.access_hash]];
    
    if(self.conversation.type != DialogTypeBroadcast) {
        request = [TLAPI_messages_sendMedia createWithFlags:self.message.reply_to_msg_id != 0 ? 1 : 0 peer:self.conversation.inputPeer reply_to_msg_id:self.message.reply_to_msg_id media:media random_id:self.message.randomId];
    } else {
        
        TL_broadcast *broadcast = self.conversation.broadcast;
        
        request = [TLAPI_messages_sendBroadcast createWithContacts:[broadcast inputContacts] random_id:[broadcast generateRandomIds] message:self.message.message media:media];
    }
    
    [RPCRequest sendRequest:request successHandler:^(RPCRequest *request, TLUpdates * response) {
                
        
        if(response.updates.count < 2)
        {
            [self cancel];
            return;
        }
        
        TL_localMessage *msg = [TL_localMessage convertReceivedMessage:(TLMessage *) ( [response.updates[1] message])];
        
        if(self.conversation.type != DialogTypeBroadcast)  {
            
            self.message.n_id = msg.n_id;
            self.message.date = msg.date;
            
        } else {
            
          //  TL_messages_statedMessages *stated = (TL_messages_statedMessages *) response;
          //  [TL_localMessage convertReceivedMessages:stated.messages];
            
          //  [SharedManager proccessGlobalResponse:stated];
            
          //  [Notification perform:MESSAGE_LIST_RECEIVE data:@{KEY_MESSAGE_LIST:stated.messages}];
          //  [Notification perform:MESSAGE_LIST_UPDATE_TOP data:@{KEY_MESSAGE_LIST:stated.messages,@"update_real_date":@(YES)}];
            
        }
        
        self.message.dstate = DeliveryStateNormal;
        
        [self.message save:YES];
        
        self.state = MessageSendingStateSent;

        
        
    } errorHandler:^(RPCRequest *request, RpcError *error) {
        
    } timeout:0 queue:[ASQueue globalQueue].nativeQueue];
}

@end
