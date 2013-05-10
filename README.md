# SitePrism.Vcr

[![Code Climate](https://codeclimate.com/github/nestd/site_prism.vcr.png)](https://codeclimate.com/github/nestd/site_prism.vcr)

The purpose of this gem is to give an easy way for integrating [SitePrism](https://github.com/natritmeyer/site_prism) (it is Page Object Model DSL for Capybara) and [VCR](https://github.com/vcr/vcr) (it is a powerful tool for recording and stubbing HTTP interactions).

Such integration allows you to write acceptance tests more easily since you receive handy tool for managing VCR cassettes. Those cassettes can be easily linked with SitePrism elements (in fact, Capybara elements since SitePrism doesn't have own elements). Afterwards those linked cassettes can be used for stubbing external API responses while clicking on a element that cassettes are defined for.

## Features

  * Links VCR cassettes with SitePrism elements while describing SitePrism elements.
  * Applies VCR cassettes while clicking on an element.
  * Defines a waiter which will be used for waiting until an expected element is on a page or until an expected element has disappeared from a page (It is very helpful when a few external API requests are being executed after clicking on an element).
  * Allows to redefines default VCR cassettes (cassettes which were specified while describing a SitePrism element) while clicking on an element.
  * Allows to redefine a default waiter (a waiter which was specified while describing a SitePrism element) while clicking on an element.

## Installation

Add this line to your application's Gemfile:

    gem 'site_prism.vcr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install site_prism.vcr

## Usage

### Linking VCR cassettes with SitePrism elements

To link VCR cassettes with SitePrism elements, you have use `element_with_vcr` instead of `element` method of SitePrism for specifying elements.

The simplest way is:

```ruby
class ProductsPage < SitePrism::Page
  element_with_vcr \
    :car_details_link,
    '#car_details',
    fixtures: ['car', 'car/features']
end    
```

Also, you can use a block which gives you some additional options:

```ruby
class ProductsPage < SitePrism::Page
  element_with_vcr \
    :car_details_link,
    '#car_details' do
      fixtures ['ford', 'cars/ford_features']
    end
end    
```

In case you have a lot of cassettes which are stored in some subdirectory, there is a more better way for defining fixtures:

```ruby
class ProductsPage < SitePrism::Page
  element_with_vcr \
    :car_details_link,
    '#car_details' do
      path 'cars/small', ['ford', 'ford_features', 'prices']
      path 'offerings',  ['used_cars', 'new_cars']
    end
end    
```

The `path` helper method can be used a few times in the block to define cassettes. The code above is identical to:

```ruby
class ProductsPage < SitePrism::Page
  element_with_vcr \
    :car_details_link,
    '#car_details',
    fixtures: [
      'cars/small/ford', 
      'cars/small/ford_features', 
      'cars/small/prices',
      'offerings/used_cars',
      'offerings/new_cars'
    ]
end    
```

As you can see by using a block you can define fixtures much more easily and it is a preferable way in some cases.

Also, there is a possibility to define a home path for cassettes which are applied for a particular element:

```ruby
class ProductsPage < SitePrism::Page
  element_with_vcr \
    :car_details_link,
    '#car_details' do
      home_path 'cars/small'

      fixtures ['~/ford', '~/ford_features', '~/prices']
    end
end    
```

If some fixture name begins with `~/`, it means that a defined home path will be applied to such fixture. It is a very useful while redefining cassettes (It is described below).

### Applying VCR cassettes

Now only after clicking on an element cassettes can be applied:

```ruby
@products_page.car_details_link.click_and_apply_vcr
```

This code applies VCR cassettes which were specified while describing a SitePrism element. But, there is also possibility to override them:

```ruby
@products_page.car_details_link.click_and_apply_vcr(['cars/volvo'])
```

This code completely overrides default cassettes, but only for this click action. If you want to apply default cassettes again after this code, just use code without specifying custom cassettes:

```ruby
@products_page.car_details_link.click_and_apply_vcr(['cars/volvo']) # overrides default cassettes
@products_page.car_details_link.click_and_apply_vcr # uses default cassettes again
```

Also, there is possibility to add new cassettes instead of overriding default one:

```ruby
@products_page.car_details_link.click_and_apply_vcr(['cars/volvo'], :union)
```

Similar to describing SitePrism elements with VCR cassettes, you can use a block:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  fixtures ['cars/volvo']
end
```

or with `path` helper:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  path 'cars/small', ['volvo', 'volvo_features', 'prices']
end
```

also you can make the library apply additional cassettes instead of overriding default one:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  path 'cars/small', ['volvo', 'volvo_features', 'prices']
  union
end
```

Also, if you have specified a home path while describing a SitePrism element, you can use it here:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  fixtures ['~/volvo', '~/volvo_features', '~/prices']
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
