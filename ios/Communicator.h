

typedef void (^SocketBlock)(NSString *result);

@interface Communicator : NSObject <NSStreamDelegate> {
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

@end


