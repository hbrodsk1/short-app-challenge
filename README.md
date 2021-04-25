# Thought Process
 My goal was to compelete the task of returning a short url when a full url was provided.
 To accomplish this, I configured the ShortUrl #short_code method to return an algorithmically
 determined short code. This method is called during the ShortUrls controller's #create action.
 The short code is then persisted to the DB and returned to the client.

 Because of this setup, both a full_url and a short_code are necessary upon creation in
 order for many of the tests in the test suite to pass.

# Algorithm Used
 The algorithm used to generate the short code takes into account a pre-determined set of characters
 and the number of records in the DB `(number_of_records)` and number of characters in the ShortUrl::CHARACTERS constant `(number_of_potential_characters)`.

 NOTE: The ruby `/` operator will round down if 2 numbers can not be eually divided by each other
 `EX:  1/1 = 1, 1/2/ = 0; 2/2 = 1, 3/2 = 1`

**Condition 1:** *0 Records in DB*
 For the first record that is persisted to the DB, it should have a short_code with a length of 1

**Condition 2:** *1 or more Records in DB (`number_of_records` divisible by `number_of_potential_characters`)*
 We check to see if `number_of_records % number_of_potential_characters == 0`. We do this to establish
 whether of not the `number_of_records` can be equally divided by the `number_of_potential_characters`.
 If they are, we want the length of the short_code to equal the result of `(number_of_records / number_of_potential_characters)`. For instance, if there are 62 `number_of_potential_characters`, and
 the `number_of_records` is <= 62, there is no reason for any of those records to have a short code
 with a lenth of > 1 since each of the potential characters has not been used yet.

**Condition 3:** *1 or more Records in DB (number_of_records NOT divisible by number_of_potential_characters)*
 If the `number_of_records` can NOT be equally divided by the `number_of_potential_characters`, then
 we want the length of the short_code to equal the result of `(number_of_records / number_of_potential_characters) + 1`. For instance, if there are 62 `number_of_potential_characters`, and
 the `number_of_records` is <= 62, then ruby will return 0 (see NOTE above). Since we do not want any short_code with no characters, we add 1 to its length.
# Current Issues
 - I am currently able to get 16/17 tests to pass. I am not able to get `UpdateTitleJob` test to pass.
 I think it is not passing because of config issues, but I have not figured it out. I keep getting:
 ```Failure/Error: let(:job) { UpdateTitleJob.perform_later(short_url.id) }

     NoMethodError:
       undefined method `before' for 1717:Integer
  ```
  The integer in the error always appears to be 4 number away from `short_url.id`

 - The code in `ShortUrl.update_title!` and the perform method of the UpdateTitleJob worker are the same.
 I feel confident that the functionlity is correct in the worker, but I'm unsure if something different
 is wanted in the model?

 - Because I am setting the `short_code` during the creation of a record, a short_code KV pair are
 needed for some of the tests to pass. I'm curious if this is allowed?

 - I used a built in rails validator to validate the `full_url` instead of the custom method provided?
 Is this allowed?

 - I feel confident that the algorithm works, but I also recognize there could be performance issues with it.
 Since there is a uniqueness constraint on the `short_code` field, as the number of records in the DB
 approaches a number divisible by 62, the odds increase that a combination of characters of n length
 will have already been generated. This means if we have 61 record in the DB, it could theoretically take
 62 attempts in order to assign a short_code that contains the 1 character that has not been used yet.
 I would be interested in exploring that issue more though.

# Intial Setup

    docker-compose build
    docker-compose up mariadb
    # Once mariadb says it's ready for connections, you can use ctrl + c to stop it
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

# To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

# To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

# Run the web server

    docker-compose up

# Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json

# Getting the top 100

    curl localhost:3000

# Checking your short URL redirect

    curl -I localhost:3000/abc
