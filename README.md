# Authorize

Authorize provides a simple authorization scheme for Ruby.

```ruby
class Post
  include Authorize
end

# We have a User class, so we must define a UserPolicy class:
class PostPolicy
  def can_create?(current_user)
    # since the base class is Post, we have the 'post' instance variable:
    if post.owner == current_user
      yes
    else
      no because: 'user is not the owner of the post'
    end
  end
end

# current_user is the authenticated user
post.authorize current_user,  to: :edit # true
post.authorize! current_user, to: :edit # false

post.authorize! current_user, to: :edit
post.authorize! current_user, to: :edit # raises Authorize::Unauthorized: can not perform the update action because user is not the owner of the post
```

You can also have policies that doesn't make use of a current user:

```ruby
class PostPolicy
  def can_comment?
    if post.public?
      yes
    else
      no because: 'post is not public'
    end
  end
end

post.authorize! to: :comment
```

And pass custom parameters to your policy methods:

```ruby
class PostPolicy
  def can_create?(another_user, foo:)
    if another_user.admin? && foo == 'baz'
      yes
    else
      no 'user is not admin or foo is not baz'
    end
  end
end

post.authorize! another_user, to: :create, foo: 'baz'
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
