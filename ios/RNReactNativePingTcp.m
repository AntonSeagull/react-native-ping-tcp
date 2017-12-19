
#import "RNReactNativePingTcp.h"
#import "RNApptorSimpleTcp.h"

@interface RNReactNativePingTcp ()
@property(nonatomic, strong) RNApptorSimpleTcp *commutator;
@end

@implementation RNReactNativePingTcp

RCT_EXPORT_MODULE()


RCT_EXPORT_METHOD(Connect:(NSString *)comand
                  serverName:(NSString *)serverName
                  serverPort:(NSString *)serverPort
                  callback:(RCTResponseSenderBlock)callback) {
    
    self.commutator = [RNApptorSimpleTcp new];
  
  
    
    [self.commutator sendCommand:comand toServerWithName:serverName port:serverPort timeout:1000 complitionBlock:^(NSString *result) {
        
            callback(@[[NSNull null],result]);
        }];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

@end
  
