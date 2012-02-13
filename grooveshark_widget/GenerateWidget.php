<?php

$id = trim($_REQUEST["songID"]);

?>

	 <object width="250" height="40">
	 <param name="movie" value="http://grooveshark.com/songWidget.swf" />
	 <param name="wmode" value="window" /><param name="allowScriptAccess" value="always" />
	 <param name="flashvars" id="param1" value="hostname=cowbell.grooveshark.com&songIDs=<?=$id?>&style=metal&p=1" />
	 <embed src="http://grooveshark.com/songWidget.swf" id="param2" type="application/x-shockwave-flash" width="250" height="40" flashvars="hostname=cowbell.grooveshark.com&songIDs=<?$id?>&style=metal&p=1" allowScriptAccess="always" wmode="window" />
	 </object>