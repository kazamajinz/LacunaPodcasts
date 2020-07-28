# LacunaPodcasts

A dark mode podcast app using iTunes Search API with offline playback and personal library persistence. Written programatically in Swift and built using Alamofire, FeedKit, AVKit, and iTunes API.

![LacunaPodcsts Demo](https://github.com/mcipswitch/lacuna-podcasts/blob/master/Screenshots/small.gif)

# Project Status

This project is currently still in development. This latest version includes the following core features:

* **Browse** podcasts using iTunes API
* Download feature allows for **Offline Playback**
* Save podcasts into **Personal Library**
* **Search** for specific episodes using keywords
* **Floating Audio Player** across all screens
* **Command Center** and **Lock Screen** integration with cover art and playback action buttons
* Responds to **Audio Session Interruptions** including phone calls and headphone connections

Tech Specific:

* Networking requests using **Alamofire**
* XML parsing with **FeedKit**
* Image loading and caching with **SDWebImage**
* User Library persistence with **UserDefaults**
* Monitor Downloads with *Notification Center*

# Screenshots

<p float="left">
<img src="https://github.com/mcipswitch/lacuna-podcasts/blob/master/Screenshots/library_view_empty.png" width="250">
<img src="https://github.com/mcipswitch/lacuna-podcasts/blob/master/Screenshots/search_podcasts.png" width="250">
<img src="https://github.com/mcipswitch/lacuna-podcasts/blob/master/Screenshots/podcast_details_download.png" width="250">
<img src="https://github.com/mcipswitch/lacuna-podcasts/blob/master/Screenshots/podcast_details_download_complete.png" width="250">
<img src="https://github.com/mcipswitch/lacuna-podcasts/blob/master/Screenshots/podcast_details_safari.png" width="250">
<img src="https://github.com/mcipswitch/lacuna-podcasts/blob/master/Screenshots/fullscreen_player.png" width="250">
<img src="https://github.com/mcipswitch/lacuna-podcasts/blob/master/Screenshots/podcast_details_description.png" width="250">
<img src="https://github.com/mcipswitch/lacuna-podcasts/blob/master/Screenshots/downloads_page.png" width="250">
<img src="https://github.com/mcipswitch/lacuna-podcasts/blob/master/Screenshots/library.png" width="250">
<img src="https://github.com/mcipswitch/lacuna-podcasts/blob/master/Screenshots/library_view_search.png" width="250">
<img src="https://github.com/mcipswitch/lacuna-podcasts/blob/master/Screenshots/library_view_search_noresults.png" width="250">
</p>

# Reflection

As an avid podcast listener, I wanted to build something I was familiar with as a user.
Some of the more challenging aspects of this project include the audio player min/max animations, 
tracking playback time (on audio player and control center simultaneously), monitoring downloads and updating UI,
and converting HTML text to attributed strings.

Features to add:

* add suggestions to 'Add Podcast' view
* style the episode description text screen
* adjust playback speed (1x, 1.25, 1.5...)
* share episode or personal library with others
* add haptics and feedback to user actions
* cache data for faster loading and better user experience



