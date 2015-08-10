# ActionMailer::Markdown

A different take on using ActionMailer, Markdown and I18n.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'actionmailer-markdown'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install actionmailer-markdown

## Usage

Imagine that you have a mail named `UserMailer#welcome`. Instead of manually defining your subjects like the following, you can create the subject by defining the `user_mailer.welcome.subject` translation.

```ruby
# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  def welcome(email)
    mail to: email, subject: 'Welcome to Myapp'
  end
end
```

```yaml
# config/locales/en.yml
en:
  user_mailer:
    welcome:
      subject: Welcome to my app
```

Since I really like defining everything I can in I18n files, I always extend this behavior to the message's body, through the `user_mailer.welcome.body` translation.

```yaml
# config/locales/en.yml
en:
  user_mailer:
    welcome:
      subject: Welcome to my app
      body: |
        This is an e-mail body.

        --
        Myapp team
```

Did you notice that `|`? That allows YAML strings to be multiline. And on your e-mail class you can do something like this:

```ruby
# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  def welcome(email)
    mail to: email, body: I18n.t('user_mailer.welcome.body')
  end
end
```

And if you want to render HTML and text-plain from this string, you may have to do something like this (Markdown class not shown).

```ruby
# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  def welcome(email)
    message = I18n.t('user_mailer.welcome.body')

    mail to: email do |format|
      format.text { render plain: message }
      format.html { render html: Markdown.html(message).html_safe }
    end
  end
end
```

This idea is really nice, but you have too much things to deal with. Not anymore!

With ActionMailer::Markdown you can just define your mailer action like this:

```ruby
# app/mailers/user_mailer.rb
class UserMailer < ApplicationMailer
  def welcome(email)
    mail to: email
  end
end
```

That's right! This gem automatically uses `user_mailer.welcome.{subject,body}` from your translation files. And the best part: it evens supports Markdown.

### Passing variables

You're likely to pass in variables to your messages. To do this, just define instance variables. Imagine you want to parse the user's name on your subject and message. Let's suppose you have your translation file defined like this:

```yaml
en:
  user_mailer:
    welcome:
      subject: 'Welcome to Myapp, %{name}'
      body: |
        Hello, %{name}. And welcome to Myapp.
```

This is what your mailer will look like:

```ruby
class UserMailer < ApplicationMailer
  def welcome(user)
    @name = user.name
    mail to: user.email
  end
end
```

Same thing for URLs:

```ruby
class UserMailer < ApplicationMailer
  def activation_email(user)
    @name = user.name
    @activation_url = account_activation_url(user.uuid)
    mail to: user.email
  end
end
```

And your e-mail body can be something like this:

```yaml
en:
  user_mailer:
    activation_email:
      subject: Activate your account
      body: |
        Hello, %{name}!

        You have to [activate your account](%{activation_url}).

        Thanks,

        --
        Myapp team
```

You may be wondering what happens with the mail's text part. Don't worry! ActionMailer::Markdown will take care of that. That message will be rendered as:

```text
Hello, John!

You have to activate your account[1].

Thanks,
--
Myapp team

[1]: http://example.com/activate/4d4b4396-dc26-47c4-b433-2cd9a1b45ce1
```

Lists and other elements are also exported to a more friendly text version.

**PROTIP:** Use [i18n-dot_lookup](https://github.com/fnando/i18n-dot_lookup) if you want to access properties from an object, like `%{user.name}`

### Replacing the Markdown engine

[redcarpet](https://github.com/vmg/redcarpet) is the default Markdown parser. You may want to specify different options or even switch out to a different Markdown library. All you have to do is defining a processor that responds to `.call`. Let's say you want to use [kramdown](http://kramdown.gettalong.org/) as your Markdown engine.

```ruby
ActionMailer::Markdown.processor = -> text { Kramdown::Document.new(text).to_html }
```

### Falling back to ActionMailer's default behavior

You can use templates if you want. Just don't define the `.body` part of your translation. Also, if you pass a block to the `mail()` method, it will skip this functionally completely.

### Using markdown files

If you want to use Markdown files instead of I18n translations, this gem is not for you. Consider using [maildown](https://github.com/schneems/maildown) or [markerb](https://github.com/plataformatec/markerb).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/actionmailer-markdown. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
