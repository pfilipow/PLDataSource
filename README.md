# PLDataSource

[![CI Status](http://img.shields.io/travis/Hirad Motamed/PLDataSource.svg?style=flat)](https://travis-ci.org/PendarLabs/PLDataSource)
[![Version](https://img.shields.io/cocoapods/v/PLDataSource.svg?style=flat)](http://cocoapods.org/pods/PLDataSource)
[![License](https://img.shields.io/cocoapods/l/PLDataSource.svg?style=flat)](http://cocoapods.org/pods/PLDataSource)
[![Platform](https://img.shields.io/cocoapods/p/PLDataSource.svg?style=flat)](http://cocoapods.org/pods/PLDataSource)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

A series of UITableViewDataSource classes to make it easy to slice and dice your data any which way you need.

The `PLDataSource` class provides a unified interface for all table view data sources. The two concrete subclasses provide easily-customizable behaviour (one for displaying simple lists and another for using an `NSFetchedResultsController`). Create your own data sources by subclassing one of concrete implementations and overriding `tableView:configureCell:forObject:atIndexPath:` along with `registeredCellReuseIdentifierForRowAtIndexPath:`.

All data sources inform their delegates of changes using the `PLDataSourceDelegate` protocol. `PLTableViewController` conforms to this protocol. Make your view controllers inherit from it and override `initializeDataSources` to get all data source functionality for free.

### `PLBasicDataSource`

A subclass of `PLDataSource` that simply takes an array of items and uses it to populate a single-section table view. Changes to this array can be intelligently animated, assuming the objects respond to `isEqual:` appropriately.

### `PLFetchedResultsDataSource`

A sublcass of `PLDataSource` that wraps an `NSFetchedResultsController`. Your custom subclass should override `defaultFetchRequest`.

### `PLMergedDataSource`

A subclass of `PLDataSource` that merges the results of several other data sources. Each of its "child" data sources is assumed to manage a single section in a table view. This is handy if you use Core Data and would like to use `NSFetchedResultsController` to show different entities in different sections of a table view.

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

