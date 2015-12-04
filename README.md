# UBICoreData

[![CI Status](https://travis-ci.org/ubiregiinc/UBICoreData.svg?branch=master&style=flat)](https://travis-ci.org/ubiregi-inc/UBICoreData)
[![Version](https://img.shields.io/cocoapods/v/UBICoreData.svg?style=flat)](http://cocoapods.org/pods/UBICoreData)
[![License](https://img.shields.io/cocoapods/l/UBICoreData.svg?style=flat)](http://cocoapods.org/pods/UBICoreData)
[![Platform](https://img.shields.io/cocoapods/p/UBICoreData.svg?style=flat)](http://cocoapods.org/pods/UBICoreData)

UBICoreData is based on [NLCoreData](https://github.com/jksk/NLCoreData).
This library can use more than one store.

## Requirements
iOS8.0 or later  
Xcode7.1 or later  
ARC

## Usage

```objc
// Make data store
NSURL *storeURL = <Your Store URL>
UBICoreDataStore *dataStore = [[UBICoreDataStore alloc] initWithModelName:@"YourModelName" storeURL:storeURL];

NSManagedObjectContext *context = dataStore.mainContext;

Person *person = [Person insertInContext:context];
person.name = @"Ubi Taro";

Person *samePerson = [Person fetchSingleInContext:context predicate:@"name == 'Ubi Taro'"];

// Save to persistent store
[context saveToPersistentStore];
```

## Installation

UBICoreData is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'UBICoreData'
```

