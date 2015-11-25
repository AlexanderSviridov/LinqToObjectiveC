//
//  MacroTest.m
//  LinqToObjectiveCTest
//
//  Created by Colin Eberhardt on 29/11/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "MacroTest.h"
#import "Person.h"
#import "NSArray+LinqExtensions.h"

@implementation MacroTest

- (NSArray*) createTestData
{
    return @[[Person personWithName:@"bob" age:@25],
             [Person personWithName:@"frank" age:@45],
             [Person personWithName:@"ian" age:@35],
             [Person personWithName:@"jim" age:@25],
             [Person personWithName:@"joe" age:@55]];
}

- (void)testSelect
{
    NSArray* input = [self createTestData];
    
    NSArray* names = [input linq_select:LINQSel(name)];
    
    XCTAssertEqual(names.count, (NSUInteger)5);
    // 'spot' check a few values
    XCTAssertEqual(names[0], @"bob");
    XCTAssertEqual(names[4], @"joe");
}

- (void)testSelectCast
{
    NSArray* input = [self createTestData];
    
    NSArray* ages = [input linq_select:LINQSelUInt(intAge)];
    
    XCTAssertEqual(ages.count, (NSUInteger)5);
    // 'spot' check a few values
    XCTAssertEqualObjects(ages[0], @25);
    XCTAssertEqualObjects(ages[4], @55);
}

- (void)testSelectViaKey
{
    NSArray* input = [self createTestData];
    
    NSArray* names = [input linq_select:LINQKey(name)];
    
    XCTAssertEqual(names.count, (NSUInteger)5);
    // 'spot' check a few values
    XCTAssertEqual(names[0], @"bob");
    XCTAssertEqual(names[4], @"joe");
}

- (void)testSelectViaKeyPath
{
    NSArray* input = [self createTestData];
    
    NSArray* names = [input linq_select:LINQKeyPath(name)];
    
    XCTAssertEqual(names.count, (NSUInteger)5);
    // 'spot' check a few values
    XCTAssertEqual(names[0], @"bob");
    XCTAssertEqual(names[4], @"joe");
}

@end
