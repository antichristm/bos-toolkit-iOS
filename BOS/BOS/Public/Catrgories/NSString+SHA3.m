//
//  NSString+SHA3.h
//
//  Created by Jaeggerr on 14/04/2014.
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/jaeggerr/NSString-SHA3
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "NSString+SHA3.h"
#import "keccak.h"
#import <BTCData.h>
@implementation NSString (SHA3)


- (NSString*) sha3:(NSUInteger)bitsLength
{
    int bytes = (int)(bitsLength/8);
    const char * string = [self cStringUsingEncoding:NSUTF8StringEncoding];
    int size=(int)strlen(string);
    uint8_t md[bytes];
    keccak((uint8_t*)string, size, md, bytes);
    NSMutableString *sha3 = [[NSMutableString alloc] initWithCapacity:bitsLength/4];
    
    for(int32_t i=0;i<bytes;i++)
        [sha3 appendFormat:@"%02X", md[i]];
    return sha3;
}

/**
 *  Hex转data
 */

- (NSData *)dataFromHexString {
    const char *chars = [self UTF8String];
    int i = 0;
    int len = (int)self.length;
    
    NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i < len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}


- (NSString *)stringFromHexString{
    NSInteger hex = strtoul([self UTF8String],0,16);
    NSString * string = [NSString stringWithFormat:@"%ld",hex];
    return string;
}
    

- (NSString *)hexStringFromString{
    NSData *myD = [self dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
- (NSString * )SHA256String{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(data.bytes, (uint32_t)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}
//SHA512加密
- (NSString *)SHA512String
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, (uint32_t)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}
@end

@implementation NSData (NewSHA3)

- (NSString *)newSha3:(NSUInteger)bitsLength {
    int bytes = (int)(bitsLength/8);
    
    NSString *string = BTCHexFromData(self);

    NSData *data  = [string dataFromHexString];
    int size = (int )[data length];
    
    unsigned char *bytesPtr = (unsigned char *)[data bytes];
    uint8_t md[bytes];
    keccak((uint8_t*)bytesPtr, size, md, bytes);
    NSMutableString *sha3 = [[NSMutableString alloc] initWithCapacity:bitsLength/4];
    for(int32_t i=0;i<bytes;i++)
        [sha3 appendFormat:@"%02X", md[i]];
    return sha3;
}




@end



