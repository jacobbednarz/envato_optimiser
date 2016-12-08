# Envato Optimiser

A gem to make it easier to identify potential issues on your Envato item pages.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'envato_optimiser'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install envato_optimiser
```

## Usage

To use this you need to first instantiate a new instance of
`EnvatoOptimiser::Item` and pass in the full URI of the item page. For
example:

```rb
item = EnvatoOptimiser::Item.new('https://themeforest.net/item/avada-responsive-multipurpose-theme/2833226')
```

Once you have this setup, you can run the `check!` method to perform
the tests.

```rb
item.check!
```

This will return a hash with the results of the check. Depending on the
number of images found in the item page (and the speed the origin server
can process requests) this can take a minute or so to complete.
