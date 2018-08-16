Personal Project - mirror mirror
===========================

mirror mirror - A Ruby on Rails application for users to be able to upload/take a photo of themselves, and to be able to learn information about them.

Description
-----------
The interface for mirror mirror uses a 2 column layout, with the ability to take a screenshot using your webcam, or upload a local photo is located on the left, with the uploaded photo, and previous photos located directly beneath.

The right column will contain all the results that are created from the uploaded photo, this includes gender, age, smile, emotion, beard/moustache, glasses, hat, hair colour and makeup. Beneath this, it will inform the user if the photo that has been uploaded is blurry, has a high exposure or contains a lot of noise, and will give information on how to address this.

Dependencies
------------

* Microsoft Azure Face API

Installation
------------

* Make a git clone of the repository to your local machine:

`git clone git://github.com/AlexDaveRoberts/mirrormirror.git`

* Install Ruby 2.3.1 on to your local machine.

* Install Ruby on Rails 5.1.6 on to your local machine.

* Change directory to the mirror mirror repository:

`cd mirrormirror`

* Install the bundler gem:

`gem install bundler`

* Install all of the required gems needed by:

`bundle install`

* Install PostgreSQL 9.6.9 to your local machine.

* Open the database configuration file located:

`config/database.yml`

* Add your username and password to PostgreSQL on lines 3 and 4.

* Create the database using the command:

`rails db:create`

* Run a database migration:

`rails db:migrate`

* To connect to Microsoft's Azure Face API, open the uploads controller, located:

`app/controllers/users/uploads_controller`

* Add your subscription key to the Face API on line 24.
