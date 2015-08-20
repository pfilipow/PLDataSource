# PLDataSource

[![CI Status](http://img.shields.io/travis/Hirad Motamed/PLDataSource.svg?style=flat)](https://travis-ci.org/Hirad Motamed/PLDataSource)
[![Version](https://img.shields.io/cocoapods/v/PLDataSource.svg?style=flat)](http://cocoapods.org/pods/PLDataSource)
[![License](https://img.shields.io/cocoapods/l/PLDataSource.svg?style=flat)](http://cocoapods.org/pods/PLDataSource)
[![Platform](https://img.shields.io/cocoapods/p/PLDataSource.svg?style=flat)](http://cocoapods.org/pods/PLDataSource)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

A series of UITableViewDataSource classes to allow you to slice and dice your data any which way you need.

The `PLDataSource` class provides a unified interface for all table view data sources. Various concrete subclasses provide easily-customizable behaviour. Create your own data sources by subclassing one of concrete implementations and overriding `tableView:cellForRowAtIndexPath:`.

All data sources inform their delegates of changes using the `PLDataSourceDelegate` protocol.

### `PLBasicDataSource`

A subclass of `PLDataSource` that simply takes an array of items and uses it to populate a single-section table view.

### `PLFetchedResultsDataSource`

A sublcass of `PLDataSource` that wraps an `NSFetchedResultsController`. Your custom subclass should override `defaultFetchRequest`.

### `PLMergedDataSource`

A subclass that merges the results of several other data sources. (TODO: Add more here)

### `PLDirectoryContentDataSource`

A subclass of `PLDataSource` that observes the content of a particular directory and populates a single-section table view with the results.

## Requirements

## Installation

PLDataSource is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "PLDataSource"
```

## Author

Hirad Motamed, hirad@pendarlabs.com

## License

PLDataSource is available under the MIT license. See the LICENSE file for more info.

