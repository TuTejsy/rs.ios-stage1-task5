#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string {
    NSDictionary *phoneNumberCodes = @{
        @"7": @{
                @"countryCode": @"RU",
                @"phoneNumberLength": @(10),
        },
        @"373": @{
                @"countryCode": @"MD",
                @"phoneNumberLength": @(8),
        },
        @"374": @{
                @"countryCode": @"AM",
                @"phoneNumberLength": @(8),
        },
        @"375": @{
                @"countryCode": @"BY",
                @"phoneNumberLength": @(9),
        },
        @"380": @{
                @"countryCode": @"UA",
                @"phoneNumberLength": @(9),
        },
        @"992": @{
                @"countryCode": @"TJ",
                @"phoneNumberLength": @(9),
        },
        @"993": @{
                @"countryCode": @"TM",
                @"phoneNumberLength": @(8),
        },
        @"994": @{
                @"countryCode": @"AZ",
                @"phoneNumberLength": @(9),
        },
        @"996": @{
                @"countryCode": @"KG",
                @"phoneNumberLength": @(9),
        },
        @"998": @{
                @"countryCode": @"UZ",
                @"phoneNumberLength": @(9),
        },
    };
    
    NSDictionary *phoneNumberFormats = @{
        @(8): @"(xx) xxx-xxx",
        @(9): @"(xx) xxx-xx-xx",
        @(10): @"(xxx) xxx-xx-xx",
    };
    
    NSMutableString *resultString = [@"" mutableCopy];
    NSMutableString *code = [@"" mutableCopy];
    NSString *formatString = @"";
    NSDictionary *countryKeyDict = nil;
    NSString *countryKey = nil;
    
    for (NSUInteger i = 0; i < string.length; i++) {
        if (code.length > 11) {
            break;
        }
        char character = [string characterAtIndex:i];
        
        switch(i) {
            case 0: {
                if (character != '+') {
                    [code appendFormat:@"%c", character];
                    countryKeyDict = phoneNumberCodes[code];
                    if (countryKeyDict) {
                        if (i + 1 < string.length) {
                            char nextCharacter = [string characterAtIndex:i + 1];
                            
                            if (nextCharacter == '7') {
                                countryKey = @"KZ";
                                formatString = phoneNumberFormats[countryKeyDict[@"phoneNumberLength"]];
                                break;
                            }
                        }
                        
                        countryKey = @"RU";
                        formatString = phoneNumberFormats[countryKeyDict[@"phoneNumberLength"]];
                    }
                }
                
                break;
            }
                
            default: {
                if (!countryKeyDict) {
                    [code appendFormat:@"%c", character];
                    countryKeyDict = phoneNumberCodes[code];
                    if (countryKeyDict) {
                        countryKey = countryKeyDict[@"countryCode"];
                        formatString = phoneNumberFormats[countryKeyDict[@"phoneNumberLength"]];
                    }
                    
                    if (countryKeyDict) {
                        if ([countryKey isEqualToString:@"RU"]) {
                            if (i + 1 < string.length) {
                                char nextCharacter = [string characterAtIndex:i + 1];
                                
                                if (nextCharacter == '7') {
                                    countryKey = @"KZ";
                                    formatString = phoneNumberFormats[countryKeyDict[@"phoneNumberLength"]];
                                    break;
                                }
                            }
                            
                            countryKey = @"RU";
                            formatString = phoneNumberFormats[countryKeyDict[@"phoneNumberLength"]];
                        }
                    }
                    
                    break;
                }
                
                NSUInteger j = 0;
                char formatCharacter;
                
                while ((j < [formatString length])) {
                    formatCharacter = [formatString characterAtIndex:j];
                    
                    if (formatCharacter == 'x') {
                        [resultString appendFormat:@"%c", character];
                        if (j + 1 < [formatString length]) {
                            formatString = [formatString substringFromIndex:j+1];
                        } else {
                            formatString = @"";
                        }
                        
                        break;
                    } else {
                        [resultString appendFormat:@"%c", formatCharacter];
                    }
                    
                    j++;
                }
                
                
            }
        }
    }
    
    NSString *result = resultString.length > 0 ? [NSString stringWithFormat:@"+%@ %@", code, resultString] : [NSString stringWithFormat:@"+%@", code];
    
    return @{
        KeyPhoneNumber: result,
        KeyCountry: (countryKey ? countryKey : @""),
    };
}
@end
