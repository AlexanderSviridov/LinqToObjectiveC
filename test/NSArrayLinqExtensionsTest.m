//
//  LinqToObjectiveCTests.m
//  LinqToObjectiveCTests
//
//  Created by Colin Eberhardt on 02/02/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "NSArrayLinqExtensionsTest.h"
#import "Person.h"
#import "NSArray+LinqExtensions.h"

@implementation NSArrayLinqExtensionsTest

- (NSArray*) createTestData
{
    return @[[Person personWithName:@"bob" age:@25],
    [Person personWithName:@"frank" age:@45],
    [Person personWithName:@"ian" age:@35],
    [Person personWithName:@"jim" age:@25],
    [Person personWithName:@"joe" age:@55]];
}

- (void)testWhere
{
    NSArray* input = [self createTestData];
    
    NSArray* peopleWhoAre25 = [input where:^BOOL(id person) {
        return [[person age] isEqualToNumber:@25];
    }];
    
    STAssertEquals(peopleWhoAre25.count, 2U, @"There should have been 2 items returned");
    STAssertEquals([peopleWhoAre25[0] name], @"bob", @"Bob is 25!");
    STAssertEquals([peopleWhoAre25[1] name], @"jim", @"Jim is 25!");
}

- (void)testSelect
{
    NSArray* input = [self createTestData];
    
    NSArray* names = [input select:^id(id person) {
        return [person name];
    }];
    
    STAssertEquals(names.count, 5U, nil);
    // 'spot' check a few values
    STAssertEquals(names[0], @"bob", nil);
    STAssertEquals(names[4], @"joe", nil);
}

- (void)testSort
{
    NSArray* input = @[@21, @34, @25];
    
    NSArray* sortedInput = [input sort];
    
    STAssertEquals(sortedInput.count, 3U, nil);
    STAssertEqualObjects(sortedInput[0], @21, nil);
    STAssertEqualObjects(sortedInput[1], @25, nil);
    STAssertEqualObjects(sortedInput[2], @34, nil);
}

- (void)testSortWithKeySelector
{
    NSArray* input = [self createTestData];
    
    NSArray* sortedByName = [input sort:^id(id person) {
        return [person name];
    }];
    
    STAssertEquals(sortedByName.count, 5U, nil);
    STAssertEquals([sortedByName[0] name], @"bob", nil);
    STAssertEquals([sortedByName[1] name], @"frank", nil);
    STAssertEquals([sortedByName[2] name], @"ian", nil);
    STAssertEquals([sortedByName[3] name], @"jim", nil);
    STAssertEquals([sortedByName[4] name], @"joe", nil);
}

- (void)testOfType
{
    NSArray* mixed = @[@"foo", @25, @"bar", @33];
    
    NSArray* strings = [mixed ofType:[NSString class]];
    
    STAssertEquals(strings.count, 2U, nil);
    STAssertEqualObjects(strings[0], @"foo", nil);
    STAssertEqualObjects(strings[1], @"bar", nil);
}

- (void)testSelectMany
{
    NSArray* data = @[@"foo, bar", @"fubar"];
    
    NSArray* components = [data selectMany:^id(id string) {
        return [string componentsSeparatedByString:@", "];
    }];
    
    STAssertEquals(components.count, 3U, nil);
    STAssertEqualObjects(components[0], @"foo", nil);
    STAssertEqualObjects(components[1], @"bar", nil);
    STAssertEqualObjects(components[2], @"fubar", nil);
}

- (void)testDistinct
{
    NSArray* names = @[@"bill", @"bob", @"bob", @"brian", @"bob"];
    
    NSArray* distinctNames = [names distinct];
    
    STAssertEquals(distinctNames.count, 3U, nil);
    STAssertEqualObjects(distinctNames[0], @"bill", nil);
    STAssertEqualObjects(distinctNames[1], @"bob", nil);
    STAssertEqualObjects(distinctNames[2], @"brian", nil);
}

- (void)testAggregate
{
    NSArray* names = @[@"bill", @"bob", @"brian"];
    
    id csv = [names aggregate:^id(id item, id aggregate) {
        return [NSString stringWithFormat:@"%@, %@", aggregate, item];
    }];
    
    STAssertEqualObjects(csv, @"bill, bob, brian", nil);
    
    NSArray* numbers = @[@22, @45, @33];
    
    id biggestNumber = [numbers aggregate:^id(id item, id aggregate) {
        return [item compare:aggregate] == NSOrderedDescending ? item : aggregate;
    }];
    
    STAssertEqualObjects(biggestNumber, @45, nil);
}

- (void)testFirstOrNil
{
    NSArray* input = [self createTestData];
    NSArray* emptyArray = @[];
    
    STAssertNil([emptyArray firstOrNil], nil);
    STAssertEquals([[input firstOrNil] name], @"bob", nil);
}

- (void)testLastOrNil
{
    NSArray* input = [self createTestData];
    NSArray* emptyArray = @[];
    
    STAssertNil([emptyArray lastOrNil], nil);
    STAssertEquals([[input lastOrNil] name], @"joe", nil);
}

- (void)testTake
{
    NSArray* input = [self createTestData];
    
    STAssertEquals([input take:0].count, 0U, nil);
    STAssertEquals([input take:5].count, 5U, nil);
    STAssertEquals([input take:50].count, 5U, nil);
    STAssertEquals([[input take:2][0] name], @"bob", nil);
}

- (void)testSkip
{
    NSArray* input = [self createTestData];
    
    STAssertEquals([input skip:0].count, 5U, nil);
    STAssertEquals([input skip:5].count, 0U, nil);
    STAssertEquals([[input skip:2][0] name], @"ian", nil);
}


- (void)testAny
{
    NSArray* input = @[@25, @44, @36];
    
    STAssertFalse([input any:^BOOL(id item) {
        return [item isEqualToNumber:@33];
    }], nil);
    
    STAssertTrue([input any:^BOOL(id item) {
        return [item isEqualToNumber:@25];
    }], nil);
}

- (void)testAll
{
    NSArray* input = @[@25, @25, @25];
    
    STAssertFalse([input all:^BOOL(id item) {
        return [item isEqualToNumber:@33];
    }], nil);
    
    STAssertTrue([input all:^BOOL(id item) {
        return [item isEqualToNumber:@25];
    }], nil);
}

- (void)testGroupBy
{
    NSArray* input = @[@"James", @"Jim", @"Bob"];
    
    NSDictionary* groupedByFirstLetter = [input groupBy:^id(id name) {
        return [name substringToIndex:1];
    }];
    
    STAssertEquals(groupedByFirstLetter.count, 2U, nil);
    
    // test the group keys
    NSArray* keys = [groupedByFirstLetter allKeys];
    STAssertEqualObjects(@"J", keys[0], nil);
    STAssertEqualObjects(@"B", keys[1], nil);
    
    // test that the correct items are in each group
    NSArray* groupOne = groupedByFirstLetter[@"J"];
    STAssertEquals(groupOne.count, 2U, nil);
    STAssertEqualObjects(@"James", groupOne[0], nil);
    STAssertEqualObjects(@"Jim", groupOne[1], nil);
    
    NSArray* groupTwo = groupedByFirstLetter[@"B"];
    STAssertEquals(groupTwo.count, 1U, nil);
    STAssertEqualObjects(@"Bob", groupTwo[0], nil);
}

- (void)testToDictionaryWithValueSelector
{
    NSArray* input = @[@"James", @"Jim", @"Bob"];

    NSDictionary* dictionary = [input toDictionaryWithKeySelector:^id(id item) {
        return [item substringToIndex:1];
    } valueSelector:^id(id item) {
        return [item lowercaseString];
    }];
    
    NSLog(@"%@", dictionary);
    
    // NOTE - two items have the same key, hence the dictionary only has 2 keys
    STAssertEquals(dictionary.count, 2U, nil);
    
    // test the group keys
    NSArray* keys = [dictionary allKeys];
    STAssertEqualObjects(@"J", keys[0], nil);
    STAssertEqualObjects(@"B", keys[1], nil);
    
    // test the values
    STAssertEqualObjects(dictionary[@"J"], @"jim", nil);
    STAssertEqualObjects(dictionary[@"B"], @"bob", nil);
}

- (void)testToDictionary
{
    NSArray* input = @[@"Jim", @"Bob"];
    
    NSDictionary* dictionary = [input toDictionaryWithKeySelector:^id(id item) {
        return [item substringToIndex:1];
    }];
    
    STAssertEquals(dictionary.count, 2U, nil);
    
    // test the group keys
    NSArray* keys = [dictionary allKeys];
    STAssertEqualObjects(@"J", keys[0], nil);
    STAssertEqualObjects(@"B", keys[1], nil);
    
    // test the values
    STAssertEqualObjects(dictionary[@"J"], @"Jim", nil);
    STAssertEqualObjects(dictionary[@"B"], @"Bob", nil);
}

- (void) testCount
{
    NSArray* input = @[@25, @35, @25];

    NSUInteger numbersEqualTo25 = [input count:^BOOL(id item) {
        return [item isEqualToNumber:@25];
    }];

    STAssertEquals(numbersEqualTo25, 2U, nil);
}
@end
