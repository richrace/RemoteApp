XBMC Remote App
===

## Introduction

This app is created for my Major Project at Aberystwyth University. It uses the [Rhodes](http://www.rhomobile.com) framework.

I've been using XBMC for more a couple of years now and I've made an XBMC remote application for my Major Project for my degree.

It's a novel approach that uses Rhodes to create the application natively on either iOS, Android, etc. 

My application is written in Ruby, HTML and JS. But has some cool features such as:
- Can put movies into a watch later list
- Can scan movie barcodes and either finds it added in the database or adds it to a buy later list

It uses the JSON RPC API to communicate with the XBMC server.

You need to add your own Google Shopping API key to project in the following file "app/helpers/product_helper.rb"

## Some videos showing the features:

XBMC Configuration - http://youtu.be/Yyq8-zb970k

Movies - http://youtu.be/e4SHxpyC2WE

TV Shows and Playlist - http://youtu.be/BzrEYOL3uWc

Barcode - http://youtu.be/UvWPEuktF3U

Android - http://youtu.be/3l7wDbawcGY

## Author

Richard Race

## To Do

- Add Google API key to XBMC Config
- Add Music support
- Optimise Syncing of data

## Credits

This app wouldn't be possible if it wasn't for the work of other people.

Christoph Olszowka's Simple XBMC Client in Ruby. Accessed Dec 15 2011 [GitHub](https://github.com/colszowka/xbmc-client). Custom License (gives permission to "use, copy, modify, merge, publish,
distribute, sublicense, and/or sell"). Full License can be found in "/app/helpers/xbmc"

Artem Kramarenko's work on making a Rhodes validator. Accessed Dec 10 2011 [GitHub](https://github.com/artemk/rh-validatable)

akquinet A.G.'s jquery-toastmessage-plugin. This is released under the Apache 2.0 License. Accessed Feb 24 2012 [GitHub](http://akquinet.github.com/jquery-toastmessage-plugin/). The Apache 2.0 License can be found in the folder with the code (/public/jquery-toastmessage-plugin).

Using Rail's Active Record to constantize XBMC Commands - Released under MIT Licence. Accessed Dec 15 2011 [GitHub Source](https://github.com/rails/rails/blob/6c367a0d787705746f262d0bd5ad8c4f13a8c809/activesupport/lib/active_support/inflector/methods.rb#L212) | [GitHub Root](https://github.com/rails/rails) | [API Document](http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-constantize)

LazyLoad Plugin for JQuery. Using this plugin helped with getting/loading of images within the Movie List. It is released under the MIT Licence, I have added one line of code to get it to request to download a missing image, on line 97. Accessed 24 April 2012 [Project Home](http://www.appelsiini.net/projects/lazyload).

Icons used from within this project are from:

IconSweets. License = "You may use these icons for both commercial and non-commercial projects and customize them any way you like". Accessed Dec 10 2011 [Website](http://iconsweets.com/)

IconSweets 2. License = "You may use these icons for both commercial and non-commercial projects and customize them any way you like. You may NOT redistribute these icons from any other server". Accessed Dec 10 2011 [Website](http://iconsweets2.com/)

Primo. License = "free for personal and commercial use". Full License can be found "/public/images/primo" Accessed Feb 17 2012 [Website](http://www.webdesignerdepot.com/2009/07/200-free-exclusive-vector-icons-primo/)

Simplicio (unknown thumbnail) Accessed Feb 16 2012 [Website](http://neurovit.deviantart.com/art/simplicio-92311415?q=gallery%3Aneurovit&qo=0) License is CC [Website](http://creativecommons.org/licenses/by-sa/3.0/), however the author states "you can use these icons in your personal or commercial projects without asking for permission".

## License 

Currently this is released under the MIT license.