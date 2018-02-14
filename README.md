# Remove Transformer
[![Pub](https://img.shields.io/pub/v/remove_transformer.svg)](https://pub.dartlang.org/packages/remove_transformer)

A simple dart transformer that removes content from files when building in release mode.

## Usage
Add the dependency and transformer to your `pubspec.yaml`:

    dev_dependencies:
      remove_transformer: ^1.0.0
     
    transformers:
    - remove_transformer

The order of the transformers determines the order they are run so `remove_transformer`
will most likely need to be toward the top. The transformer only runs in `release` mode.

The transformer will remove content from files when it comes across the following strings.
- `remove:line` - removes the entire line
- `remove:start` / `remove:end` - removes all lines from `remove:start` to `remove:end`
including the entirety of the start and end lines

## Examples
### Remove a line

    String content = 'Debug content'; // remove:line

### Remove a block

    // remove:start
    String str1 = 'Hello World';
    String str2 = 'Goodnight Moon';
    String str3 = 'err';
    //remove:end

The following is an identical representation.

    String str1 = 'Hello World'; // remove:start
    String str2 = 'Goodnight Moon';
    String str3 = 'err'; //remove:end

### Change variables

    // remove:start
    String mode = 'debug';
    String greeting = 'Hello World';
    // remove:end
     
    /* remove:line
    String mode = 'release';
    String greeting = 'Hello';
    remove:line */

or

    // remove:start
    String mode = 'debug';
    String greeting = 'Hello World';
    /* remove:end
    String mode = 'release';
    String greeting = 'Hello';
    remove:line */

In `debug` mode `mode` and `greeting` will have the values `'debug'` and `'Hello World'`.
In `release` mode `mode` and `greeting` will have the values `'release'` and `'Hello'`.
