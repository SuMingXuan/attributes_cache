### 说明

从缓存里面读取数据，如果缓存失效则去数据库里面读取

### 示例

缓存 `user.rb` 表里面的name数据

```ruby
class User < ApplicationRecord
  include AttributesCache

  fetch_attributes :id, :name
end
```

### 调用方法

缓存默认失效时间为 `30` 秒，可自定义失效时间 `fetch_attribute(expires_in: 1.day)`

```ruby
user = User.create(id: 1, name: 'xiaoming')
# 会从数据库里面读取
user.fetch_id #=> 1
# 会从缓存里面读取
user.fetch_id #=> 1
# 会从数据库里面读取
user.fetch_name #=> 'xiaoming'
# 会从缓存里面读取
user.fetch_name #=> 'xiaoming'
```