<?php
$api_key = "d44e54b31d4333b5940119c69fddc429";

$query = $_GET['query'];


$address = "http://tinysong.com/s/" . urlencode($query) . "?format=json&limit=10&key=" . $api_key;

$contents = file_get_contents($address);

$json = json_decode($contents);



?>

<table>
   <tr>
	  <th></th>
      <th>Song Name</th>
      <th>Artist</th>
   </tr>

<?php
for($i = 0; $i < count($json); $i++){
  $temp = $json[$i];
  $title = $temp->SongName;
  $artist = $temp->ArtistName;
  $id = $temp->SongID;
  $url = $temp->Url;
  $album = $temp->AlbumName;
  
    ?>
  <tr>
	 <td id=<?=$id?>><img src="img/play.png" height="30" class="playButton" id=<?=$id?> /></td>
     <td><?=$title?></td>
     <td><?=$artist?></td>
  </tr>
     <?php

}
?>
</table>
