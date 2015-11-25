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

- (NSArray<Person *>*) createTestData
{
    return @[[Person personWithName:@"bob" age:@25],
             [Person personWithName:@"frank" age:@45],
             [Person personWithName:@"ian" age:@35],
             [Person personWithName:@"jim" age:@25],
             [Person personWithName:@"joe" age:@55]];
}

- (void)testWhere
{
    NSArray<Person *>* input = [self createTestData];
    
    NSArray<Person *>* peopleWhoAre25 = [input linq_where:^BOOL(Person *item) {
        return [[item age] isEqualToNumber:@25];
    }];
    
    XCTAssertEqual(peopleWhoAre25.count, (NSUInteger)2, @"There should have been 2 items returned");
    XCTAssertEqual([peopleWhoAre25[0] name], @"bob", @"Bob is 25!");
    XCTAssertEqual([peopleWhoAre25[1] name], @"jim", @"Jim is 25!");
}

- (void)testSelect
{
    NSArray<Person *>* input = [self createTestData];
    
    NSArray<NSString *>* names = [input linq_select:^id(Person *person) {
        return [person name];
    }];
    
    XCTAssertEqual(names.count, (NSUInteger)5);
    // 'spot' check a few values
    XCTAssertEqual(names[0], @"bob");
    XCTAssertEqual(names[4], @"joe");
}

- (void)testSelectWithNil
{
    NSArray<Person *>* input = [self createTestData];
    
    NSArray* names = [input linq_select:^id(Person *person) {
        return [[person name] isEqualToString:@"bob"] ? nil : [person name];
    }];
    
    XCTAssertEqual(names.count, (NSUInteger)5);
    // 'spot' check a few values
    XCTAssertEqual(names[0], [NSNull null]);
    XCTAssertEqual(names[4], @"joe");
}

- (void)testSelectAndStopOnNil
{
    NSArray<Person *>* input = [self createTestData];
    
    NSArray<NSString *>* names = [input linq_selectAndStopOnNil:^id(id person) {
        return [person name];
    }];
    
    XCTAssertEqual(names.count, (NSUInteger)5);
    // 'spot' check a few values
    XCTAssertEqual(names[0], @"bob");
    XCTAssertEqual(names[4], @"joe");
}

- (void)testSelectAndStopOnNilWithNil
{
    NSArray<Person *>* input = [self createTestData];
    
    NSArray* names = [input linq_selectAndStopOnNil:^id(id person) {
        return [[person name] isEqualToString:@"bob"] ? nil : [person name];
    }];
    
    XCTAssertNil(names);
}

- (void)testSort
{
    NSArray* input = @[@21, @34, @25];
    
    NSArray* sortedInput = [input linq_sort];
    
    XCTAssertEqual(sortedInput.count, (NSUInteger)3);
    XCTAssertEqualObjects(sortedInput[0], @21);
    XCTAssertEqualObjects(sortedInput[1], @25);
    XCTAssertEqualObjects(sortedInput[2], @34);
}

- (void)testSortWithKeySelector
{
    NSArray* input = [self createTestData];
    
    NSArray* sortedByName = [input linq_sort:LINQKey(name)];
    
    XCTAssertEqual(sortedByName.count, (NSUInteger)5);
    XCTAssertEqual([sortedByName[0] name], @"bob");
    XCTAssertEqual([sortedByName[1] name], @"frank");
    XCTAssertEqual([sortedByName[2] name], @"ian");
    XCTAssertEqual([sortedByName[3] name], @"jim");
    XCTAssertEqual([sortedByName[4] name], @"joe");
}

- (void)testSortWithKeySelectorWithNil
{
    NSArray* input = [self createTestData];
    
    NSArray* sortedByName = [input linq_sort:^id(id person) {
        return [[person name] isEqualToString:@"bob"] ? nil : [person name];
        
    }];
    
    XCTAssertEqual(sortedByName.count, (NSUInteger)5);
    XCTAssertEqual([sortedByName[0] name], @"bob");
    XCTAssertEqual([sortedByName[1] name], @"frank");
    XCTAssertEqual([sortedByName[2] name], @"ian");
    XCTAssertEqual([sortedByName[3] name], @"jim");
    XCTAssertEqual([sortedByName[4] name], @"joe");
}

- (void)testSortDescending
{
    NSArray* input = @[@21, @34, @25];
    
    NSArray* sortedDescendingInput = [input linq_sortDescending];
    
    XCTAssertEqual(sortedDescendingInput.count, (NSUInteger)3);
    XCTAssertEqualObjects(sortedDescendingInput[0], @34);
    XCTAssertEqualObjects(sortedDescendingInput[1], @25);
    XCTAssertEqualObjects(sortedDescendingInput[2], @21);
}

- (void)testSortDescendingWithKeySelector
{
    NSArray* input = [self createTestData];
    
    NSArray* sortedDescendingByName = [input linq_sortDescending:LINQKey(name)];
    
    XCTAssertEqual(sortedDescendingByName.count, (NSUInteger)5);
    XCTAssertEqual([sortedDescendingByName[0] name], @"joe");
    XCTAssertEqual([sortedDescendingByName[1] name], @"jim");
    XCTAssertEqual([sortedDescendingByName[2] name], @"ian");
    XCTAssertEqual([sortedDescendingByName[3] name], @"frank");
    XCTAssertEqual([sortedDescendingByName[4] name], @"bob");
}

- (void)testSortDescendingWithKeySelectorWithNil
{
    NSArray* input = [self createTestData];
    
    NSArray* sortedDescendingByName = [input linq_sortDescending:^id(id person) {
        return [[person name] isEqualToString:@"bob"] ? nil : [person name];
        
    }];
    
    XCTAssertEqual(sortedDescendingByName.count, (NSUInteger)5);
    XCTAssertEqual([sortedDescendingByName[0] name], @"joe");
    XCTAssertEqual([sortedDescendingByName[1] name], @"jim");
    XCTAssertEqual([sortedDescendingByName[2] name], @"ian");
    XCTAssertEqual([sortedDescendingByName[3] name], @"frank");
    XCTAssertEqual([sortedDescendingByName[4] name], @"bob");
}

- (void)testOfType
{
    NSArray* mixed = @[@"foo", @25, @"bar", @33];
    
    NSArray* strings = [mixed linq_ofType:[NSString class]];
    
    XCTAssertEqual(strings.count, (NSUInteger)2);
    XCTAssertEqualObjects(strings[0], @"foo");
    XCTAssertEqualObjects(strings[1], @"bar");
}

- (void)testSelectMany
{
    NSArray* data = @[@"foo, bar", @"fubar"];
    
    NSArray* components = [data linq_selectMany:^id(id string) {
        return [string componentsSeparatedByString:@", "];
    }];
    
    XCTAssertEqual(components.count, (NSUInteger)3);
    XCTAssertEqualObjects(components[0], @"foo");
    XCTAssertEqualObjects(components[1], @"bar");
    XCTAssertEqualObjects(components[2], @"fubar");
}

- (void)testDistinctWithKeySelector
{
    NSArray* input = [self createTestData];
    
    NSArray* peopelWithUniqueAges = [input linq_distinct:LINQKey(age)];
    
    XCTAssertEqual(peopelWithUniqueAges.count, (NSUInteger)4);
    XCTAssertEqual([peopelWithUniqueAges[0] name], @"bob");
    XCTAssertEqual([peopelWithUniqueAges[1] name], @"frank");
    XCTAssertEqual([peopelWithUniqueAges[2] name], @"ian");
    XCTAssertEqual([peopelWithUniqueAges[3] name], @"joe");
}

- (void)testDistinctWithKeySelectorWithNil
{
    NSArray* input = [self createTestData];
    
    NSArray* peopelWithUniqueAges = [input linq_distinct:^id(id person) {
        return [[person age] isEqualToNumber:@25] ? nil : [person age];
    }];
    
    XCTAssertEqual(peopelWithUniqueAges.count, (NSUInteger)4);
    XCTAssertEqual([peopelWithUniqueAges[0] name], @"bob");
    XCTAssertEqual([peopelWithUniqueAges[1] name], @"frank");
    XCTAssertEqual([peopelWithUniqueAges[2] name], @"ian");
    XCTAssertEqual([peopelWithUniqueAges[3] name], @"joe");
}

- (void)testDistinct
{
    NSArray* names = @[@"bill", @"bob", @"bob", @"brian", @"bob"];
    
    NSArray* distinctNames = [names linq_distinct];
    
    XCTAssertEqual(distinctNames.count, (NSUInteger)3);
    XCTAssertEqualObjects(distinctNames[0], @"bill");
    XCTAssertEqualObjects(distinctNames[1], @"bob");
    XCTAssertEqualObjects(distinctNames[2], @"brian");
}


- (void)testAggregate
{
    NSArray* names = @[@"bill", @"bob", @"brian"];
    
    id csv = [names linq_aggregate:^id(id item, id aggregate) {
        return [NSString stringWithFormat:@"%@, %@", aggregate, item];
    }];
    
    XCTAssertEqualObjects(csv, @"bill, bob, brian");
    
    NSArray* numbers = @[@22, @45, @33];
    
    id biggestNumber = [numbers linq_aggregate:^id(id item, id aggregate) {
        return [item compare:aggregate] == NSOrderedDescending ? item : aggregate;
    }];
    
    XCTAssertEqualObjects(biggestNumber, @45);
}

- (void)testFirstOrNil
{
    NSArray* input = [self createTestData];
    NSArray* emptyArray = @[];
    
    XCTAssertNil([emptyArray linq_firstOrNil]);
    XCTAssertEqual([[input linq_firstOrNil] name], @"bob");
}

- (void)testFirtOrNilWithPredicate
{
    Person* jimSecond = [Person personWithName:@"jim" age:@22];
    NSMutableArray* input = [NSMutableArray arrayWithArray:[self createTestData]];
    [input addObject:jimSecond];
    
    id personJim = [input linq_firstOrNil:^BOOL(Person* person) {
        return [person.name isEqualToString:@"jim"] && [person.age isEqualToNumber:@22];
    }];
    
    id personSteve = [input linq_firstOrNil:^BOOL(Person* person) {
        return [person.name isEqualToString:@"steve"];
    }];
    
    XCTAssertEqual(personJim, jimSecond, @"Returned the wrong Jim!");
    XCTAssertNil(personSteve, @"Should not have found Steve!");
    XCTAssertTrue([personJim isKindOfClass:Person.class], @"Should have returned a single object of type Person");
}

- (void)testLastOrNil
{
    NSArray* input = [self createTestData];
    NSArray* emptyArray = @[];
    
    XCTAssertNil([emptyArray linq_lastOrNil]);
    XCTAssertEqual([[input linq_lastOrNil] name], @"joe");
}

- (void)testTake
{
    NSArray* input = [self createTestData];
    
    XCTAssertEqual([input linq_take:0].count, (NSUInteger)0);
    XCTAssertEqual([input linq_take:5].count, (NSUInteger)5);
    XCTAssertEqual([input linq_take:50].count, (NSUInteger)5);
    XCTAssertEqual([[input linq_take:2][0] name], @"bob");
}

- (void)testSkip
{
    NSArray* input = [self createTestData];
    
    XCTAssertEqual([input linq_skip:0].count, (NSUInteger)5);
    XCTAssertEqual([input linq_skip:5].count, (NSUInteger)0);
    XCTAssertEqual([[input linq_skip:2][0] name], @"ian");
}


- (void)testAny
{
    NSArray* input = @[@25, @44, @36];
    
    XCTAssertFalse([input linq_any:^BOOL(id item) {
        return [item isEqualToNumber:@33];
    }]);
    
    XCTAssertTrue([input linq_any:^BOOL(id item) {
        return [item isEqualToNumber:@25];
    }]);
}

- (void)testAll
{
    NSArray* input = @[@25, @25, @25];
    
    XCTAssertFalse([input linq_all:^BOOL(id item) {
        return [item isEqualToNumber:@33];
    }]);
    
    XCTAssertTrue([input linq_all:^BOOL(id item) {
        return [item isEqualToNumber:@25];
    }]);
}

- (void)testGroupBy
{
    NSArray* input = @[@"James", @"Jim", @"Bob"];
    
    NSDictionary* groupedByFirstLetter = [input linq_groupBy:^id(id name) {
        return [name substringToIndex:1];
    }];
    
    XCTAssertEqual(groupedByFirstLetter.count, (NSUInteger)2);
    
    // test the group keys
    NSArray* keys = [groupedByFirstLetter allKeys];
    XCTAssertEqualObjects(@"J", keys[0]);
    XCTAssertEqualObjects(@"B", keys[1]);
    
    // test that the correct items are in each group
    NSArray* groupOne = groupedByFirstLetter[@"J"];
    XCTAssertEqual(groupOne.count, (NSUInteger)2);
    XCTAssertEqualObjects(@"James", groupOne[0]);
    XCTAssertEqualObjects(@"Jim", groupOne[1]);
    
    NSArray* groupTwo = groupedByFirstLetter[@"B"];
    XCTAssertEqual(groupTwo.count, (NSUInteger)1);
    XCTAssertEqualObjects(@"Bob", groupTwo[0]);
}

- (void)testGroupByWithNil
{
    NSArray* input = @[@"James", @"Jim", @"Bob"];
    
    NSDictionary* groupedByFirstLetter = [input linq_groupBy:^id(id name) {
        NSString* firstChar = [name substringToIndex:1];
        return [firstChar isEqualToString:@"J"] ? nil : firstChar;
    }];
    
    XCTAssertEqual(groupedByFirstLetter.count, (NSUInteger)2);
    
    // test the group keys
    NSArray* keys = [groupedByFirstLetter allKeys];
    XCTAssertEqualObjects([NSNull null], keys[1]);
    XCTAssertEqualObjects(@"B", keys[0]);
    
    // test that the correct items are in each group
    NSArray* groupOne = groupedByFirstLetter[[NSNull null]];
    XCTAssertEqual(groupOne.count, (NSUInteger)2);
    XCTAssertEqualObjects(@"James", groupOne[0]);
    XCTAssertEqualObjects(@"Jim", groupOne[1]);
    
    NSArray* groupTwo = groupedByFirstLetter[@"B"];
    XCTAssertEqual(groupTwo.count, (NSUInteger)1);
    XCTAssertEqualObjects(@"Bob", groupTwo[0]);
}

- (void)testToDictionaryWithValueSelector
{
    NSArray<NSString *>* input = @[@"James", @"Jim", @"Bob"];
    
    NSDictionary<NSString *, NSString *>* dictionary = [input linq_toDictionaryWithKeySelector:^id(NSString *item) {
        return [item substringToIndex:1];
    } valueSelector:^id(NSString *item) {
        return [item lowercaseString];
    }];
    
    NSLog(@"%@", dictionary);
    
    // NOTE - two items have the same key, hence the dictionary only has 2 keys
    XCTAssertEqual(dictionary.count, (NSUInteger)2);
    
    // test the group keys
    NSArray* keys = [dictionary allKeys];
    XCTAssertEqualObjects(@"J", keys[0]);
    XCTAssertEqualObjects(@"B", keys[1]);
    
    // test the values
    XCTAssertEqualObjects(dictionary[@"J"], @"jim");
    XCTAssertEqualObjects(dictionary[@"B"], @"bob");
}

- (void)testToDictionaryWithValueSelectorWithNil
{
    NSArray<NSString *>* input = @[@"James", @"Jim", @"Bob"];
    
    NSDictionary* dictionary = [input linq_toDictionaryWithKeySelector:^id(NSString *item) {
        NSString* firstChar = [item substringToIndex:1];
        return [firstChar isEqualToString:@"J"] ? nil : firstChar;
    } valueSelector:^id(NSString *item) {
        NSString* lowercaseName = [item lowercaseString];
        return [lowercaseName isEqualToString:@"bob"] ? nil : lowercaseName;
    }];
    
    NSLog(@"%@", dictionary);
    
    // NOTE - two items have the same key, hence the dictionary only has 2 keys
    XCTAssertEqual(dictionary.count, (NSUInteger)2);
    
    // test the group keys
    NSArray* keys = [dictionary allKeys];
    XCTAssertEqualObjects([NSNull null], keys[1]);
    XCTAssertEqualObjects(@"B", keys[0]);
    
    // test the values
    XCTAssertEqualObjects(dictionary[[NSNull null]], @"jim");
    XCTAssertEqualObjects(dictionary[@"B"], [NSNull null]);
}

- (void)testToDictionary
{
    NSArray<NSString *>* input = @[@"Jim", @"Bob"];
    
    NSDictionary* dictionary = [input linq_toDictionaryWithKeySelector:^id(NSString *item) {
        return [item substringToIndex:1];
    }];
    
    XCTAssertEqual(dictionary.count, (NSUInteger)2);
    
    // test the group keys
    NSArray* keys = [dictionary allKeys];
    XCTAssertEqualObjects(@"J", keys[0]);
    XCTAssertEqualObjects(@"B", keys[1]);
    
    // test the values
    XCTAssertEqualObjects(dictionary[@"J"], @"Jim");
    XCTAssertEqualObjects(dictionary[@"B"], @"Bob");
}



- (void) testCount
{
    NSArray<NSNumber *>* input = @[@25, @35, @25];
    
    NSUInteger numbersEqualTo25 = [input linq_count:^BOOL(NSNumber *item) {
        return [item isEqualToNumber:@25];
    }];
    
    XCTAssertEqual(numbersEqualTo25, (NSUInteger)2);
}

- (void) testConcat
{
    NSArray<NSNumber *>* input = @[@25, @35];
    
    NSArray* result = [input linq_concat:@[@45, @55]];
    
    XCTAssertEqual(result.count, (NSUInteger)4);
    XCTAssertEqualObjects(result[0], @25);
    XCTAssertEqualObjects(result[1], @35);
    XCTAssertEqualObjects(result[2], @45);
    XCTAssertEqualObjects(result[3], @55);
}

- (void) testReverse
{
    NSArray* input = @[@25, @35];
    
    NSArray* result = [input linq_reverse];
    
    XCTAssertEqual(result.count, (NSUInteger)2);
    XCTAssertEqualObjects(result[0], @35);
    XCTAssertEqualObjects(result[1], @25);
}

- (void) testSum
{
    NSArray* input = @[@25, @35];
    
    NSNumber* sum = [input linq_sum];
    XCTAssertEqualObjects(sum, @60);
}

@end
