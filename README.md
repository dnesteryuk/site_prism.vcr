# SitePrism.Vcr

[![Code Climate](https://codeclimate.com/github/dnesteryuk/site_prism.vcr.png)](https://codeclimate.com/github/dnesteryuk/site_prism.vcr)
[![Build Status](https://secure.travis-ci.org/dnesteryuk/site_prism.vcr.png?branch=master)](https://travis-ci.org/dnesteryuk/site_prism.vcr)
[![Coverage Status](https://coveralls.io/repos/dnesteryuk/site_prism.vcr/badge.png)](https://coveralls.io/r/dnesteryuk/site_prism.vcr)
[![Dependency Status](https://gemnasium.com/dnesteryuk/site_prism.vcr.png)](https://gemnasium.com/dnesteryuk/site_prism.vcr)

The purpose of this gem is to give an easy way for integrating [SitePrism](https://github.com/natritmeyer/site_prism) (it is Page Object Model DSL for Capybara) and [VCR](https://github.com/vcr/vcr) (it is a powerful tool for recording and stubbing HTTP interactions).

Such integration allows you to write acceptance tests more easily since you receive handy tool for managing VCR cassettes. Those cassettes can be easily linked with SitePrism elements (in fact, Capybara elements since SitePrism doesn't have own elements). Afterwards those linked cassettes can be used for stubbing external API responses while doing actions (click, change etc) over an element that cassettes are defined for.

## Features

  * Links VCR cassettes with SitePrism elements.
  * Links VCR cassettes with SitePrism pages.
  * Applies VCR cassettes on any event (click, change, blur etc).
  * Applies VCR cassettes on page loading.
  * Defines a waiter to wait on a result of an action.
  * Allows to redefine default VCR cassettes (cassettes which were specified while describing a SitePrism element or a SitePrism page).
  * Allows to redefine a default waiter (a waiter which was specified while describing a SitePrism element or a SitePrism page).

## Installation

Add this line to your application's Gemfile:

    gem 'site_prism.vcr'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install site_prism.vcr

## Usage

### Linking VCR cassettes with SitePrism elements

To link VCR cassettes with SitePrism elements, you have to use `element_with_vcr` instead of `element` method of SitePrism for specifying elements:

```ruby
class ProductsPage < SitePrism::Page
  element_with_vcr \
    :car_details_link,
    '#car_details' do
      fixtures ['ford', 'cars/ford_features']
    end
end
```

`fixtures` helper method is used for defining VCR cassettes. All cassettes are taken from a path which you have defined in `cassette_library_dir` configuration option of VCR. Please, refer to [documentation](https://relishapp.com/vcr/vcr/v/2-5-0/docs/configuration/cassette-library-dir) of VCR to get more info about configuration options.

You can specify cassettes for already defined elements, if your page inherits another one:

```ruby
class TransportPage < SitePrism::Page
  element :transport_details_link, '#car_details'
end

class CarsPage < TransportPage
  link_vcr_with_element :transport_details_link do
    fixtures ['cars/ford']
  end
end
```

#### Path helper method

In case you have a lot of cassettes which are stored in some subdirectory, you can use `path` helper method to specify a list of such cassettes:

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

The `path` helper method can be used a few times in a block to define cassettes.
The code above is identical to:

```ruby
class ProductsPage < SitePrism::Page
  element_with_vcr \
    :car_details_link,
    '#car_details' do
      fixtures [
        'cars/small/ford',
        'cars/small/ford_features',
        'cars/small/prices',
        'offerings/used_cars',
        'offerings/new_cars'
      ]
    end
end
```

#### Home path helper method

There is a possibility to define a home path to cassettes which are applied for a particular element:

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

Here `~` points to `cars/small` directory, all cassettes will be taken from this directory. The previous example is identical to this one:

```ruby
class ProductsPage < SitePrism::Page
  element_with_vcr \
    :car_details_link,
    '#car_details' do
      fixtures [
        'cars/small/ford',
        'cars/small/ford_features',
        'cars/small/prices'
      ]
    end
end
```

Home path is a very useful while redefining default cassettes (It is described below).

Also, you can use a defined home path with the `path` helper method:

```ruby
class ProductsPage < SitePrism::Page
  element_with_vcr \
    :car_details_link,
    '#car_details' do
      home_path 'cars/small'

      path '~/', ['ford', 'ford_features', 'prices']
    end
end
```

Sometimes you need to specify a cassette which lies in a parent directory of a home path, in this case you can use a relative path with a home path:

```ruby
class ProductsPage < SitePrism::Page
  element_with_vcr \
    :car_details_link,
    '#car_details' do
      home_path 'cars/small'

      fixture ['~/../ford']
    end
end
```

#### Shortcut path helper method

The home path helper method helps you to avoid duplication while specifing cassettes. There is a `shortcut_path` method which does the same, but it can be used to define shorcuts for any path:

```ruby
class ProductsPage < SitePrism::Page
  element_with_vcr \
    :car_details_link,
    '#car_details' do
      shortcut_path 'cars', 'cars/small'

      fixture [':cars/ford']
    end
end
```

Here `:cars` points to the `cars/small` directory.

Everything described for the `home_path` helper method works for the `shortcut_path` method as well.

### Applying VCR cassettes on click

Cassettes can be applied on a click event:

```ruby
@products_page.car_details_link.click_and_apply_vcr
```

This code applies VCR cassettes which were specified while defining a SitePrism element. But, there is also possibility to override them:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  fixtures ['cars/volvo']
end
```

This code completely overrides default cassettes, but only for this one particular click action. If you want to apply default cassettes again after this code, just use code without specifying custom cassettes:

```ruby
@products_page.car_details_link.click_and_apply_vcr do # overrides all default cassettes
  fixtures ['cars/volvo']
end

@products_page.car_details_link.click_and_apply_vcr # uses default cassettes again
```

Also, there is possibility to add new cassettes instead of overriding default one:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  fixtures ['cars/volvo']
  union # makes this library add new cassettes to a list with default cassettes
end
```

Similar to defining SitePrism elements with VCR cassettes, you can use `path` helper method while applying fixtures:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  path 'cars/small', ['volvo', 'volvo_features', 'prices']
end
```

Also, if you have specified a home path while defining a SitePrism element, you can use it here:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  fixtures ['~/volvo', '~/volvo_features', '~/prices']
end
```

or

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  path '~/', ['volvo', 'volvo_features', 'prices']
end
```

Home path can be defined while applying Vcr:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  home_path 'cars/volvo'

  path '~/', ['volvo', 'volvo_features', 'prices']
end
```

#### Exchange default cassettes

There may be a situation when you need to exchange some default cassette for one specific test. It is a very easy to do:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  exchange 'volvo', 'ford'
end
```

When you use a home path:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  exchange '~/volvo', '~/ford'
end
```

Also, multiple cassettes can be exchanged:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  exchange ['~/volvo', '~/ford'], ['~/mazda', '~/toyota']
end
```

### Waiters

Waiters are very important part of this gem (actually, waiters are part of SitePrism gem, but they are used widely here). When we do some action and that action causes a few HTTP interactions we have to wait for a result of them before expecting something on a page. The good approach is to wait for some visibility or invisibility of an element. For example, you have a list of products when you click on a button to show details of some product, you may wait until loading indicator which may be shown on a details page of a product disappears. Capybara already waits for an element to appear, but it hasn't any possibility to wait for invisibility of an element, SitePrism has this capability and it is very useful.

There is reason why you should use them when you use SitePrism.Vcr. If you specify a waiter while describing SitePrism elements or applying VCR cassettes, SitePrism.Vcr will know when the inserted cassettes should be ejected from Vcr to avoid a situation when some unexpected cassette is applied.

There are 2 ways for defining a waiter. When you define SitePrism elements:

```ruby
class ProductsPage < SitePrism::Page
  element_with_vcr \
    :car_details_link,
    '#car_details' do
      fixtures ['ford', 'cars/ford_features']
      waiter &:wait_until_loading_indicator_invisible # our code will wait until the loading indicator has disappeared from a page
    end
end
```

The second way is to set it while applying Vcr cassettes:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  fixtures ['cars/volvo']
  waiter &:wait_until_loading_indicator_invisible
end
```

*Note:* Using the second way, you can override a default waiter which was specified while defining SitePrism element.

In this case once we meet an expectation defined in a waiter, Vcr cassettes will be ejected and you will avoid issues with mixing unexpected cassettes. If you don't specify a waiter, you have to eject them manually:

```ruby
after do
  SPV::Helpers.eject_all_cassettes
end
```

or directly in the test:

```ruby
it 'displays details of a product' do
  products_page.products.first.show_details_btn.click_and_apply_vcr
  products_page.details.should have_content('Volvo')

  SPV::Helpers.eject_all_cassettes

  products_page.products.second.show_details_btn.click_and_apply_vcr
  products_page.details.should have_content('Ford')
end
```

*Note:* Waiters must be defined in a block. In a block you have access to an instance of class where you define elements.

There may be situation when you don't need a waiter to eject all cassettes. In this case you can pass an additional option to a waiter to disable ejecting all cassettes:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  fixtures ['cars/volvo']
  waiter(eject_cassettes: false) { self.wait_until_loading_indicator_invisible }
end
```

The same thing can be defined for a default waiter.

In case you need to change only options defined for a default waiter, but you don't need to change a waiter, you can use `waiter_options` helper method:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  waiter_options(eject_cassettes: false)
end
```

### Applying VCR cassettes on any event

There may be a situation when you need to apply cassettes for some custom event rather than for a click event. It may be a change event for a select box or a drag-and-drop event for a list or a blur event for an input element. SitePrism.Vcr gem provides a way to archive such goal:

```ruby
@products_page.cars_dropdown.shift_event{
  set 'Ford'
}.apply_vcr # uses default fixtures defined for this element
```

or if you need to use another cassettes:

```ruby
@products_page.cars_dropdown.shift_event{
  set 'Ford'
}.apply_vcr do
  fixtures ['cars/ford/prices']
end
```

The block which is passed to `shift_event` method is executed in a context of an element, it means any method of [Capybara::Node::Element](http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Element) object can be used there. Similar to `click_and_apply_vcr` method, you can override cassettes, add new cassettes, use `path` helper method while applying cassettes and `home_path` helper method specified while defining a SitePrism element.

### Linking and applying VCR cassettes with SitePrism pages

External HTTP interactions may be done on page loading as well. This gem supports capability to apply Vcr cassettes on page loading. To define default cassettes you have to use the `vcr_options_for_load` class method:

```ruby
class ProductsPage < SitePrism::Page
  vcr_options_for_load do
    fixtures ['max']
  end
end
```

Everything described above about defining cassettes for SitePrism elements is true for defining cassettes for pages.

Applying cassettes is almost the same as it is shown for SitePrism elements:

```ruby
page.load_and_apply_vcr do
  fixtures ['max', 'felix']

  waiter &:wait_for_max_and_felix
end
```

All arguments passed to the `load_and_apply_vcr` method will be passed to the `load` method of SitePrism. It allows to change an url of the being loaded page:

```ruby
page.load_and_apply_vcr(cat: 'tom') do
  fixtures ['max', 'felix']

  waiter &:wait_for_max_and_felix
end
```

In this case, SitePrism will alter an url and it will look like:

```ruby
http://localhost/cats/tom
```

#### Altering default cassettes in sub-classes of pages

There is a possibility to alter default cassettes defined for a parent page class. It can be done with the `adjust_parent_vcr_options` method:

```ruby
  class BasePage < SitePrism::Page
    vcr_options_for_load do
      fixtures ['cars', 'products']

      waiter &:wait_for_cars_list
    end
  end

  class CarsPage < BasePage
    adjust_parent_vcr_options do
      fixtures ['features']

      waiter &:wait_for_cars_and_features_list

      union # if it is omitted, the cassettes defined in this block will
      # replace the cassettes defined in the parent page class
    end
  end
```  

In this case `cars`, `products`, `features` cassettes will be applied while loading the cars page. 

Any helper methods can be used in a block passed to the `adjust_parent_vcr_options` method.

### Applying VCR cassettes in sections

There isn't any method which you can use to apply VCR cassettes with sections. Actually, it is needless, because usually we do actions over elements. But, if you need such functionality for sections, you already have such possibility:

```ruby
  class ListSection < SitePrism::Section
    # elements here

    def initialize(parent, element)
      super

      @applier = SPV::Applier.new(self)
    end

    def show_more
      @applier.shift_event{
        self.scroll_down
      }.apply_vcr do
        fixtures ["storages/more_storages"]

        waiter { self.wait_until_loading_indicator_invisible }
      end
    end
  end
```

In this example we apply VCR cassettes after scrolling down the content in a section. 

It may be useful to stub the API request produced by an event which isn't directly related to any element rather it related to overall elements in a section.

### Using Vcr options for cassettes

Vcr provides number of options which can be used for cassettes. For example, you may [pass ERB into cassettes](https://relishapp.com/vcr/vcr/v/2-5-0/docs/cassettes/dynamic-erb-cassettes). This gem doesn't bother you use any options for Vcr cassettes. If you want to do so, you have to use a hash instead of a cassette name:

```ruby
class ProductsPage < SitePrism::Page
  element_with_vcr \
    :car_details_link,
    '#car_details' do
      home_path 'cars/small'

      path '~/', [{fixture: 'ford', options: {erb: {amount: 109} } }, 'ford_features', 'prices']
    end
end
```

It works with any kind of helper methods where you list names of cassettes, even with the `exchange` helper method:

```ruby
@products_page.car_details_link.click_and_apply_vcr do
  exchange '~/volvo', {fixture: '~/toyota', options: {erb: {amount: 1000} } }
end
```

## Examples

The simple example of using this gem you can find [here](https://github.com/dnesteryuk/site_prism.vcr_example)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/nestd/site_prism.vcr/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

