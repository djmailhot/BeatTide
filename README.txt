BEATTIDE V1 RELEASE
Alex Miller, Brett Webber, David Mailhot, Harnoor Singh, Melissa Winstanley, Tyler Rigsby


BINARY DISTRIBUTION

Navigate to http://beattide.herokuapp.com/


FEATURE LIST

The high level features implemented in the BeatTide beta are the ability to:
- Sign into (and out of) the app using Facebook authorization
- Search for and play songs using Grooveshark
- Post songs to your profile
- Search for other users, or look them up in a list
- Subscribe to another user so that songs they post to their profile appear in your feed
- Like a post and see how many likes a post has among all users
- View the top songs and top users by total likes
- Tutorial pages to guide first-time users on how to start using BeatTide, as well as
  explain how to operate its many features.
- A fluid, intuitive music-playing experience with a single Grooveshark widget.
- Play a playlist of music, either from your posts or the posts made by users you
  are subscribed to (your "feed").
- Music begins to play automatically when you sign in (from your feed).
- Listen to music while navigating around the site.
- The ability to delete posts made to your profile.
- Paginate the posts so that you only see 10 at a time.
- See your favorite products with BeatTide-supported advertisements.


USAGE INSTRUCTIONS

To use the app, first click the "Sign in with Facebook" button and approve the Facebook
authorization (cookies must be allowed). Upon signing in, you will be brought to your
home page. From your home page, you can do several things:

- Search for a song by entering a song/artist/album name in the “Search for Song...”
  box. After searching, you can preview songs by pressing the corresponding play button
  (">"), or add a song to your profile using the add button ("+").
- View and play the songs you’ve added to your profile in the “Your Posted Songs” box.
- View and play the songs that people you have subscribed to have posted (under your
  "Friend Feed").
- Search for friends by clicking the “Find Friends” link and entering the user name of
  a friend in the search box.
- Find friends in the list of users by clicking “See All Users”
- View and play the top songs by likes and view the top users by likes their posts have
  received.

When you click on a link to another user, you are brought to their profile page. There,
you can play, like, or post the songs that they have posted to your profile. You can also
subscribe to a user so that songs they post will appear in the “Friend Feed” on your
home page.


BUILD INSTRUCTIONS

To build the app from the source, run the following commands from the app root directory:
> bundle install
> rake db:migrate
> rails server

Then navigate to localhost:3000 in a web browser.
