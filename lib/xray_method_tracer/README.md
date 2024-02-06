## XRayMethodTracers
### 概要
X-Ray SDK for Rubyを使用してmodelやserviceなどに書いたメソッドを計装するための仕組み

### 依存関係
[aws-xray-sdk-ruby](https://github.com/aws/aws-xray-sdk-ruby)


### 使用方法
1. /lib配下に`xray_method_tracers`のディレクトリを設置して、application.rbで読み込む

``` ruby config/application.rb
  # lib配下を事前に読み込むように設定
  config.autoload_paths += %W[#{config.root}/lib]
  config.eager_load_paths << Rails.root.join('lib')
```


2. `/config/initializers` 配下で初期化する

``` ruby xray_method_tracer.rb
require 'xray_method_tracers/method_tracer'

Rails.application.config.after_initialize do
  unless Rails.env.test?
    MethodTracer.trace_all_methods!
  end
end

```

サーバーを起動して、メソッドを実行すると該当するメソッドのトレースを取得できます
``` bash
bundle exec rails s
```
