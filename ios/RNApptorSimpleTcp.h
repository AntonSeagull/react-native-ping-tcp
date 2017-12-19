#import <Foundation/Foundation.h>

typedef void (^SocketBlock)(NSString *result);
@interface RNApptorSimpleTcp : NSObject <NSStreamDelegate> {
	@private
	
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream   *inputStream;
    NSOutputStream  *outputStream;

    NSString *serverComand;
	NSString *host;
	int port;
    SocketBlock outputBlock;
    NSTimeInterval timeout;
}


- (void)sendCommand:(NSString *)comand toServerWithName:(NSString *)serverName port:(NSString *)serverPort timeout:(NSTimeInterval)connectionTimeout complitionBlock:(SocketBlock)block;
@end
