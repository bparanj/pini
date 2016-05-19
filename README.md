How to build a Pinterest Clone in Rails 5

## Starter Rails 5 App

Create a new Rails 5 project and pin resource.

```
rails g scaffold pin title description:text
```

Migrate the database.

```
rails db:migrate
```

Start the server.

```
rails s
```

Create some records using the UI. 

## Authenticate using Devise

Add:

```ruby
gem 'devise', github: 'plataformatec/devise'
```

Run bundle. Generate the devise related files.

```
rails generate devise:install
```

Define the home page in routes.rb.

```ruby
root to: "pins#index"
```

Create the user model.

```
rails generate devise user
```

Add the `user_id` foreign_key to pins table.

```
rails g migration add_user_id_to_pins user_id:integer
```

Migrate the database.

```
rails db:migrate
```

Add the navigation links:

```rhtml
<% if user_signed_in? %>
  <li><%= link_to "New Pin", new_pin_path %></li>
	<li><%= link_to "Account", edit_user_registration_path %></li>
  <li><%= link_to "Sign Out", destroy_user_session_path, method: :delete %></li>
<% else %>
  <li><%= link_to "Sign Up", new_user_registration_path %></li>
	<li><%= link_to "Sign In", new_user_session_path %></li>
<% end %>	  
```

to layout. You will now be able to signup, signin and logout.

## File Uploading using Paperclip

```rhtml
gem "paperclip", "~> 5.0.0.beta1"
```

bundle

Add:

```ruby
has_attached_file :image, :styles => { :medium => "300x300>" }
validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
```

to pin.rb.

```
rails g paperclip pin image
```

```
rails db:migrate
```

Add:

```rthml
html: { multipart: true }
```

to pin form partial.

Add file upload field to pin form partial.

```rhtml
<div class='field'>
  <%= f.label :image %>	
  <%= f.file_field :image %>
</div>
```

You will get the error:

```
User must exist
```

if you try to create a pin without a user associated.

```ruby
def new
  @pin = current_user.pins.build
end
```

Image will not be uploaded. To fix:

```ruby
def pin_params
  params.require(:pin).permit(:title, :description, :image)
end
```


You can now upload and view the image.


In application.scss

```
*= require 'masonry/transitions'
```

 
``` 
*= require 'masonry/transitions'
*= require_tree .
*= require_self
*/
```
 
Change the pin show page.

```rhtml
<div class="transitions-enabled" id="pins">
  <% @pins.each do |pin| %>
    <div class="box panel panel-default">
      <%= link_to (image_tag pin.image.url), pin %>
      <h2>
         <%= link_to pin.title, pin %>
      </h2>
      <p class="user">
         Submitted by
         <%= pin.user.email %>
      </p>
    </div>
 	<%= link_to 'Edit', edit_pin_path(pin) %>
    <%= link_to 'Destroy', pin, method: :delete, data: { confirm: 'Are you sure?' } %>	
  <% end %>	
</div>
```
 
Add CSS to application.scss:

```css 
 body {
 	background: #E9E9E9;
 }

 h1, h2, h3, h4, h5, h6 {
 	font-weight: 100;
 }

 nav {
 	box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.22);
 	.navbar-brand {
 		a {
 			color: #BD1E23;
 			font-weight: bold;
 			&:hover {
 				text-decoration: none;
 			}
 		}
 	}
 }

 #pins {
   margin: 0 auto;
   width: 100%;
   .box {
 	  margin: 10px;
 	  width: 350px;
 	  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.22);
 	  border-radius: 7px;
 	  text-align: center;
 	  img {
 	  	max-width: 100%;
 	  	height: auto;
 	  }
 	  h2 {
 	  	font-size: 22px;
 	  	margin: 0;
 	  	padding: 25px 10px;
 	  	a {
 				color: #474747;
 	  	}
 	  }
 	  .user {
 	  	font-size: 12px;
 	  	border-top: 1px solid #EAEAEA;
 			padding: 15px;
 			margin: 0;
 	  }
 	}
 }

 #edit_page {
 	.current_image {
 		img {
 			display: block;
 			margin: 20px 0;
 		}
 	}
 }

 #pin_show {
 	.panel-heading {
 		padding: 0;
 	}
 	.pin_image {
 		img {
 			max-width: 100%;
 			width: 100%;
 			display: block;
 			margin: 0 auto;
 		}
 	}
 	.panel-body {
 		padding: 35px;
 		h1 {
 			margin: 0 0 10px 0;
 		}
 		.description {
 			color: #868686;
 			line-height: 1.75;
 			margin: 0;
 		}
 	}
 	.panel-footer {
 		padding: 20px 35px;
 		p {
 			margin: 0;
 		}
 		.user {
 			padding-top: 8px;
 		}
 	}
 }

 textarea {
 	min-height: 250px;
 }
```
 
Reload the page. You will now see styled grids for the pins.
 
 ## Integrate Twitter Bootstrap 4

``` 
gem 'bootstrap', '~> 4.0.0.alpha3'
```


bundle

 
In application.scss:
 
```
/*
 * This is a manifest file that'll be compiled into application.css, which will include all the files
 * listed below.
 *
 * Any CSS and SCSS file within this directory, lib/assets/stylesheets, vendor/assets/stylesheets,
 * or any plugin's vendor/assets/stylesheets directory can be referenced here using a relative path.
 *
 * You're free to add application-wide styles to this file and they'll appear at the bottom of the
 * compiled file so the styles you add here take precedence over styles defined in any other CSS/SCSS
 * files in this directory. Styles in this file should be added after the last require_* statement.
 * It is generally better to create a new file per style scope.
 *
 *= require 'masonry/transitions'
 */

@import "bootstrap";
```

``` 
//= require bootstrap
```
 
In application.js

``` 
//= require jquery
//= require bootstrap
//= require jquery_ujs
//= require turbolinks
//= require_tree .
```
 
In layouts/_header.html.erb:

``` 
 <nav class="navbar navbar-dark bg-inverse">
   <%= link_to "Movie Reviews", root_path, class: "navbar-brand" %>
   <ul class="nav navbar-nav">

     <li class="nav-item active">
       <a class="nav-link" href="movies/new">New Pin <span class="sr-only">(current)</span></a>
     </li>
     <li class="nav-item">
       <a class="nav-link" href="#">About</a>
     </li>
   </ul>
   <form class="form-inline pull-xs-right">
     <input class="form-control" type="text" placeholder="Search">
     <button class="btn btn-success-outline" type="submit">Search</button>
   </form>
 </nav>
```
 
Add:

``` 
<%= render 'layouts/header' %>
```
 
to layout file.
 
 
In application.js:

``` 
//= require masonry/jquery.masonry
```
 
``` 
//= require jquery
//= require bootstrap
//= require jquery_ujs
//= require masonry/jquery.masonry
//= require turbolinks
//= require_tree .
```
 
 pins.coffee
 

 $ ->
   $('#pins').imagesLoaded ->
     $('#pins').masonry
       itemSelector: '.box'
       isFitWidth: true
 
 Now you will see the transition effect when the browser window is resized.
 
 ## Vote on a Pin
 
 gem 'acts_as_votable', '~> 0.10.0'
 
 bundle
 
 rails generate acts_as_votable:migration
 rails db:migrate
 
 acts_as_votable
 
 in pin model.
 
 resources :pins do
   put 'like', to: 'pins#upvote'
 end
 
 pin_like PUT    /pins/:pin_id/like(.:format)   pins#upvote
 
 In pin show page:
 
 <%= link_to like_pin_path(@pin), method: :put, class: "btn btn-default" do %>
   <span class="glyphicon glyphicon-heart"></span>
   <%= @pin.get_upvotes.size %>
 <% end %>
 
 
 
 <% if user_signed_in? %>
   <%= link_to like_pin_path(@pin), method: :put, class: "btn btn-default" do %>
     <span class="glyphicon glyphicon-heart"></span>
     <%= @pin.get_upvotes.size %>
   <% end %>
 
   <%= link_to "Edit", edit_pin_path, class: "btn btn-default" %>
   <%= link_to "Delete", pin_path, method: :delete, data: { confirm: "Are you sure?" }, class: "btn btn-default" %>
 <% end %>
 
 undefined method `like_pin_path'
 
 pin_like PUT    /pins/:pin_id/like(.:format)   pins#upvote
 
 <%= link_to pin_like_path(@pin), method: :put, class: "btn btn-default" do %>
 ...
 
 
 Fixing Glyphicons Problem
 
 rails c
 Loading development environment (Rails 5.0.0.rc1)
 > Rails.application.config.assets.paths
  => ["/Users/bparanj/projects/pini/app/assets/config"...]
 > Rails.application.config.assets.paths.each do |x|
       p x
     end;nil
 "/Users/bparanj/projects/pini/app/assets/config"
 "/Users/bparanj/projects/pini/app/assets/images"
 "/Users/bparanj/projects/pini/app/assets/javascripts"
 "/Users/bparanj/projects/pini/app/assets/stylesheets"
 "/Users/bparanj/projects/pini/vendor/assets/javascripts"
 "/Users/bparanj/projects/pini/vendor/assets/stylesheets"
 "/Users/bparanj/.rvm/gems/ruby-2.3.1@rails5/gems/masonry-rails-0.2.4/vendor/assets/images"
 "/Users/bparanj/.rvm/gems/ruby-2.3.1@rails5/gems/masonry-rails-0.2.4/vendor/assets/javascripts"
 "/Users/bparanj/.rvm/gems/ruby-2.3.1@rails5/gems/masonry-rails-0.2.4/vendor/assets/stylesheets"
 "/Users/bparanj/.rvm/gems/ruby-2.3.1@rails5/gems/jquery-rails-4.1.1/vendor/assets/javascripts"
 "/Users/bparanj/.rvm/gems/ruby-2.3.1@rails5/gems/coffee-rails-4.1.1/lib/assets/javascripts"
 "/Users/bparanj/.rvm/gems/ruby-2.3.1@rails5/gems/actioncable-5.0.0.rc1/lib/assets/compiled"
 "/Users/bparanj/.rvm/gems/ruby-2.3.1@rails5/gems/turbolinks-source-5.0.0.beta4/lib/assets/javascripts"
 "/Users/bparanj/.rvm/gems/ruby-2.3.1@rails5/gems/bootstrap-4.0.0.alpha3/assets/stylesheets"
 "/Users/bparanj/.rvm/gems/ruby-2.3.1@rails5/gems/bootstrap-4.0.0.alpha3/assets/javascripts"
  => nil
  

Bootstrap gem does not come with glyphicons support. Download https://github.com/twbs/bootstrap-sass/tree/master/assets/fonts/bootstrap and copy fonts to vendor/assets/fonts folder.


In application.rb.

config.assets.paths << "#{Rails}/vendor/assets/fonts"

In application.scss:

@font-face {
   font-family: 'Glyphicons Halflings';
   src: url('/assets/glyphicons-halflings-regular.eot');
   src: url('/assets/glyphicons-halflings-regular.eot?#iefix') format('embedded-opentype'),
      url('/assets/glyphicons-halflings-regular.woff') format('woff'),
      url('/assets/glyphicons-halflings-regular.ttf') format('truetype'),
      url('/assets/glyphicons-halflings-regular.svg#glyphicons_halflingsregular') format('svg');
}



Uncaught Error: Bootstrap tooltips require Tether (http://github.hubspot.com/tether/)
 
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

to Gemfile. Run bundle.

//= require tether

after jQuery in application.js.


gem "font-awesome-rails"
bundle


@import "font-awesome";

in application.scss

In the pin show view:

<i class="fa fa-heart"></i>

undefined method `upvote_by' for nil:NilClass

before_action :set_pin, only: [:show, :edit, :update, :destroy, :upvote]
  
Couldn't find Pin with 'id'=

rake routes | grep like
                pin_like PUT    /pins/:pin_id/like(.:format)   pins#upvote
				
  resources :pins do
    member do
      put 'like', to: 'pins#upvote'
    end
  end

undefined method `pin_like_path' 

rake routes | grep like
like_pin PUT    /pins/:id/like(.:format)       pins#upvote			  


like_pin_path(@pin) 

in pin show page.

  before_action :authenticate_user!, except: [:index, :show]
  
  in pins controller.

Now you can like for any puppy by clicking the heart icon.

[Twitter Bootstrap 3 in a Rails 4 Application](http://www.erikminkel.com/2013/09/01/twitter-bootstrap-3-in-a-rails-4-application/ 'Twitter Bootstrap 3 in a Rails 4 Application')
[Rails 4: How to Include Bootstrap Glyphicons](http://www.angkorbrick.com/2014/11/06/rails-4-how-to-include-bootstrap-glyphicons/ 'Rails 4: How to Include Bootstrap Glyphicons')
[FontAwesome Rails Gem](https://github.com/bokmann/font-awesome-rails 'font-awesome-rails')  
[FontAwesome Cheatsheet](http://fontawesome.io/cheatsheet/ 'font awesome cheatsheet')
 
 
 
 
 
 