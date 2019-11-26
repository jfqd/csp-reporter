# csp-reporter

Web-App for receiving csp-reports with a mysql storage backend.

## Installation

```
git clone https://github.com/jfqd/csp-reporter.git
cd csp-reporter
mkdir log
bundle
cp env.sample .env
RACK_ENV=production bundle exec rake db:create
RACK_ENV=production bundle exec rake db:migrate
```

## Configuration

Edit ```.env``` file.

## Usage

tbd.

## Hosting

We use Phusion Passenger, but you can use thin, puma, unicorn or any other rack server as well. For testing just use:

```RACK_ENV=production bundle exec rackup```

## Test

curl -i -X POST localhost:9292 -d '{
   "csp-report": {
      "blocked-uri": "self",
      "document-uri": "https://example.com/",
      "original-policy": "...",
      "referrer": "https://example.com/test/",
      "source-file": "https://example.com/",
      "violated-directive": "script-src"
   }
}'

## Usefull links

* [Content Security Policy (CSP)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
* [RUBY ON RAILS CONTENT-SECURITY-POLICY (CSP)](https://bauland42.com/ruby-on-rails-content-security-policy-csp/)

Copyright (c) 2019 Stefan Husch, qutic development GmbH