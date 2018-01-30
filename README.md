[![Build Status](https://travis-ci.org/ssplatt/the_dw.svg?branch=master)](https://travis-ci.org/ssplatt/the_dw)
[![Maintainability](https://api.codeclimate.com/v1/badges/49f3420fb0229eca6039/maintainability)](https://codeclimate.com/github/ssplatt/the_dw/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/49f3420fb0229eca6039/test_coverage)](https://codeclimate.com/github/ssplatt/the_dw/test_coverage)

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

Finally, run the test suite to verify that everything is working correctly:

```
$ rails test
```

If the test suite passes, you'll be ready to run the app in a local server:

```
$ rails server
```
