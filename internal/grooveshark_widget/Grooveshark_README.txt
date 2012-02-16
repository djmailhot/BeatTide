This readme describes the files used in the Grooveshark widget prototype

----------------------------------------------------

findSong.php - This file queries the TinySong API and returns an HTML table
		with the top 10 results from the query.  

		The SongID is embedded in the table.  


generateWidget.php - This file takes a parameter named "songID."  It then 
			creates the Grooveshark widget and puts in the 
			passed SongID and returns the widget. 


index.html - The basic HTML of the test site.

search.js - The javascript that queries the php services to find and play songs.

style.css - Styling
