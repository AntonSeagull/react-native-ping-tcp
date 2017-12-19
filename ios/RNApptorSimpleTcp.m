#import "RNApptorSimpleTcp.h"

@interface RNApptorSimpleTcp()
@property (nonatomic, strong) NSMutableString *resultJson;
@end


@implementation RNApptorSimpleTcp

//Основная функция. принимает им'я сервера (serverName), номер порта(serverPort) таймаут подключения(connectionTimeout) и в блоке возвращает ответ
- (void)sendCommand:(NSString *)comand toServerWithName:(NSString *)serverName port:(NSString *)serverPort timeout:(NSTimeInterval)connectionTimeout complitionBlock:(SocketBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        outputBlock = block;
        port = [serverPort intValue];
        host = serverName;
        serverComand = comand;
        timeout = connectionTimeout;
        _resultJson = [[NSMutableString alloc] initWithString:@""];
        
        [self setup];
    });
}

//Функция инициализации сокетов
- (void)setup {
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef) host, port, &readStream, &writeStream);
    [self open];
    [self writeOut:serverComand];
}

//Функция открытия сокетов
- (void)open {
    outputStream = (__bridge NSOutputStream *)writeStream;
    inputStream = (__bridge NSInputStream *)readStream;
    
    [outputStream setDelegate:self];
    [inputStream setDelegate:self];
    
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [outputStream open];
    [inputStream open];
    
    //За отведенный переод времени (timeout) проверить состояние сокетов. Если хотя б один з сокетов (на чтение и запись) не открыть то закрыть сокеты и отправить пустой ответ (nil)
    [self performSelector: @selector(openTimeoutExpired) withObject: nil afterDelay: timeout];
}

//Функция закрытия сокетов
- (void)close{
    
    NSString *response  = [NSString stringWithFormat:@"%@\n", @"[terminate]"];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
    
    [inputStream close];
    [outputStream close];
    
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
    
    inputStream = nil;
    outputStream = nil;
}

//Метод делегата NSSocket. Здесь обрабатываються разные состояния сокетов
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    switch (streamEvent) {
            
        case NSStreamEventOpenCompleted:
            break;
        case NSStreamEventHasBytesAvailable:
            //Считываем данные ответа от сервера
            if (theStream == inputStream)
            {
                uint8_t buffer[1024];
                NSInteger len;
                
                while ([inputStream hasBytesAvailable])
                {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0)
                    {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSUTF8StringEncoding];
                        
                        if (nil != output)
                        {
                            [self readIn:output];
                        }
                    }
                }
            }
            break;
            
        case NSStreamEventHasSpaceAvailable:
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"Error %@",[theStream streamError].localizedDescription);
            break;
            
        case NSStreamEventEndEncountered:
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            NSLog(@"close stream");
            break;
            
        default:
            NSLog(@"Unknown event");
    }
    
}

- (void)readIn:(NSString *)result {
    [_resultJson appendString:result];
    if ([_resultJson hasSuffix:@"\n"]) {
        outputBlock(_resultJson);
        [self close];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(openTimeoutExpired) object:nil];
    }
}

//Метод отправки команды на сервер
- (void)writeOut:(NSString *)comand {
    NSString *response  = [NSString stringWithFormat:@"%@\n", comand];
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSUTF8StringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

//Функция закрытия сокетов по таймауту
- (void)openTimeoutExpired {
    if (inputStream.streamStatus != NSStreamStatusOpen || outputStream.streamStatus != NSStreamStatusOpen) {
        NSLog(@"Could not connected to server. Timeout error");
        outputBlock(@"");
        [self close];
    }
}
@end



