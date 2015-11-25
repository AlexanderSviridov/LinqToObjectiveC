//
//  NSDictionaryLinqExtensionsTest.m
//  LinqToObjectiveC
//
//  Created by Colin Eberhardt on 26/02/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "NSDictionaryLinqExtensionsTest.h"
#import "NSDictionary+LinqExtensions.h"

@implementation NSDictionaryLinqExtensionsTest

- (void)testWhere
{
    NSDictionary<NSString *, NSString *>* input = @{@"A" : @"Apple",
    @"B" : @"Banana",
    @"C" : @"Carrot",
    @"D" : @"Fish"};
    
    
    NSDictionary* result = [input linq_where:^BOOL(NSString *key, NSString *value) {
        return [key isEqual:[value substringToIndex:1]];
    }];
    
    XCTAssertEqual(result.allKeys.count, (NSUInteger)3);
    XCTAssertEqualObjects(result[@"A"], @"Apple");
    XCTAssertEqualObjects(result[@"B"], @"Banana");
    XCTAssertEqualObjects(result[@"C"], @"Carrot");
}

- (void)testSelect
{
    NSDictionary* input = @{@"A" : @"Apple",
                    @"B" : @"Banana",
                    @"C" : @"Carrot",
                    @"D" : @"Fish"};
    
    
    NSDictionary* result = [input linq_select:^id(id key, id value) {
        return [NSString stringWithFormat:@"%@, %@", key, [value substringToIndex:1]];
    }];
    
    XCTAssertEqual(result.allKeys.count, (NSUInteger)4);
    XCTAssertEqualObjects(result[@"A"], @"A, A");
    XCTAssertEqualObjects(result[@"B"], @"B, B");
    XCTAssertEqualObjects(result[@"C"], @"C, C");
    XCTAssertEqualObjects(result[@"D"], @"D, F");
}

- (void)testSelectWithNil
{
    NSDictionary* input = @{@"A" : @"Apple",
    @"B" : @"Banana",
    @"C" : @"Carrot",
    @"D" : @"Fish"};
    
    
    NSDictionary* result = [input linq_select:^id(id key, id value) {
        NSString* projection = [NSString stringWithFormat:@"%@, %@", key, [value substringToIndex:1]];
        return [projection isEqualToString:@"A, A"] ? nil : projection;
    }];
    
    XCTAssertEqual(result.allKeys.count, (NSUInteger)4);
    XCTAssertEqualObjects(result[@"A"], [NSNull null]);
    XCTAssertEqualObjects(result[@"B"], @"B, B");
    XCTAssertEqualObjects(result[@"C"], @"C, C");
    XCTAssertEqualObjects(result[@"D"], @"D, F");
}

- (void)testToArray
{
    NSDictionary* input = @{@"A" : @"Apple",
    @"B" : @"Banana",
    @"C" : @"Carrot"};

    NSArray* result = [input linq_toArray:^id(id key, id value) {
        return [NSString stringWithFormat:@"%@, %@", key, value];
    }];
    
    NSLog(@"%@", result);
    
    XCTAssertEqual(result.count, (NSUInteger)3);
    XCTAssertEqualObjects(result[0], @"A, Apple");
    XCTAssertEqualObjects(result[1], @"B, Banana");
    XCTAssertEqualObjects(result[2], @"C, Carrot");
}

- (void)testToArrayWithNil
{
    NSDictionary* input = @{@"A" : @"Apple",
    @"B" : @"Banana",
    @"C" : @"Carrot"};
    
    NSArray* result = [input linq_toArray:^id(id key, id value) {
        NSString* projection = [NSString stringWithFormat:@"%@, %@", key, value];
        return [projection isEqualToString:@"A, Apple"] ? nil : projection;
    }];
    
    NSLog(@"%@", result);
    
    XCTAssertEqual(result.count, (NSUInteger)3);
    XCTAssertEqualObjects(result[0], [NSNull null]);
    XCTAssertEqualObjects(result[1], @"B, Banana");
    XCTAssertEqualObjects(result[2], @"C, Carrot");
}

- (void)testAll
{
    NSDictionary* input = @{@"a" : @"apple",
    @"b" : @"banana",
    @"c" : @"bat"};

    BOOL allValuesHaveTheLetterA = [input linq_all:^BOOL(id key, id value) {
        return [value rangeOfString:@"a"].length != 0;
    }];
    XCTAssertTrue(allValuesHaveTheLetterA);

    BOOL allValuesContainKey = [input linq_all:^BOOL(id key, id value) {
        return [value rangeOfString:key].length != 0;
    }];
    XCTAssertFalse(allValuesContainKey);
}

- (void)testAny
{
    NSDictionary* input = @{@"a" : @"apple",
    @"b" : @"banana",
    @"c" : @"bat"};

    BOOL anyValuesHaveTheLetterN = [input linq_any:^BOOL(id key, id value) {
        return [value rangeOfString:@"n"].length != 0;
    }];
    XCTAssertTrue(anyValuesHaveTheLetterN);
    
    BOOL anyKeysHaveTheLetterN = [input linq_any:^BOOL(id key, id value) {
        return [key rangeOfString:@"n"].length != 0;
    }];
    XCTAssertFalse(anyKeysHaveTheLetterN);
}


- (void)testCount
{
    NSDictionary* input = @{@"a" : @"apple",
    @"b" : @"banana",
    @"c" : @"bat"};


    NSUInteger valuesThatContainKey = [input linq_count:^BOOL(id key, id value) {
        return [value rangeOfString:key].length != 0;
    }];
    XCTAssertEqual(valuesThatContainKey, (NSUInteger)2);
}

- (void)testMerge
{
    NSDictionary* input = @{@"a" : @"apple",
    @"b" : @"banana",
    @"c" : @"bat"};
    
    NSDictionary* merge = @{@"d" : @"dog",
    @"b" : @"box",
    @"e" : @"egg"};
    
    
    NSDictionary* result = [input linq_Merge:merge];
    
    XCTAssertEqual(result.allKeys.count, (NSUInteger)5);
    XCTAssertEqualObjects(result[@"a"], @"apple");
    XCTAssertEqualObjects(result[@"b"], @"banana");
    XCTAssertEqualObjects(result[@"c"], @"bat");
    XCTAssertEqualObjects(result[@"d"], @"dog");
    XCTAssertEqualObjects(result[@"e"], @"egg");
}

@end
