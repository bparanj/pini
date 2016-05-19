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
 
 