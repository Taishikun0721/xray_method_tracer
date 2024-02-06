# XrayMethodTracer

X-Ray SDK for Rubyを使用してmodelやserviceなどに書いたメソッドを計装するための仕組み

## Getting Started
[aws-xray-sdk-ruby](https://github.com/aws/aws-xray-sdk-ruby)

1. Add this line to your application's Gemfile:

```
gem 'xray_method_tracer’
```

And then execute:
```
bundle install
```

If you are not using aws-xray-sdk-ruby yet, please also add this line:

```
gem "aws-xray-sdk"
```

## Ussage

Check the [Getting Started](https://github.com/Taishikun0721/xray_method_tracer/wiki/Getting-Started) pages.

1.. `/config/initializers` 配下で下記のスクリプトを設定する

``` ruby xray_method_tracer.rb
require 'xray_method_tracer'

Rails.application.config.after_initialize do
  Rails.application.eager_load!

  base_klasses = [BaseService, BaseUsecase]
  klasses = [Human, Bird, Fish]
  XRayMethodTracer.new(base_klasses: base_klasses, klasses: klasses).trace
end
```

## Testing

```
bundle exec rspec
```

## Lint
```
bundle exec rubocop
```


TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/xray_method_tracer.
