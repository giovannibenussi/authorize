# Authorize

Authorize provides a simple authorization scheme for Ruby.

```ruby
class Post
  include Authorize
end

# We have a User class, so we must define a UserPolicy class:
class PostPolicy
  def can_create?
    yes
  end

  def can_delete?
    no because: 'posts can not be deleted'
  end
end

post.authorize? to: :create # true
post.authorize? to: :delete # false

post.authorize! to: :create # does nothing

# raises Authorize::Unauthorized: can not perform
# the delete action because posts can not be deleted
post.authorize! to: :delete
```

You can provide custom variables to a method:

```ruby
class PostPolicy
  def can_create?(current_user)
    if current_user.admin?
      yes
    else
      no because: 'user is not admin'
    end
  end
end

post.authorize? admin_user, to: :create # true
post.authorize? guest_user, to: :create # false
```

Named parameters are also allowed!

```ruby
class PostPolicy
  def can_create?(foo:)
    if foo == 'baz'
      yes
    else
      no because: 'foo is not baz'
    end
  end
end

post.authorize! to: :create, foo: 'baz' # true

post.authorize! to: :create, foo: 'not-baz'
# raises Authorize::Unauthorized: can not perform
# the create action because foo is not baz
```

If you need fine-control over the response you could also access to it directly:

```ruby
response = post.is_allowed? to: :create, foo: 'baz'
if response.can?
  post.create!
else
  raise "You are not authorized to create a post because #{response.reason}"
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'authorize'
```

Or install it yourself as:

```ruby
gem install authorize
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/authorize. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Authorize project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/authorize/blob/master/CODE_OF_CONDUCT.md).
