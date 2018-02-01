[![Build Status](https://travis-ci.org/ssplatt/the_dw.svg?branch=master)](https://travis-ci.org/ssplatt/the_dw)
[![Maintainability](https://api.codeclimate.com/v1/badges/49f3420fb0229eca6039/maintainability)](https://codeclimate.com/github/ssplatt/the_dw/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/49f3420fb0229eca6039/test_coverage)](https://codeclimate.com/github/ssplatt/the_dw/test_coverage)

# The Danny Woodhead
A fantasy football game.

Alpha running at https://blooming-river-84075.herokuapp.com/

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

## Contributing

To contribute to the project, please follow the [Github Flow](https://guides.github.com/introduction/flow/) style.
 
  1. Fork the repository to your own space.
  2. Create a branch to work on.
  3. When finished, commit your code and push the branch to your fork on Github.
  4. Open a pull request (PR) against the main project.
  5. The pull request will be reviewed and discussed.
  6. WHen deemed appropriate, the code will be merged and deployed.
