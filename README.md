# Remove Transformer
<a href="https://pub.dartlang.org/packages/remove_transformer"><img src="https://img.shields.io/pub/v/remove_transformer.svg" alt="Pub" /></a>

A simple dart transformer that removes content from files when building in release mode.

## Usage
Add the dependency and transformer to your `pubspec.yaml`:

    dev_dependencies:
        remove: ^1.0.0
     
    transformers:
    - remove

The order of the transformers determines the order they are run so `remove`
will most likely need to be toward the top. The transformer only runs in `release` mode.

The transformer will remove content from files when it comes across the following strings.
- `remove:line` - removes the entire line
- `remove:start` / `remove:end` - removes all lines from `remove:start` to `remove:end`
including the entirety of the start and end lines

## Examples
### Remove a line

    Debug content // remove:line
    Hello World

### Remove a block

    // remove:start
    Some
    long
    multiline
    debug content
    //remove:end
     
    Hello World

The following is an identical representation.

    Some // remove:start
    long
    multiline
    debug content //remove:end
     
    Hello World

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
