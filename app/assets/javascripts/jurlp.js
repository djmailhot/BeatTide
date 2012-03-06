/**
 *
 *	File:	jurlp.js
 *
 *	Title:	JQuery URL parser.
 *
 * 	JQuery URL parser plugin for parsing, manipulating, filtering and monitoring URLs in href and src attributes within arbitrary elements (including document.location.href), as well as creating anchor elements from URLs found in HTML/text.
 *
 *	About: Authors
 *
 *	Thomas James Bonner (tom.bonner@gmail.com).
 *
 *	Yonas SandbÊk (seltar@gmail.com).
 *
 *	About: Version
 *
 *	1.0.4
 *
 *	About: License
 *
 *	Copyright (C) 2012, Thomas James Bonner (tom.bonner@gmail.com).
 *
 *	MIT License:
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 *	- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 *	- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 **/ 

/**
 *
 *	Section: URL overview.
 *
 *	URL naming scheme:
 *
 *	A quick quide to URL nomenclature in this plugin.
 *
 *	Throughout this plugin, URLs are segmented and refered to in the following manner;
 *
 *	> http://username:password@www.example.com:443/path/file.name?query=string#anchor
 *	> |_____||______| |______| |_____________| |_||_____________||___________||_____|
 *	>    |       |       |           |          |         |             |         |
 *	> scheme   user   password      host       port      path         query   fragment
 *	> |______________________________________________________________________________|
 *	>                                        |
 *  >                                       url
 *
 *	Scheme:
 *
 *	Contains the protocol identifier (i.e. "https://", "ftp://").
 *
 *	User:
 *
 *	Conains the username to use when connecting to the host server. This segment may be empty.
 *
 *	Password:
 *
 *	Contains the password to use in conjunction with the username when connecting to the remote server. This segment may be empty (and cannot be set without a user name).
 *
 *	Host:
 *
 *	Contains the name or IP address of the host server (i.e. "www.example.com", or "127.0.0.1").
 *
 *	Port:
 *
 *	Contains the listening port number for the host server (i.e. "80", or "8080"). Note that an empty port value implies the default port (80).
 *
 *	Path:
 *
 *	Contains the file path (i.e. "/index.html", or "/").
 *
 *	Query:
 *
 *	Contains any parameters passed in the query (i.e. "?param1=value1&param2=value2"). This segment may be empty.
 *
 *	Fragment:
 *
 *	Contains any anchors/hash tags (i.e. "#elementname"). This segment may be empty.
 *
 *	Section: URL Objects
 *
 *	URL object definition.
 *
 *	For the purposes of this plugin, URLs can be represented either as a string, for example "http://www.example.com:8080/path/file.name?query=string#anchor", or as an object;
 *
 *	(start code)
 *
 *	{
 *		scheme: "http://"
 *		user: "username",
 *		password: "password",
 *		host: "www.example.com",
 *		port: "8080",
 *		path: "/path/file.name",
 *		query: "?query=string",
 *		fragment: "#anchor" 
 *	}
 *
 *	(end code)
 *
 *	Therefore, wherever URLs are supplied as a parameter to the plugin via the <url> or <proxy> methods, either a string or object representation or the URL may be supplied.
 *
 *	URL objects that have been returned via the parser interface can easily be converted to a string by calling the objects toString() method. 
 *
 *	Example:
 *
 *	(start code)
 *
 *	// Parse the document.location.href URL, and convert it back to a string again.
 *	$(document).jurlp("url").toString();
 *
 *	(end code)
 *
 */
 
/**
 *
 *	Section: Quick overview
 *
 *	Useful example code.
 *
 *	(start code)
 *
 *	// Parse and set the element(s) URL
 *	$("a").jurlp("url");
 *	$("a").jurlp("url", "http://www.example.com/");
 *	
 *	// Get or set individual URL segments for the element(s)
 *	$("a").jurlp("scheme");
 *	$("a").jurlp("scheme", "https://");
 *
 *	$("a").jurlp("user");
 *	$("a").jurlp("user", "username");
 *
 *	$("a").jurlp("password");
 *	$("a").jurlp("password", "password");
 *
 *	$("a").jurlp("host");
 *	$("a").jurlp("host", "www.example.com");
 *	
 *	$("a").jurlp("port");
 *	$("a").jurlp("port", "8080");
 *	
 *	$("a").jurlp("path");
 *	$("a").jurlp("path", "../file.name");
 *	
 *	$("a").jurlp("query");
 *	$("a").jurlp("query", {"param":"value"});
 *	
 *	$("a").jurlp("fragment");
 *	$("a").jurlp("fragment", "elementid");
 *	
 *	// Filter on URL segments
 *	$("a").jurlp("filter", "scheme", "^=", "http")
 *	      .jurlp("filter", "user", "=", "user")
 *	      .jurlp("filter", "password", "=", "password")
 *	      .jurlp("filter", "host", "=", "www.example.com")
 *	      .jurlp("filter", "port", "!=", "8080")
 *	      .jurlp("filter", "path", "$=", ".html")
 *	      .jurlp("filter", "query", "*=", "param=value")
 *	      .jurlp("filter", "fragment", "regex", /(\#)/);
 *	
 *	// Watch a selector for new nodes
 *	$("a:eq(0)").jurlp("watch", function(element, selector){})
 *	            .jurlp("filter", "host", "=", "www.example.com")
 *	            .jurlp("query",{"found":"example"});
 *	
 *	$("body").prepend("<a href='http://www.example.com/'></a>");
 *	
 *	$("a:eq(0)").jurlp("unwatch");
 *	
 *	// Parse an element's text for URLs and create/return anchor elements
 *	$("<div>www.example.com</div>").jurlp();
 *
 *	// Get an interface for parsing/manipulating the supplied URL
 *	url = $.jurlp("http://www.example.com:80/path/file.name?param1=value1#fragment");
 *
 *	// Parse the URL to an object.
 *	url.url();
 *
 *	// Get the URL scheme.
 *	url.scheme();
 *
 *	// Get the URL user name.
 *	url.user();
 *
 *	// Get the URL password.
 *	url.password();
 *
 *	// Get the URL host.
 *	url.host();
 *
 *	// Get the URL port.
 *	url.port();
 *
 *	// Get the URL path.
 *	url.path();
 *
 *	// Get the URL query.
 *	url.query();
 *
 *	// Get a specific parameter value from the URL query.
 *	url.query().param1;
 *
 *	// Get the URL fragment.
 *	url.fragment();
 *
 *	// Set the full URL.
 *	url.url("http://www.example.com:80/path/file.name?param1=value1#fragment");
 *
 *	// Set the URL scheme.
 *	url.scheme("https://");
 *
 *	// Set the URL user name.
 *	url.user("user");
 *
 *	// Set the URL password.
 *	url.password("password");
 *
 *	// Set the URL host.
 *	url.host("www.newexample.com");
 *
 *	// Set the URL port.
 *	url.port("80");
 *
 *	// Set the URL path.
 *	url.path("/newpath/newfile.file");
 *
 *	// Append to the URL path.
 *	url.path("./newfile.file");
 *
 *	// Remove two path elements and append to the URL path.
 *	url.path("../../newfile.file");
 *
 *	// Set the URL query.
 *	url.query("?param=value");
 *
 *	// Append/modify the URL query (string or object)
 *	url.query("param=value");
 *	url.query({"param":"value"});
 *
 *	// Remove the URL query
 *	url.query("");
 *	url.query({});
 *
 *	// Set the URL fragment.
 *	url.fragment("#newfragment");
 *
 *	(end code)
 *
 **/

/**
 *	Section: Parsing document.location.href
 *
 *	Parsing the document URL.
 *
 *	The document URL (document.location.href) can be parsed by specifying the HTML document element to the parser in the following manner;
 *
 *	(start code)
 *
 *	// Parse the document.location.href URL string into a URL object
 *	$(document).jurlp("url");
 *
 *	(end code)
 *
 *	Similarly, the document URL can be modified by the plugin, but it is worth noting that changes will not be directly applied to document.location.href until <goto> is explicitly called on the element, and instead, a working copy of the URL is stored under the documents "data-href" attribute.
 *
 *	(start code)
 *
 *	// Does not modify document.location.href (updates $(document).data("href"))
 *	$(document).jurlp("url", "www.example.com");
 *
 *	// Does modify document.location.href (from $(document).data("href"))
 *	$(document).jurlp("goto");
 *
 *	(end code)
 *
 */
 
/**
 *	Section: Parsing elements with an "href" or "src" attribute.
 *
 *	Parsing "href" or "src" attributes.
 *
 *	Elements with an "href" or "src" attribute (i.e. <a href="">, <base href="">, <link href="">, <img src="">, <script src=""> or <iframe src="">), can be parsed by specifying the element(s) to the parser in the following manner;
 *
 *	(start code)
 *
 *	// Parse all anchor element URLs into an array
 *	$("a").jurlp("url");
 *
 *	(end code)
 *
 *	Any modifications made to the URL will modify the relevant "href" or "src" attribute directly. If you want to visit the URL within an elements "href" or "src" attribute, it is possible to call <goto> on the element.
 *
 *	(start code)
 *
 *	// Directly set the first anchor elements URL, and then goto it!
 *	$("a:eq(0)").jurlp("url", "www.example.com").jurlp("goto");
 *
 *	(end code)
 *
 */

/**
 *	Section: Parsing element text/HTML.
 *
 *	Parsing text/HTML for URLs.
 *
 *	It is possible for the URL parser to find URLs within text/HTML, and convert them into HTML anchor elements.
 *
 *	(start code)
 *
 *	// Parse the HTML for URLs, and convert all URLs found in the text to anchors.
 *	$("<div>Here are URLs: www.example1.com, www.example2.com</div>").jurlp();
 *
 *	// HTML becomes:
 *	<div>
 *		Here are URLs: 
 *		<a href="http://www.example1.com/" class="jurlp-no-watch">www.example1.com</a>, 
 *		<a href="http://www.example2.com/" class="jurlp-no-watch">www.example2.com</a>
 *	</div>
 *	(end code)
 *
 **/
 
/**
 *	Section: Parsing URL strings directly.
 *
 *	How to directly parse, modify or monitor an arbitrary URL string.
 *
 *	(start code)
 *
 *	// Get an interface for parsing the document URL...
 *	var url = $.jurlp();
 *
 *	// .. or get an interface for parsing your own URL.
 *	url = $.jurlp("www.example.com");
 *
 *	// Parse the URL to an object.
 *	url.url();
 *
 *	// Get the URL scheme.
 *	url.scheme();
 *
 *	// Get the URL host.
 *	url.host();
 *
 *	// Get the URL port.
 *	url.port();
 *
 *	// Get the URL path.
 *	url.path();
 *
 *	// Get the URL query.
 *	url.query();
 *
 *	// Get a specific parameter value from the URL query.
 *	url.query().parameter;
 *
 *	// Get the URL fragment.
 *	url.fragment();
 *
 *	// Create a watch for new URLs that contain "example.com" in the host name
 *	var watch = $.jurlp("example.com").watch(function(element, selector){
 *		console.log("Found example.com URL!", element, selector);
 *	});
 *
 *	// We can even apply filters to the watch to be sure!
 *	watch.jurlp("filter", "host", "*=", "example.com");
 *
 *	// Append a new URL, which will trigger the watch
 *	$("body").append("<a href=\"www.example.com\"></a>");
 *
 *	// Stop watching for "example.com" URLs.
 *	watch.jurlp("unwatch");
 *
 *	(end code)
 *
 */
 
/**
 *	Section: Unknown URLs.
 *
 *	Overview of unknown URL parsing.
 *
 *	Unknown scheme:
 *
 *	The parser will attempt to parse any type of URL it encounters based on its scheme. However, not all URLs are parsable, for example "spotify:track:<trackid>". In this case, the following URL object is returned;
 *
 *	(start code)
 *
 *	{
 *		scheme: "spotify:",
 *		url: "track:<trackid>"
 *	}
 *
 *	(end code)
 *
 *	The unknown URL object will always contain the scheme (if present), for filtering purposes, and also contains a toString() method, which will convert the URL object back to the original URL string.
 *
 *	mailto:
 *
 *	"mailto:" URLs are parsable in the same manner as a regular HTTP URL. For example, the following URL object is returned for a URL with a "mailto:" scheme;
 *
 *	(start code)
 *
 *	{
 *		scheme: "mailto:"
 *		user: "username",
 *		password: "",
 *		host: "www.example.com",
 *		port: "",
 *		path: "",
 *		query: "?subject=subject&body=body",
 *		fragment: "" 
 *	}
 *
 *	(end code)
 *
 *	Therefore, "mailto:" URLs can be fully parsed using this parser, but note that it is not possible to set the password, port or fragment strings on a "mailto:" URL.
 *
 *	javascript:
 *
 *	"javascript" URLs are parsable in the same manner as a regular HTTP URL. For example, the following URL object is returned for a URL with a "javasrcipt:" scheme;
 *
 *	(start code)
 *
 *	{
 *		scheme: "javascript:"
 *		user: "",
 *		password: "",
 *		host: "www.example.com",
 *		port: "",
 *		path: "/",
 *		query: "",
 *		fragment: "",
 *		javascript: "alert('!');"
 *	}
 *
 *	(end code)
 *
 *	Therefore, "javascript:" URLs can be fully parsed using this parser, but note that the current "document.location.href" will always be parsed/returned as the main URL object.
 *
 **/
 
/**
 *	Section: Operators.
 *
 *	Overview of filter operators.
 *
 *	The following filter operators may be specified as the "operator" parameter to the <filter> method.
 *
 *	URL filter operators:
 *
 *	"=" - Equal to.
 *	"!=" - Not equal to.
 *	"*=" - Contains.
 *	"<" - Less than. 
 *	"<=" - Less than or equal to.
 *	">" - Greater than.
 *	">=" - Greater than or equal to.
 *	"^=" - Starts with.
 *	"$=" - Ends with.
 *	"regex" - Regular expression.
 *
 **/

 /**
 *	Section: this parameter.
 *
 *	Where "this" is refered to as an argument to the method functions, it may be one of the following;
 *
 *	- HTML document element.
 *	- An array of 1 or more elements with a "href" or "src" attribute.
 *	- A URL parser interface returned from $.jurlp().
 *
 **/

(
	function ( $ )
	{
		/**
		 *
		 *	Regular expression for parsing URLs.
		 *
		 *	Taken from parseUri 1.2 (http://blog.stevenlevithan.com/archives/parseuri).
		 *
		 **/ 

		var urlRegEx = /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/;

		/*

			Global object of watched selectors and their array of callstacks.

		*/ 

		var selectorCallStack = { };

		/*

			Currently watched selector. ToDo: Remove this and use a better mechanism for selector tracking.

		*/

		var currentSelector = "";

		/**
		 *
		 *	Section: Internal functions.
		 *
		 *	All internal private functions.
		 *
		 *	This section contains all internal functions that perform the grunt work for the parser interface.
		 *
		 **/ 

		/**
		 *
		 *	Function: initialiseElement
		 *
		 *	Initialise an element for use with the URL parser.
		 *
		 *	Parameters: 
		 * 
		 *	this - The element to initialise. See <this parameter>.
		 *
		 **/ 

		var initialiseElement = function ( )
		{
			/* Attempt to retreive a href from the element */ 

			var href = getHref.apply ( this );

			/* Was a href found for the element? */ 

			if ( href == "" )
			{
				/* Is the current element the document? */

				if ( this.get ( 0 ) == $( document ).get ( 0 ) )
				{
					/* Use the document href */ 

					href = document.location.href;
				}
				else if ( this.is ( "[href]" ) )
				{
					/* Use the element href attribute */ 

					href = this.attr ( "href" );
				}
				else if ( this.is ( "[src]" ) )
				{
					/* Use the element src attribute */ 

					href = this.attr ( "src" );
				}

				/* Check the href is not empty so we don't initialise the "data-href" attribute on text elements (although maybe this is not wanted, as an empty href is technically the current page?). */ 

				if ( href != "" )
				{
					/* Sanitise the URL */ 

					href = sanitiseUrl ( href );

					/* Store the URL as a data attribute within the element */ 

					this.data ( "href", href );
				}
			}
		};

		/**
		 *
		 *	Function: initialiseElementText
		 *
		 *	Initialise an elements text field for use with the URL parser.
		 *
		 *	Parameters: 
		 * 
		 *	this - The element to initialise.
		 *
		 **/ 

		var initialiseElementText = function ( )
		{
			/* Is the current element not the document, and also does not contain a "href" attribute */ 

			if ( this.get ( 0 ) != $( document ).get ( 0 ) && this.attr ( "href" ) == null && this.attr ( "src" ) == null )
			{
				/* Does the element contain anything? */ 

				if ( this.html ( ) != null && this.hasClass ( "jurlp-span" ) == false )
				{
					var urls = [ ];
					var modifiedHtml = false;
					var match = "";

					/* Regular expression for finding URLs in free text */ 

					var findUrlRegExp = /((((mailto|spotify|skype)\:([a-zA-Z0-9\.\-\:@\?\=\%]*))|((ftp|git|irc|ircs|irc6|pop|rss|ssh|svn|udp|feed|imap|ldap|nntp|rtmp|sftp|snmp|xmpp|http|https|telnet|ventrilo|webcal|view\-source)\:[\/]{2})?(([a-zA-Z0-9\.\-]+)\:([a-zA-Z0-9\.&;%\$\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.(aero|arpa|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|xn--0zwm56d|xn--11b5bs3a9aj6g|xn--80akhbyknj4f|xn--9t4b11yi5a|xn--deba0ad|xn--g6w251d|xn--hgbk6aj7f53bba|xn--hlcj6aya9esc7a|xn--jxalpdlp|xn--kgbechtv|xn--zckzah|[a-zA-Z]{2}))(\:[0-9]+)*(\/($|[a-zA-Z0-9\.\,\?\'\\\+&;%\$\=~_\-]+)?(#\w*)?)*))/i;

					/* Store the elements HTML */ 

					var html = this.html ( );

					/* Attempt to locate URLs within the HTML */ 

					while ( match = findUrlRegExp.exec ( html ) )
					{
						/* Replace the URL with a unique ID */ 

						html = html.replace ( match [ 0 ], "$" + urls.length );

						/* Store the discovered URL */ 

						urls.push ( match [ 0 ] );

						/* Indicate that the HTML was modified */ 

						modifiedHtml = true;
					}

					/* Iterate through all discovered URLs */ 

					for ( var i = 0; i < urls.length; i++ )
					{
						/* Get the postion of the current URL ID */ 

						var pos = html.indexOf ( "$" + i );

						/* Get the possible attribute name */ 

						var attr = html.substring ( pos - 6, pos - 1 );

						/* Does the URL reside within an attribute (i.e. an existing tag) */ 

						if ( attr == "href=" || attr == " src=" || html.substring ( pos - 1, pos ) == ">" )
						{
							/* Replace the ID with the original URL (do not convert this URL to an anchor as it most likely is part of one) */ 

							html = html.replace ( "$" + i, urls [ i ] );
						}
						else
						{
							/* Replace the unique ID with an anchor tag */ 

							html = html.replace ( "$" + i, "<a href=\"[url]\" class=\"jurlp-no-watch\">[url]</a>".replace ( /\[url\]/g, urls [ i ] ) );
						}
					}

					/* Did we change the HTML at all? */ 

					if ( modifiedHtml != false )
					{
						/* Add a class on the parent element to indicate that we have modified it */ 

						this.addClass ( "jurlp-span" );

						/* Update the elements HTML */ 

						this.html ( html );

						/* Find and return all newly created anchor tags */ 

						return this.find ( "a[href]" ).each
						(
							function ( )
							{
								/* Get the href attribute for the element */ 

								var href = getHref.apply ( $( this ) );

								/* Sanitise the URL and reset the elements href */ 

								setHref.apply ( $( this ), [ href ] );
							}
						);
					}
				}
			}

			/* No URLs found */ 

			return null;
		}

		/**
		 *
		 *	Function: setAttrUrl
		 *
		 *	Given an element, and an attribute, set the attribute to the supplied URL, and created a backup of the original URL if not already done.
		 *
		 *	Note, if the attribute doesn't exist, then it will not be created.
		 *
		 *	Parameters: 
		 * 
		 *	this - The element to set the attribute URL on.
		 *
		 *	attr - The name of the attribute to set.
		 *
		 *	url - The value of the attributes URL.
		 *
		 **/ 

		var setAttrUrl = function ( attr, url )
		{
			/* Is the attribute present on this element? */ 

			if ( this.is ( "[" + attr + "]" ) != false )
			{
				/* Has a copy of the original attribute been stored? */ 

				if ( this.data ( "original-" + attr ) == null )
				{
					/* Store a copy of the original attribute */ 

					this.data ( "original-" + attr, this.attr ( attr ) );
				}

				/* Update the elements attribute */ 

				this.attr ( attr, url );
			}
		};

		/**
		 *
		 *	Function: restoreAttrUrl
		 *
		 *	Given an element, and an attribute, then restore the URL attribute value to its original value.
		 *
		 *	Parameters: 
		 * 
		 *	this - The element to restore the attribute URL on.
		 *
		 *	attr - The name of the attribute to restore.
		 *
		 **/ 

		var restoreAttrUrl = function ( attr )
		{
			/* Was a backup of the original attribute URL made? */ 

			if ( this.data ( "original-" + attr ) != null )
			{
				/* Restore the attribute URL */ 

				this.attr ( attr, this.data ( "original-" + attr ) );

				/* Remove the original URL */ 

				this.removeData ( "original-" + attr );
			}
		};

		/**
		 *
		 *	Function: restoreElement
		 *
		 *	Destroys any data associated with an element that has previously been initialised for use with the URL parser, and restores the elements "href" or "src" attribute (if any) to its original value.
		 *
		 *	Parameters: 
		 * 
		 *	this - The element to destroy.
		 *
		 **/ 

		var restoreElement = function ( )
		{
			/* Remove the working href URL */ 

			this.removeData ( "href" );

			/* Restore the href attribute */ 

			restoreAttrUrl.apply ( this, [ "href" ] );

			/* Restore the src attribute */ 

			restoreAttrUrl.apply ( this, [ "src" ] );

			/* Remove any watch attributes */ 

			this.removeData ( "jurlp-no-watch" );
			this.removeData ( "is-watched" );

			/* clean up selector callstack and unbind */ 

			methods.unwatch.apply ( this );
		}

		/**
		 *
		 *	Function: getHref
		 *
		 *	Get the href URL for the element. Prioritises internal objects href, over "data-href", over "href", over "src" attributes.
		 *
		 *	Parameters: 
		 * 
		 *	this - The element to retieve the URL value from.
		 *
		 **/ 

		var getHref = function ( )
		{
			return this.href || this.data ( "href" ) || this.attr ( "href" ) || this.attr ( "src" ) || "";
		};

		/**
		 *
		 *	Function: updateHref
		 *
		 *	Update a segment of the elements href URL.
		 *
		 *	Parameters: 
		 * 
		 *	this - The element to update the URL value on.
		 *
		 *	segment - The segment to update ("scheme", "host", "port", "path", "query" or "fragment").
		 *
		 *	value - The new value for the segment.
		 *
		 **/ 

		var updateHref = function ( segment, value )
		{
			setHref.apply ( this, [ setUrlSegment ( getHref.apply ( this ), segment, value ) ] );
		};

		/**
		 *
		 *	Function: updateHrefShim
		 *
		 *	Shim function for reorganising parameters before calling updateHref(). Called via the each callback.
		 *
		 *	Parameters: 
		 * 
		 *	this - The element to update the URL value on.
		 *
		 *	parameters - Array containing segment and value parameters for updateHref().
		 *
		 **/ 

		var updateHrefShim = function ( parameters )
		{
			updateHref.apply ( this, [ parameters [ 0 ], parameters [ 1 ] ] );
		};

		/**
		 *
		 *	Function: setHref
		 *
		 *	Sets the href URL value for an element.
		 *
		 *	Parameters: 
		 * 
		 *	this - The element to set the URL value on.
		 *
		 *	url - The new url (string) value.
		 *
		 **/ 

		var setHref = function ( url )
		{
			/* Ensure the supplied URL is a string */ 

			if ( typeof url == "object" )
			{
				url = objectToUrl ( url );
			}

			/* Sanitise the URL - slow and horrible :( */ 

			url = sanitiseUrl ( url );

			if ( this.href != null )
			{
				this.href = url;

				return;
			}

			/* Is the current element the document? */ 

			if ( this.get ( 0 ) == $( document ).get ( 0 ) )
			{
				/* Current element is the document. Save the href under a data attribute. */

				this.data ( "href", url );
			}
			else
			{
				/* Update href URL (if present) */ 

				setAttrUrl.apply ( this, [ "href", url ] );

				/* Update src URL (if present) */ 

				setAttrUrl.apply ( this, [ "src", url ] );
			}
		};

		/**
		 *
		 *	Function: urlToObject
		 *
		 *	Parse a URL into segments using the DOM. Parses authority information from the URL using parseUri (http://blog.stevenlevithan.com/archives/parseuri).
		 *
		 *	Parameters: 
		 *
		 *	url - URL String to parse.
		 *
		 *	Returns:
		 *
		 *	URL object.
		 *
		 **/ 

		var urlToObject = function ( url )
		{
			/* Was a null URL supplied? */ 

			if ( url == null )
			{
				/* Return an empty object */ 

				return { scheme : "", user : "", password : "", host : "", port : "", path : "", query : "", fragment : "" };
			}

			var credentials = { user : "", password : "" };

			if ( url.substring ( 0, 2 ) == "//" )
			{
				url = "http:" + url;
			}

			/* If a URL is supplied, ensure a protocol is specified, otherwise the parser will assume that the supplied host is the path */ 

			if ( url != "" && url.indexOf ( "://" ) == -1 )
			{
				url = "http://" + url;
			}

			/* Does the URL contain authority information? */ 

			if ( url.indexOf ( "@" ) != -1 )
			{
				/* Parse the URL using regex */ 

				var urlSegments = url.match ( urlRegEx );

				/* Was a username found? */ 

				if ( urlSegments [ 4 ] )
				{
					credentials.user = urlSegments [ 4 ];
				}

				/* Was a password found? */ 

				if ( urlSegments [ 5 ] )
				{
					credentials.password = urlSegments [ 5 ];
				}
			}

			/* Construct a new anchor element based on the supplied URL */ 

			var a = document.createElement ( "a" );

			/* Set the anchor href to the URL to parse (let the browser do (most of) the parsing) */ 

			a.href = url;

			/* Under IE, an anchor element containing a username and password is inaccessible, so we will probe "a.protocol" to test if we have access */ 

			try
			{
				/* Check if the element is accessible */ 

				var accessible = a.protocol;
			}
			catch ( err )
			{
				/* MSIE: A security problem occurred. (cannot access the anchor element) */ 

				if ( err.number == -2146697202 )
				{
					/* IE hack!.. strip the username and password from the URL, and reparse */ 

					var authority = "";

					/* Were credentials found in the URL? */ 

					if ( credentials.user != "" )
					{
						/* Build string containing the username and password to strip from the URL */ 

						authority += credentials.user;

						if ( credentials.password != "" )
						{
							authority += ":" + credentials.password;
						}

						authority += "@";

						/* Strip the username and password from the URL and set the anchor href (this could in theory be done for all browsers) */ 

						a.href = url.replace ( authority, "" );
					}
				}
			}

			/* Sanitise the protocol string */ 

			var protocol = a.protocol;

			if ( a.protocol.indexOf ( "//" ) == -1 )
			{
				protocol += "//";
			}

			/* Sanitise the path string */ 

			var pathname = a.pathname;

			if ( pathname [ 0 ] != "/" )
			{
				pathname = "/" + pathname;
			}

			/* Ensure the port value is a string */ 

			var port = a.port + "";

			/* Strip of default port numbers if added, and not present in the original URL */ 

			if ( ( port == "21" && url.indexOf ( ":21" ) == -1 ) || ( port == "80" && url.indexOf ( ":80" ) == -1 ) || ( port == "443" && url.indexOf ( ":443" ) == -1 ) || port == "0" )
			{
				port = "";
			}

			/* Return the URL object, based on the URL information for the newly created anchor element contained in the DOM */ 

			return { scheme : protocol, user : credentials.user, password : credentials.password, host : a.hostname, port : port, path : pathname, query : a.search, fragment : a.hash };
		};

		/**
		 *
		 *	Function: objectToUrl
		 *
		 *	Convert a URL object to a string.
		 *
		 *	Parameters: 
		 *
		 *	url - The URL object to convert.
		 *
		 *	Returns:
		 *
		 *	URL string.
		 *
		 **/ 

		var objectToUrl = function ( url )
		{
			/* Build URL string, starting with the scheme */ 

			var urlString = url.scheme;

			/* Was a username specified? */ 

			if ( url.user != null && url.user != "" )
			{
				/* Insert the username */ 

				urlString += url.user;

				/* Was a password also specified? */ 

				if ( url.password != null && url.password != "" )
				{
					urlString += ":" + url.password;
				}

				/* Insert authority/host seperator */ 

				urlString += "@";
			}

			/* Glue the remainder of the URL together (only including the port if explicitly specified) */ 

			return urlString + url.host + ( url.port != "" ? ":" + url.port : "" ) + url.path + url.query + url.fragment;
		};

		/**
		 *
		 *	Function: sanitiseUrl
		 *
		 *	Sanitise a URL. Creates a fully qualified URL by converting it from a string to a DOM element and back to a string again.
		 *
		 *	Parameters: 
		 *
		 *	url - The URL to sanitise.
		 *
		 *	Returns:
		 *
		 *	The sanitised URL string.
		 *
		 **/ 

		var sanitiseUrl = function ( url )
		{
			return uri.parse ( url ).toString ( );
		};

		/**
		 *
		 *	Function: urlObjectToString
		 *
		 *	Converts a URL object to a string (used to override toString for URL objects).
		 *
		 *	Parameters: 
		 *
		 *	this - The URL object to convert to a string.
		 *
		 *	Returns:
		 *
		 *	The URL string.
		 *
		 **/ 

		var urlObjectToString = function ( )
		{
			return objectToUrl ( this );
		};

		/**
		 *
		 *	Function: setUrlSegment
		 *
		 *	Set the value of a segment within a URL string.
		 *
		 *	Parameters: 
		 *
		 *	url - The URL to modify.
		 *
		 *	segment - The segment of the URL to modify ("scheme", "host", "port", "path", "query" or "fragment").
		 *
		 *	value - The new segment value.
		 *
		 *	Returns:
		 *
		 *	The URL string containing the update segment.
		 *
		 **/ 

		var setUrlSegment = function ( url, segment, value )
		{
			/* Convert the URL to an object */ 

			var urlObject = uri.parse ( url );

			/* Update the URL segment */ 

			urlObject [ segment ] = value;

			/* Convert the URL object back to a string */ 

			return objectToUrl ( urlObject );
		};

		/**
		 *
		 *	Function: getUrlObject
		 *
		 *	Convert a URL string to an object, if not already. Used to ensure we always work with URL objects where either a string or object can be supplied.
		 *
		 *	Parameters: 
		 *
		 *	url - URL string or object.
		 *
		 *	Returns:
		 *
		 *	URL object.
		 *
		 **/ 

		var getUrlObject = function ( url )
		{
			/* Is the URL a string? */ 

			if ( typeof url == "string" )
			{
				/* Return the URL string converted to an object */ 

				return uri.parse ( url );
			}

			/* Return the URL object */ 

			return url;
		};

		/**
		 *
		 *	Function: getFragmentString
		 *
		 *	Retrieve the fragment string for a given URL.
		 *
		 *	Parameters: 
		 *
		 *	url - URL string or object.
		 *
		 *	Returns:
		 *
		 *	The fragment string.
		 *
		 **/ 

		var getFragmentString = function ( url )
		{
			return getUrlObject ( url ).fragment;
		};

		/**
		 *
		 *	Function: getQueryString
		 *
		 *	Retrieve the query string for a given URL.
		 *
		 *	Parameters: 
		 *
		 *	url - URL string or object.
		 *
		 *	Returns:
		 *
		 *	The query string.
		 *
		 **/ 

		var getQueryString = function ( url )
		{
			/* Get the query string from the URL object */ 

			var query = getUrlObject ( url ).query;

			/* Anything?`*/ 

			if ( query [ 0 ] == "?" )
			{
				/* Strip the leading "?" (makes .split() happy later) */ 

				return query.slice ( 1 );
			}

			/* Return the (probably not very valid?) query */ 

			return query;
		};

		/**
		 *
		 *	Function: updateQuery
		 *
		 *	Update the query string for the elements URL.
		 *
		 *	Parameters: 
		 *
		 *	this - The element to set the new query string on.
		 *
		 *	query - New query object.
		 *
		 **/ 

		var updateQuery = function ( query )
		{
			var queryObject = { };

			/* Get the query object for the current URL */ 

			var currentQueryObject = getQueryObject ( getHref.apply ( this ) );

			/* Was a string supplied as the parameter? */ 

			if ( typeof query == "string" )
			{
				/* If the first character is a "?", then replace the whole query string */ 

				if ( query [ 0 ] == "?" )
				{
					/* Trash the existing query object */ 

					currentQueryObject = { };

					/* Strip the leading question mark */ 

					query = query.substring ( 1 );
				}

				/* Convert the supplied query string to an object */ 

				queryObject = queryStringToObject ( query );
			}
			else
			{
				queryObject = query;
			}

			/* Did the supplied query object contain parameters? */ 

			if ( $.isEmptyObject ( queryObject ) == false )
			{
				/* Extend the existing query object with the new query object */ 

				queryObject = $.extend ( currentQueryObject, queryObject );
			}
			else
			{
				/* An empty query object was supplied, so null the query string */ 

				currentQueryObject = { };
			}

			/* Convert the query object to a string, and update the URL query string */ 

			updateHref.apply ( this, [ "query", queryObjectToString.apply ( queryObject ) ] );
		};

		/**
		 *
		 *	Function: queryStringToObject
		 *
		 *	Convert a query string to an object.
		 *
		 *	Parameters: 
		 *
		 *	query - Query string to convert to an object.
		 *
		 *	Returns:
		 *
		 *	The query object.
		 *
		 **/ 

		var queryStringToObject = function ( query )
		{
			var object = { };

			/* Was a query string supplied? */ 

			if ( query != "" )
			{
				/* Get all elements of the query string ("&name=value") */ 

				var elements = query.split ( "&" );

				/* Create the query object */ 

				for ( var i = 0; i < elements.length; i++ )
				{
					/* Retrieve the parameter name and value from the string "name=value" */ 

					var parameter = elements [ i ].split ( "=" );

					/* Add the parameter to the query object */ 

					object [ parameter [ 0 ] ] = parameter [ 1 ];
				}
			}

			/* Return the query object */ 

			return object;
		};

		/**
		 *
		 *	Function: getQueryObject
		 *
		 *	Retrieve the query object for a given URL.
		 *
		 *	Parameters: 
		 *
		 *	url - URL string or object.
		 *
		 *	Returns:
		 *
		 *	The query object.
		 *
		 **/ 

		var getQueryObject = function ( url )
		{
			/* Get the query string from the URL and convert it to an object */ 

			return queryStringToObject ( getQueryString ( url ) );
		};

		/**
		 *
		 *	Function: queryObjectToString
		 *
		 *	Query objects toString method.
		 *
		 *	Parameters: 
		 *
		 *	this - Query object.
		 *
		 *	Returns:
		 *
		 *	The query string.
		 *
		 **/ 

		var queryObjectToString = function ( )
		{
			var string = "";

			/* For each item in the query string */ 

			for ( var i in this )
			{
				/* Ensure that it contains valid data */ 

				if ( i != "toString" && this [ i ] != null )
				{
					string += "&" + i + "=" + this [ i ];
				}
			}

			/* Anything? */ 

			if ( string [ 0 ] == "&" )
			{
				/* Return the query string (replacing the first "&" character with a "?" character. */ 

				string = "?" + string.slice ( 1 );
			}
 
			/* Empty query string */ 

			return string;
		};

		/**
		 *
		 *	Function: getPathString
		 *
		 *	Retrieve the path string for a given URL.
		 *
		 *	Parameters: 
		 *
		 *	url - URL string or object.
		 *
		 *	Returns:
		 *
		 *	The path string.
		 *
		 **/ 

		var getPathString = function ( url )
		{
			/* Get the path string from the URL object */ 

			var path = getUrlObject ( url ).path;

			/* Ensure the path starts with a leading slash */ 

			if ( path [ 0 ] == "/" )
			{
				/* Strip the leading slash from the path */ 

				return path.slice ( 1 );
			}

			/* Empty or malformed path */ 

			return path;
		};

		/**
		 *
		 *	Function: getPathObject
		 *
		 *	Retrieve the path object for a given URL.
		 *
		 *	Parameters: 
		 *
		 *	url - URL string or object.
		 *
		 *	Returns:
		 *
		 *	The path obbject.
		 *
		 **/ 

		var getPathObject = function ( url )
		{
			/* Get the path string from the URL object (without leading slash) */ 

			var pathString = getPathString ( url );

			/* Anything? */ 

			if ( pathString != "" )
			{
				/* Create the path object */ 

				return pathString.split ( "/" );
			}

			/* No path specified */ 

			return [ ];
		};

		/**
		 *
		 *	Function: updatePath
		 *
		 *	Update the path string for the elements URL.
		 *
		 *	Parameters: 
		 *
		 *	this - The element to set the new path string on.
		 *
		 *	path - New path object.
		 *
		 **/ 

		var updatePath = function ( path )
		{
			var pathString = "";

			/* Get an array of existing path elements */ 

			var pathArray = getUrlObject ( getHref.apply ( this ) ).path.split ( "/" );

			/* Get an array of new path elements */ 

			var newPathArray = path.split ( "/" );
			var i = 0;

			/* Was the first character a "/"? */ 

			if ( newPathArray [ 0 ] == "" )
			{
				/* Truncate the existing path */ 

				pathArray = [ ];

				i++;
			}

			/* Remove the initial empty path element */ 

			pathArray.splice ( 0, 1 );

			/* Iterate through all new path elements */ 

			for ( var l = newPathArray.length; i < l; i++ )
			{
				/* Remove an old path element? */ 

				if ( newPathArray [ i ] == ".." )
				{
					/* Remove the element from the path array */ 

					if ( pathArray.length > 0 )
					{
						pathArray.splice ( pathArray.length - 1, 1 );
					}
				}
				else if ( newPathArray [ i ] == "." )
				{
					/* Current directory */ 
				}
				else
				{
					/* Include the new path element */ 

					pathArray.push ( newPathArray [ i ] );
				}
			}

			/* Update the path string */ 

			updateHref.apply ( this, [ "path", pathObjectToString.apply ( pathArray ) ] );
		};

		/**
		 *
		 *	Function: pathObjectToString
		 *
		 *	Path objects toString method.
		 *
		 *	Parameters: 
		 *
		 *	this - Path object.
		 *
		 *	Returns:
		 *
		 *	The path string.
		 *
		 **/ 

		var pathObjectToString = function ( )
		{
			/* Are there any path elements? */ 

			if ( this.length > 0 )
			{
				/* Join all elements with a "/", and return the leading path slash again */ 

				return "/" + this.join ( "/" );
			}

			/* No path */ 

			return "/";
		};

		/**
		 *
		 *	Function: getPortString
		 *
		 *	Retrieve the port string for a given URL.
		 *
		 *	Parameters: 
		 *
		 *	url - URL string or object.
		 *
		 *	Returns:
		 *
		 *	The port string.
		 *
		 **/ 

		var getPortString = function ( url )
		{
			return getUrlObject ( url ).port;
		};

		/**
		 *
		 *	Function: getHostString
		 *
		 *	Retrieve the host string for a given URL.
		 *
		 *	Parameters: 
		 *
		 *	url - URL string or object.
		 *
		 *	Returns:
		 *
		 *	The host string.
		 *
		 **/ 

		var getHostString = function ( url )
		{
			return getUrlObject ( url ).host;
		};

		/**
		 *
		 *	Function: getPasswordString
		 *
		 *	Retrieve the password string for a given URL.
		 *
		 *	Parameters: 
		 *
		 *	url - URL string or object.
		 *
		 *	Returns:
		 *
		 *	The password string.
		 *
		 **/ 

		var getPasswordString = function ( url )
		{
			return getUrlObject ( url ).password;
		};

		/**
		 *
		 *	Function: getUserString
		 *
		 *	Retrieve the user string for a given URL.
		 *
		 *	Parameters: 
		 *
		 *	url - URL string or object.
		 *
		 *	Returns:
		 *
		 *	The user string.
		 *
		 **/ 

		var getUserString = function ( url )
		{
			return getUrlObject ( url ).user;
		};

		/**
		 *
		 *	Function: getSchemeString
		 *
		 *	Retrieve the scheme string for a given URL.
		 *
		 *	Parameters: 
		 *
		 *	url - URL string or object.
		 *
		 *	Returns:
		 *
		 *	The scheme string.
		 *
		 **/ 

		var getSchemeString = function ( url )
		{
			return getUrlObject ( url ).scheme;
		};

		/**
		 *
		 *	Function: addSelectorCallback
		 *
		 *	Add a function the selector callstack.
		 *
		 **/ 

		var addSelectorCallback = function ( element, callback, parameters )
		{
			if ( element.data ( "is-watched" ) == true )
			{
				return;
			}

			if ( selectorCallStack [ currentSelector ] )
			{
				selectorCallStack [ currentSelector ].push ( [ callback, parameters ] );
			}
		};

		/**
		 *
		 *	Function: returnEachElement
		 *
		 *	Apply the callback for each element in this. Used for methods that return elements.
		 *
		 *	Parameters:
		 *
		 *	this Array of elements to iterate through.
		 *
		 *	callback Function to call for each element found.
		 *
		 *	parameters Callback function parameters (array).
		 *
		 *	Returns:
		 *
		 *	Array of elements.
		 *
		 **/ 

		var returnEachElement = function ( callback, parameters )
		{
			/* Is this an object, containing an href member? */ 

			if ( this.href != null )
			{
				/* Issue the callback */ 

				callback.apply ( this, [ parameters ] );

				/* Return the object (for chaining purposes) */ 

				return this;
			}

			/* Add this function and parameters to the watch selector callstack (if watched) */ 

			addSelectorCallback ( this, callback, [ parameters ] );

			/* Return all elements, after applying the callback */ 

			return this.each
			(
				function ( )
				{
					callback.apply ( $( this ), [ parameters ] );
				}
			);
		};

		/**
		 *
		 *	Function: returnEachObject
		 *
		 *	Apply the callback for each element in this, and buffer return codes. Used for methods that return data.
		 *
		 *	Parameters:
		 *
		 *	this Array of elements to iterate through.
		 *
		 *	callback Function to call for each element found.
		 *
		 *	parameters Callback function parameters (array).
		 *
		 *	Returns:
		 *
		 *	Array of return codes.
		 *
		 **/ 

		var returnEachObject = function ( callback, parameters )
		{
			if ( this.href != null )
			{
				return callback.apply ( this, [ parameters ] );
			}

			var result = [ ];

			/* Build and return an array of each elements callback results */ 

			this.each
			(
				function ( )
				{
					result.push ( callback.apply ( $( this ), [ parameters ] ) );
				}
			);

			return result;
		};

		/**
		 *
		 *	Function: dispatchGetSetHelper
		 *
		 *	Dispatch to get or set helper functions depending on the arguments supplied.
		 *
		 *	If no user arguments are supplied, perform the get, ortherwise perform the set with the user arguments.
		 *
		 *	Parameters:
		 *
		 *	getHelper - Get URL data callback.
		 *
		 *	setHelper - Set URL data callback.
		 *
		 *	helperArguments - User arguments supplied to the public interface.
		 *
		 *	Returns:
		 *
		 *	get/setHelper() return code.
		 *
		 **/ 

		var dispatchGetSetHelper = function ( getHelper, setHelper, helperArguments )
		{
			if ( helperArguments.length == 0 )
			{
				return getHelper.apply ( this )
			}
			
			return setHelper.apply ( this, helperArguments )
		};

		/**
		 *
		 *	Function: methodDispatcher
		 *
		 *	Main method dispatcher for the public interface.
		 *
		 *	Parameters: method
		 *
		 *	method - The method to perform.
		 *
		 *	Returns:
		 *
		 *	Array of method handler results (either elements for set/filter methods, or strings/objects for get methods).
		 *
		 */ 

		var methodDispatcher = function ( method )
		{
			/* Is the method name valid */ 

			if ( methods [ method ] != null )
			{
				/* Dispatch to the method handler */ 

				return methods [ method ].apply ( this, Array.prototype.slice.call ( arguments, 1 ) );
			}
			else if ( typeof method == "object" || method == null )
			{
				/* No method, or an object was supplied, initialise the element(s) */ 

				return methods.initialise.apply ( this, Array.prototype.slice.call ( arguments, 1 ) );
			}

			/* Invalid method/parameters */ 

			return this;
		};

		/**
		 *
		 *	Section: URI parser interface.
		 *
		 *	All URI parsing is handled through this interface.
		 *
		 *	This section contains all parser interfaces utilised by the public parser interface.
		 *
		 *	ToDo: Extend this interface with the current URL segment parsing logic, and implement a more comprehensive URI parser set.
		 *
		 *	See http://en.wikipedia.org/wiki/URI_scheme for an overview of URIs.
		 *
		 **/ 

		var uri =
		{
			/**
			 *
			 *	All URI object to string methods.
			 *
			 **/ 

			toString :
			{
				/**
				 *
				 *	Function: uri.toString.http
				 *
				 *	Converts a URI object with an "http" scheme to a string.
				 *
				 **/ 

				"http" : function ( )
				{
					return objectToUrl ( this );
				},

				/**
				 *
				 *	Function: uri.toString.mailto
				 *
				 *	Converts a URI object with a "mailto:" scheme to a string.
				 *
				 **/ 

				"mailto" : function ( )
				{
					/* Blank invalid fields */ 

					this.password = "";
					this.path = "";
					this.port = "";

					return objectToUrl ( this );
				},

				/**
				 *
				 *	Function: uri.toString.javascript
				 *
				 *	Converts a URI object with a "javascript:" scheme to a string.
				 *
				 **/ 

				"javascript" : function ( )
				{
					return "javascript:" + this.javascript;
				},

				/**
				 *
				 *	Function: uri.toString.generic
				 *
				 *	Converts an generic URI object to a string.
				 *
				 **/ 

				"generic" : function ( )
				{
					return this.scheme + this.url;
				}
			},

			/**
			 *
			 *	All URI string parsers.
			 *
			 **/ 

			parsers :
			{
				/**
				 *
				 *	Function: uri.parsers.http
				 *
				 *	Parse a URI with a "http://" scheme into a URI object.
				 *
				 **/ 

				"http" : function ( url )
				{
					return $.extend ( urlToObject ( url ), { toString : uri.toString.http } );
				},

				/**
				 *
				 *	Function: uri.parsers.mailto
				 *
				 *	Parse a URI with a "mailto:" scheme into a URI object.
				 *
				 **/ 

				"mailto" : function ( url )
				{

					return $.extend ( urlToObject ( url.substring ( 7 ) ), { scheme : "mailto:", toString : uri.toString.mailto } );
				},

				/**
				 *
				 *	Function: uri.parsers.javascript
				 *
				 *	Parse a URI with a "javascript:" scheme into a URI object.
				 *
				 **/ 

				"javascript" : function ( url )
				{
					return $.extend ( urlToObject ( document.location.href ), { javascript : url.substring ( 11 ), toString : uri.toString.javascript } );
				},

				/**
				 *
				 *	Function: uri.parsers.generic
				 *
				 *	Parses any URI (URIs with a scheme seperator of "://" are parsed as "http://", everything else is treated as unknown..
				 *
				 **/ 

				"generic" : function ( scheme, url )
				{
					/* Was a "//" specified in the scheme? */ 

					if ( url.substring ( 0, 2 ) == "//" )
					{
						/* Parse as HTTP URL */ 

						return $.extend ( urlToObject ( url.substring ( 2 ) ), { scheme : scheme + "://", toString : uri.toString.http } );
					}

					/* Unknown, store the schem (for filtering purposes), and simply append the remainder of the URI */ 

					return { scheme : scheme + ":", url : url, toString : uri.toString.generic };
				}
			},

			/**
			 *
			 *	Function: uri.parse
			 *
			 *	Parse a URI string based on scheme.
			 *
			 **/ 

			parse : function ( uri )
			{
				/* Only parse strings */ 

				if ( typeof uri != "string" )
				{
					/* URI object? */ 

					return uri;
				}

				/* Try to determine the scheme */ 

				var pos = uri.indexOf ( ":" );

				/* Was a scheme seperator found? */ 

				if ( pos != -1 )
				{
					/* Get the scheme name (from the start of the URI, until the first ":" character)*/ 

					var scheme = uri.substring ( 0, pos ).toLowerCase ( );

					/* Is a handler present for this scheme? */ 

					if ( this.parsers [ scheme ] != null )
					{
						/* Parse the URI with a specific parser */ 

						return this.parsers [ scheme ] ( uri );
					}

					/* Try to parse the URI generically */ 

					return this.parsers.generic ( scheme, uri.substring ( pos + 1 ) );
				}

				/* Parse the URI with the HTTP parser, for now... */ 

				return this.parsers.http ( uri );
			}
		};

		/**
		 *
		 *	Section: Helper interface.
		 *
		 *	All private helper methods.
		 *
		 *	This section contains all get/set and filter methods utilised by the public interface.
		 *
		 **/ 

		var helpers =
		{
			/**
			 *
			 *	Function: getUrl
			 *
			 *	Return the elements URL (stored under its "data-href", and/or "href"/"src" attribute).
			 *
			 **/ 

			"getUrl" : function ( )
			{
				return returnEachObject.apply ( this, [ getHref, null ] );
			},

			/**
			 *
			 *	Function: setUrl
			 *
			 *	Set the elements URL (stored under it's "data-href", and/or "href"/"src" attribute). Note: This does not change document.location.href for the $(document) element!
			 *
			*/ 

			"setUrl" : function ( url )
			{
				setHref.apply ( this, [ url ] );
			},

			/**
			 *
			 *	Function: parseUrl
			 *
			 *	Return the URL object for the elements "data-href" attribute value.
			 *
			 **/ 

			"parseUrl" : function ( )
			{
				return returnEachObject.apply ( this, [ function ( ) { return uri.parse ( getHref.apply ( this ) ); }, null ] );
			},

			/**
			 *
			 *	Function: getFragment
			 *
			 *	Get the fragment object from the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to retrieve the fragment object from.
			 *
			 *	Returns:
			 *
			 *	The fragment object. Call .toString() on the object to convert it to a string value.
			 *
			 **/ 

			"getFragment" : function ( )
			{
				return returnEachObject.apply ( this, [ function ( ) { return getFragmentString ( getHref.apply ( this ) ); }, null ] );
			},

			/**
			 *
			 *	Function: setFragment
			 *
			 *	Set the fragment string for the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to set the fragment string on.
			 *
			 *	fragment - The new fragment string/object.
			 *
			 *	Returns:
			 *
			 *	Array of elements that were changed.
			 *
			 **/ 

			"setFragment" : function ( fragment )
			{
				if ( fragment [ 0 ] != "#" )
				{
					fragment = "#" + fragment;
				}

				return returnEachElement.apply ( this, [ updateHrefShim, [ "fragment", fragment ] ] );
			},

			/**
			 *
			 *	Function: getQuery
			 *
			 *	Get the query object from the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to retrieve the query object from.
			 *
			 *	Returns:
			 *
			 *	The query object. Call .toString() on the object to convert it to a string value.
			 *
			 **/ 

			"getQuery" : function ( )
			{
				return returnEachObject.apply ( this, [ function ( ) { return $.extend ( getQueryObject ( getHref.apply ( this ) ), { toString : queryObjectToString } ); }, null ] );
			},

			/**
			 *
			 *	Function: setQuery
			 *
			 *	Set the query string for the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to set the query object on.
			 *
			 *	query - The new query string represented as an object.
			 *
			 *	Returns:
			 *
			 *	Array of elements that were changed.
			 *
			 **/ 

			"setQuery" : function ( query )
			{
				return returnEachElement.apply ( this, [ updateQuery, query ] );
			},

			/**
			 *
			 *	Function: getPath
			 *
			 *	Get the path object from the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to retrieve the path object from.
			 *
			 *	Returns:
			 *
			 *	The path object. Call .toString() on the object to convert it to a string value.
			 *
			 **/ 

			"getPath" : function ( )
			{
				return returnEachObject.apply ( this, [ function ( ) { return $.extend ( getPathObject ( getHref.apply ( this ) ), { toString : pathObjectToString } ); }, null ] );
			},

			/**
			 *
			 *	Function: setPath
			 *
			 *	Set the path string for the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to set the path string on.
			 *
			 *	path - The new path string/object.
			 *
			 *	Returns:
			 *
			 *	Array of elements that were changed.
			 *
			 **/ 

			"setPath" : function ( path )
			{
				return returnEachElement.apply ( this, [ updatePath, path ] );
			},

			/**
			 *
			 *	Function: getPort
			 *
			 *	Get the port string from the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to retrieve the port string from.
			 *
			 *	Returns: 
			 *
			 *	The port string.
			 *
			 **/ 

			"getPort" : function ( )
			{
				return returnEachObject.apply ( this, [ function ( ) { return getPortString ( getHref.apply ( this ) ); }, null ] );
			},

			/**
			 *
			 *	Function: setPort
			 *
			 *	Set the port string for the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to set the port string on.
			 *
			 *	port - The new port string.
			 *
			 *	Returns: 
			 *
			 *	Array of elements that were changed.
			 *
			 **/ 

			"setPort" : function ( port )
			{
				return returnEachElement.apply ( this, [ updateHrefShim, [ "port", port ] ] );
			},

			/**
			 *
			 *	Function: getHost
			 *
			 *	Get the host string from the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to retrieve the host string from.
			 *
			 *	Returns: 
			 *
			 *	The host string.
			 *
			 **/ 

			"getHost" : function ( )
			{
				return returnEachObject.apply ( this, [ function ( ) { return getHostString ( getHref.apply ( this ) ); }, null ] );
			},

			/**
			 *
			 *	Function: setHost
			 *
			 *	Set the host string for the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to set the host string on.
			 *
			 *	host - The new host string.
			 *
			 *	Returns: 
			 *
			 *	Array of elements that were changed.
			 *
			 **/ 

			"setHost" : function ( host )
			{
				return returnEachElement.apply ( this, [ updateHrefShim, [ "host", host ] ] );
			},

			/**
			 *
			 *	Function: getPassword
			 *
			 *	Get the password string from the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to retrieve the password string from.
			 *
			 *	Returns: 
			 *
			 *	The password string.
			 *
			 **/ 

			"getPassword" : function ( )
			{
				return returnEachObject.apply ( this, [ function ( ) { return getPasswordString ( getHref.apply ( this ) ); }, null ] );
			},

			/**
			 *
			 *	Function: setPassword
			 *
			 *	Set the password string for the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to set the password string on.
			 *
			 *	password - The new password string.
			 *
			 *	Returns: 
			 *
			 *	Array of elements that were changed.
			 *
			 **/ 

			"setPassword" : function ( password )
			{
				return returnEachElement.apply ( this, [ updateHrefShim, [ "password", password ] ] );
			},

			/**
			 *
			 *	Function: getUser
			 *
			 *	Get the user string from the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to retrieve the user string from.
			 *
			 *	Returns: 
			 *
			 *	The user string.
			 *
			 **/ 

			"getUser" : function ( )
			{
				return returnEachObject.apply ( this, [ function ( ) { return getUserString ( getHref.apply ( this ) ); }, null ] );
			},

			/**
			 *
			 *	Function: setUser
			 *
			 *	Set the user string for the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to set the user string on.
			 *
			 *	user - The new user string.
			 *
			 *	Returns: 
			 *
			 *	Array of elements that were changed.
			 *
			 **/ 

			"setUser" : function ( user )
			{
				return returnEachElement.apply ( this, [ updateHrefShim, [ "user", user ] ] );
			},

			/**
			 *
			 *	Function: getScheme
			 *
			 *	Get the scheme string from the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to retrieve the scheme string from.
			 *
			 *	Returns: 
			 *
			 *	The scheme string.
			 *
			 **/ 

			"getScheme" : function ( )
			{
				return returnEachObject.apply ( this, [ function ( ) { return getSchemeString ( getHref.apply ( this ) ); }, null ] );
			},

			/**
			 *
			 *	Function: setScheme
			 *
			 *	Set the scheme string for the elements URL.
			 *
			 *	Parameters: 
			 *
			 *	this - The element to set the scheme string on.
			 *
			 *	scheme - The new scheme string.
			 *
			 *	Returns: 
			 *
			 *	Array of elements that were changed.
			 *
			 **/ 

			"setScheme" : function ( scheme )
			{
				return returnEachElement.apply ( this, [ updateHrefShim, [ "scheme", scheme ] ] );
			},

			"filters" :
			{
				/**
				 *
				 *	Function: = (equals)
				 *
				 *	Test if the actual value is equal to the user supplied value.
				 *
				 *	Parameters:
				 *
				 *	actualValue - Actual value.
				 *
				 *	userValue - User supplied value.
				 *
				 *	Returns:
				 *
				 *	true - The actual and user values are equal.
				 *
				 *	false - The actual and user values are not equal.
				 *
				 **/ 

				"=" : function ( actualValue, userValue )
				{
					if ( actualValue == userValue )
					{
						return true;
					}

					return false;
				},

				/**
				 *
				 *	Function: != (not equals)
				 *
				 *	Test if the actual value is equal to the user supplied value.
				 *
				 *	Parameters:
				 *
				 *	actualValue - Actual value.
				 *
				 *	userValue - User supplied value.
				 *
				 *	Returns:
				 *
				 *	true - The actual and user values are not equal.
				 *
				 *	false - The actual and user values are equal.
				 *
				 **/ 

				"!=" : function ( actualValue, userValue )
				{
					if ( actualValue != userValue )
					{
						return true;
					}

					return false;
				},

				/**
				 *
				 *	Function: < (less than)
				 *
				 *	Test if the actual value is less than the user supplied value.
				 *
				 *	Parameters:
				 *
				 *	actualValue - Actual value.
				 *
				 *	userValue - User supplied value.
				 *
				 *	Returns:
				 *
				 *	true - The actual value is less than the user supplied value.
				 *
				 *	false - The actual value is greater than or equal to the user supplied value.
				 *
				 **/ 

				"<" : function ( actualValue, userValue )
				{
					if ( actualValue < userValue )
					{
						return true;
					}

					return false;
				},

				/**
				 *
				 *	Function: > (greater than)
				 *
				 *	Test if the actualValue is greater than the user supplied value.
				 *
				 *	Parameters:
				 *
				 *	actualValue - Actual value.
				 *
				 *	userValue - User supplied value.
				 *
				 *	Returns:
				 *
				 *	true - The actual value is greater than the user supplied value.
				 *
				 *	false - The actual value is less than or equal to the user supplied value.
				 *
				 **/ 

				">" : function ( actualValue, userValue )
				{
					if ( actualValue > userValue )
					{
						return true;
					}

					return false;
				},

				/**
				 *
				 *	Function: <= (less than or equal to)
				 *
				 *	Test if the actual value is less than or equal to the user supplied value.
				 *
				 *	Parameters:
				 *
				 *	actualValue - Actual value.
				 *
				 *	userValue - User supplied value.
				 *
				 *	Returns:
				 *
				 *	true - The actual value is less than or equal to the user supplied value.
				 *
				 *	false - The actual value is greater than the user supplied value.
				 *
				 **/ 

				"<=" : function ( actualValue, userValue )
				{
					if ( actualValue <= userValue )
					{
						return true;
					}

					return false;
				},

				/**
				 *
				 *	Function: >= (greater than or equal to)
				 *
				 *	Test if the actual value is greater than or equal to the user supplied value.
				 *
				 *	Parameters:
				 *
				 *	actualValue - Actual value.
				 *
				 *	userValue - User supplied value.
				 *
				 *	Returns:
				 *
				 *	true - The actual value is greater than or equal to the user supplied value.
				 *
				 *	false - The actual value is less than the user supplied value.
				 *
				 **/ 

				">=" : function ( actualValue, userValue )
				{
					if ( actualValue >= userValue )
					{
						return true;
					}

					return false;
				},

				/**
				 *
				 *	Function: *= (contains)
				 *
				 *	Test if the actual value contains the user supplied value.
				 *
				 *	Parameters:
				 *
				 *	actualValue - Actual value.
				 *
				 *	userValue - User supplied value.
				 *
				 *	Returns:
				 *
				 *	true - The actual value contains the user supplied value.
				 *
				 *	false - The actual value does not contain the user supplied value.
				 *
				 **/ 

				"*=" : function ( actualValue, userValue )
				{
					if ( actualValue.indexOf ( userValue ) != -1 )
					{
						return true;
					}

					return false;
				},

				/**
				 *
				 *	Function: ^= (starts with)
				 *
				 *	Test if the start of the actual value matches the user supplied value.
				 *
				 *	Parameters:
				 *
				 *	actualValue - Actual value.
				 *
				 *	userValue - User supplied value.
				 *
				 *	Returns:
				 *
				 *	true - The start of the actual value matches the user supplied value.
				 *
				 *	false - The start of the actual value does not match the user supplied value.
				 *
				 **/ 

				"^=" : function ( actualValue, userValue )
				{
					if ( actualValue.length >= userValue.length )
					{
						if ( actualValue.substring ( 0, userValue.length ) == userValue )
						{
							return true;
						}
					}

					return false;
				},

				/**
				 *
				 *	Function: $= (ends with)
				 *
				 *	Test if the end of the actual value is the same as the user supplied value.
				 *
				 *	Parameters:
				 *
				 *	actualValue - Actual value.
				 *
				 *	userValue - User supplied value.
				 *
				 *	Returns:
				 *
				 *	true - The end of the actual value matches the user supplied value.
				 *
				 *	false - The end of the actual value does not match the user supplied value.
				 *
				 **/ 

				"$=" : function ( actualValue, userValue )
				{
					if ( actualValue.length >= userValue.length )
					{
						if ( actualValue.substring ( actualValue.length - userValue.length ) == userValue )
						{
							return true;
						}
					}

					return false;
				},

				/**
				 *
				 *	Function: regex (regular expression)
				 *
				 *	Test if the actual value matches the user supplied regular expression.
				 *
				 *	Parameters:
				 *
				 *	actualValue - Actual value.
				 *
				 *	userValue - Regular expression to apply.
				 *
				 *	Returns:
				 *
				 *	true - The regular expression matches.
				 *
				 *	false - The regular expression does not match.
				 *
				 **/ 

				"regex" : function ( actualValue, userValue )
				{
					return actualValue.match ( userValue );
				}
			}
		};

		/**
		 *
		 *	Section: Public interface.
		 *
		 *	All public methods exposed via the JQuery URL parser plugin interface.
		 *
		 **/ 

		var methods = 
		{
			/**
			 *
			 *	Function: url
			 *
			 *	Get/Set the href string for the given element(s).
			 *
			 *	Parameters:
			 *
			 *	this - See <this parameter>.
			 *
			 *	url - If present, specifies the new URL object/string to set. Otherwise the function will get the URL.
			 *
			 *	Returns:
			 *
			 *	If a URL was specified, then this function returns the array of modified elements for chaining purposes, otherwise it returns an array of element URLs.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Parse the document.location.href URL
			 *	$(document).jurlp("url");
			 *
			 *	// Parse all URLs in anchor tags
			 *	$("a").jurlp("url");
			 *
			 *	// Update the working URL for the document
			 *	$(document).jurlp("url", "http://www.google.com");
			 *
			 *	// Replace all anchor tags with the google URL!
			 *	$("a").jurlp("url", "http://www.google.com");
			 *
			 *	// Output the documents URL object
			 *	console.log($(document).jurlp("url"));
			 *
			 *	// Output the documents URL string
			 *	console.log($(document).jurlp("url").toString());
			 *
			 *	(end code)
			 *
			 **/

			"url" : function ( url )
			{
				return dispatchGetSetHelper.apply ( this, [ helpers.parseUrl, helpers.setUrl, arguments ] );
			},

			/**
			 *
			 *	Function: fragment
			 *
			 *	Get/Set the fragment segment of the URL for the given element(s).
			 *
			 *	Parameters:
			 *
			 *	this - See <this parameter>.
			 *
			 *	fragment - If present, specifies the new fragment string to set. Otherwise the function will get the fragment string from each elements URL.
			 *
			 *	Returns:
			 *
			 *	If a fragment string was specified, then this function returns the array of modified elements for chaining purposes, otherwise it returns an array of URL fragments from each element.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Parse the document.location.href URL for the fragment string
			 *	$(document).jurlp("fragment");
			 *
			 *	// Parse all URLs in anchor tags and retrieve their fragment strings
			 *	$("a").jurlp("fragment");
			 *
			 *	// Set a new fragment for the document
			 *	$(document).jurlp("fragment", "elementid");
			 *
			 *	// Replace the fragment string in all anchor tags with the new element ID
			 *	$("a").jurlp("fragment", "elementid");
			 *
			 *	// Output the documents URL fragment
			 *	console.log($(document).jurlp("fragment"));
			 *
			 *	(end code)
			 *
			 **/

			"fragment" : function ( fragment )
			{
				return dispatchGetSetHelper.apply ( this, [ helpers.getFragment, helpers.setFragment, arguments ] );
			},

			/**
			 *
			 *	Function: query
			 *
			 *	Get/Set the query segment of the URL for the given element(s).
			 *
			 *	Parameters:
			 *
			 *	this - See <this parameter>.
			 *
			 *	query - If present, specifies the new query object to set. Otherwise the function will get the query object from each elements URL.
			 *
			 *	Returns:
			 *
			 *	If a query object was specified, then this function returns the array of modified elements for chaining purposes, otherwise it returns an array of URL query objects from each element. Each returned query object can be converted to a string by calling its toString() method.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Parse the document.location.href URL for the query object
			 *	$(document).jurlp("query");
			 *
			 *	// Parse all URLs in anchor tags and retrieve their query object
			 *	$("a").jurlp("query");
			 *
			 *	// Set/update the "new" parameter in the query string for the document
			 *	$(document).jurlp("query", {"new":"parameter"});
			 *
			 *	// Remove the query string for the document
			 *	$(document).jurlp("query", {});
			 *
			 *	// Update the query string in all anchor tags with the new query object.
			 *	$("a").jurlp("query", {"new":"parameter"});
			 *
			 *	// Remove the query string in all anchor tags.
			 *	$("a").jurlp("query", {});
			 *
			 *	// Output the documents URL query object
			 *	console.log($(document).jurlp("query"));
			 *
			 *	// Output the documents URL query string
			 *	console.log($(document).jurlp("query").toString());
			 *
			 *	(end code)
			 *
			 **/

			"query" : function ( query )
			{
				return dispatchGetSetHelper.apply ( this, [ helpers.getQuery, helpers.setQuery, arguments ] );
			},

			/**
			 *
			 *	Function: path
			 *
			 *	Get/Set the path segment of the URL for the given element(s).
			 *
			 *	Parameters:
			 *
			 *	this - See <this parameter>.
			 *
			 *	path - If present, specifies the new path to set. Otherwise the function will get the path object from each elements URL.
			 *
			 *	A quick guide to paths:
			 *
			 *	- Leading slashes (i.e. "/index.html") set the full path.
			 *
			 *	- No leading slash (or a "./") will append to the existing path.
			 *
			 *	- You can use "../" to remove elements from the existing path, or the path string you supply (which makes concatinating an existing file path and new path easy, as specifying a leading "../" in the new path will remove the file name segment of the existing path).
			 *
			 *	Returns:
			 *
			 *	If a path was specified, then this function returns the array of modified elements for chaining purposes, otherwise it returns an array of URL path objects from each element. Each returned path object can be converted to a string by calling its toString() method.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Parse the document.location.href URL for the path object
			 *	$(document).jurlp("path");
			 *
			 *	// Parse all URLs in anchor tags and retrieve their path object
			 *	$("a").jurlp("path");
			 *
			 *	// Set a new path for the document
			 *	$(document).jurlp("path", "/index.html");
			 *
			 *	// Append a path to the document URLs path
			 *	$(document).jurlp("path", "./file.name");
			 *
			 *	// Append a path to the document URLs path, which removes 2 existing path
			 *	// elements before appending the new path 
			 *	$(document).jurlp("path", "../../folder/file.name");
			 *
			 *	// Update the file name segment of the path in all anchor tags 
			 *	// with the new file name.
			 *	$("a").jurlp("path", "../file.name");
			 *
			 *	// Remove the path in all anchor tags.
			 *	$("a").jurlp("path", "/");
			 *
			 *	// Output the documents URL path object
			 *	console.log($(document).jurlp("path"));
			 *
			 *	// Output the documents URL path string
			 *	console.log($(document).jurlp("path").toString());
			 *
			 *	(end code)
			 *
			 **/

			"path" : function ( path )
			{
				return dispatchGetSetHelper.apply ( this, [ helpers.getPath, helpers.setPath, arguments ] );
			},

			/**
			 *
			 *	Function: port
			 *
			 *	Get/Set the port segment of the URL for the given element(s).
			 *
			 *	Parameters:
			 *
			 *	this - See <this parameter>.
			 *
			 *	port - If present, specifies the new port to set. Otherwise the function will get the port string from each elements URL.
			 *
			 *	Returns:
			 *
			 *	If a port was specified, then this function returns the array of modified elements for chaining purposes, otherwise it returns an array of port strings from each elements URL.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Parse the document.location.href URL for the port
			 *	$(document).jurlp("port");
			 *
			 *	// Parse all URLs in anchor tags and retrieve their port
			 *	$("a").jurlp("port");
			 *
			 *	// Set a new port for the document
			 *	$(document).jurlp("port", "8080");
			 *
			 *	// Replace the port in all anchor tags with the new port number
			 *	$("a").jurlp("port", "8080");
			 *
			 *	// Output the documents URL port
			 *	console.log($(document).jurlp("port"));
			 *
			 *	(end code)
			 *
			 **/

			"port" : function ( port )
			{
				return dispatchGetSetHelper.apply ( this, [ helpers.getPort, helpers.setPort, arguments ] );
			},

			/**
			 *
			 *	Function: host
			 *
			 *	Get/Set the host segment of the URL for the given element(s).
			 *
			 *	Parameters:
			 *
			 *	this - See <this parameter>.
			 *
			 *	host - If present, specifies the new host name to set. Otherwise the function will get the host name string from each elements URL.
			 *
			 *	Returns:
			 *
			 *	If a host name was specified, then this function returns the array of modified elements for chaining purposes, otherwise it returns an array of host name strings from each elements URL.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Parse the document.location.href URL for the host name
			 *	$(document).jurlp("host");
			 *
			 *	// Parse all URLs in anchor tags and retrieve their host name
			 *	$("a").jurlp("host");
			 *
			 *	// Set a new host name for the document
			 *	$(document).jurlp("host", "www.example.com");
			 *
			 *	// Replace the host name in all anchor tags with the new host name
			 *	$("a").jurlp("host", "www.example.com");
			 *
			 *	// Output the documents URL host name
			 *	console.log($(document).jurlp("host"));
			 *
			 *	(end code)
			 *
			 **/

			"host" : function ( host )
			{
				return dispatchGetSetHelper.apply ( this, [ helpers.getHost, helpers.setHost, arguments ] );
			},

			/**
			 *
			 *	Function: password
			 *
			 *	Get/Set the password segment of the URL for the given element(s).
			 *
			 *	Note! A password cannot be set on a URL unless a user name has been set first (see <user>).
			 *
			 *	Parameters:
			 *
			 *	this - See <this parameter>.
			 *
			 *	password - If present, specifies the new password to set. Otherwise the function will get the password string from each elements URL.
			 *
			 *	Returns:
			 *
			 *	If a password was specified, then this function returns the array of modified elements for chaining purposes, otherwise it returns an array of password strings from each elements URL.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Parse all URLs in anchor tags and retrieve their password
			 *	$("a").jurlp("password");
			 *
			 *	// Replace the password in all anchor tags with the new password string
			 *	$("a").jurlp("password", "newpassword");
			 *
			 *	(end code)
			 *
			 **/

			"password" : function ( password )
			{
				return dispatchGetSetHelper.apply ( this, [ helpers.getPassword, helpers.setPassword, arguments ] );
			},

			/**
			 *
			 *	Function: user
			 *
			 *	Get/Set the user segment of the URL for the given element(s).
			 *
			 *	Parameters:
			 *
			 *	this - See <this parameter>.
			 *
			 *	user - If present, specifies the new username to set. Otherwise the function will get the username string from each elements URL.
			 *
			 *	Returns:
			 *
			 *	If a username was specified, then this function returns the array of modified elements for chaining purposes, otherwise it returns an array of username strings from each elements URL.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Parse all URLs in anchor tags and retrieve their username
			 *	$("a").jurlp("user");
			 *
			 *	// Replace the username in all anchor tags with the new username string
			 *	$("a").jurlp("username", "newusername");
			 *
			 *	(end code)
			 *
			 **/

			"user" : function ( user )
			{
				return dispatchGetSetHelper.apply ( this, [ helpers.getUser, helpers.setUser, arguments ] );
			},

			/**
			 *
			 *	Function: scheme
			 *
			 *	Get/Set the scheme segment of the URL for the given element(s).
			 *
			 *	Parameters:
			 *
			 *	this - See <this parameter>.
			 *
			 *	scheme - If present, specifies the new scheme. Otherwise the function will get the scheme string from each elements URL.
			 *
			 *	Returns:
			 *
			 *	If a scheme string was specified, then this function returns the array of modified elements for chaining purposes, otherwise it returns an array of scheme strings from each elements URL.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Parse the document.location.href URL for the scheme
			 *	$(document).jurlp("scheme");
			 *
			 *	// Parse all URLs in anchor tags and retrieve their scheme
			 *	$("a").jurlp("scheme");
			 *
			 *	// Set a new scheme name for the document
			 *	$(document).jurlp("scheme", "https://");
			 *
			 *	// Replace the scheme in all anchor tags href attributes
			 *	$("a").jurlp("scheme", "https://");
			 *
			 *	// Output the documents URL host name
			 *	console.log($(document).jurlp("scheme"));
			 *
			 *	(end code)
			 *
			 **/

			"scheme" : function ( scheme )
			{
				return dispatchGetSetHelper.apply ( this, [ helpers.getScheme, helpers.setScheme, arguments ] );
			},

			/**
			 *
			 *	Function: initialise
			 *
			 *	Initialise the parser for the given element(s). HTML anchor elements or the HTML document element need not be explicitly initialised.
			 *	
			 *	Elements are initialised as follows;
			 *
			 *	$(document) - Initialise the "data-href" attribute for the document with the value of "document.location.href". The "data-href" attribute will be modified instead of "document.location.href" when modifying this element. See <Parsing document.location.href>.
			 *
			 *	Elements with "href"/"src" attributes - An attribute named "data-original-href" or "data-original-src" is created to store a copy of the elements original "href"/"src" attribute at the time of initialisation. See <Parsing elements with an ìhrefî or ìsrcî attribute>.
			 *
			 *	All other elements - Parses the element HTML for URLs, wraps any URLs found in an anchor tag, and returns all anchor elements.
			 *
			 *	Parameters:
			 *
			 *	this - See <this parameter>.
			 *
			 *	Returns:
			 *	
			 *	Array of initialised elements (minus the parent container element).
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Not necessary
			 *	$(document).jurlp();
			 *
			 *	// Not necessary
			 *	$("a").jurlp();
			 *
			 *	// Parse the HTML for URLs, and convert all URLs found in the
			 *	// text to anchors tags, and return the anchor elements.
			 *	$("<div>www.example.com</div>").jurlp();
			 *
			 *	(end code)
			 *
			 **/ 

			"initialise" : function ( )
			{
				var me = this;

				/* Attempt to initialise the element as a text field. */ 

				var elements = [ ];

				elements = initialiseElementText.apply ( $( this ) );

				if ( elements != null )
				{
					/* Initialise and return all created anchor elements, and remove the parent element from the array */ 

					return returnEachElement.apply ( this.filter ( function ( ) { return $( this ).get ( 0 ) != $( me ).get ( 0 ); } ).add ( elements ), [ initialiseElement ] );
				}

				/* Initialise the element directly */ 

				return returnEachElement.apply ( me, [ initialiseElement ] );
			},

			/**
			 *
			 *	Function: restore
			 *
			 *	Removes any parser data associated with the element(s), and sets the href attribute to its original value.
			 *
			 *	$(document) - Removes the "data-href" attribute.
			 *
			 *	Elements with "href"/"src" - Restores the "href"/"src" attribute to the "data-original-href/src" attribute value, and removes any other added attributes.
			 *
			 *	All other elements - Currently there is no way to restore an elements HTML which has been converted by the parser, so consider saving it first if needed!
			 *
			 *	Parameters:
			 *
			 *	this - See <this parameter>.
			 *
			 *	Returns:
			 *
			 *	Array of elements which were restored for chaining purposes.
			 *
			 * 	Examples:
			 * 
			 *	(start code)
			 *
			 *	// Restore the working URL for the document.
			 *	$(document).jurlp("restore");
			 *
			 *	// Restore the URL for all anchor elements.
			 *	$("a").jurlp("restore");
			 *
			 *	(end code)
			 *
			 **/ 

			"restore" : function ( )
			{
				return returnEachElement.apply ( this, [ restoreElement ] );
			},

			/**
			 *
			 *	Function: goto
			 *
			 *	Set document.location.href to the supplied elements "href", "src" or "data-href" attribute value.
			 *
			 *	Parameters:
			 *
			 *	this - See <this parameter>.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Goto the documents URL.
			 *	$(document).jurlp("goto");
			 *
			 *	(end code)
			 *
			 **/ 

			"goto" : function ( )
			{
				document.location.href = getHref.apply ( this );
			},

			/**
			 *
			 *	Function: proxy
			 *
			 *	Proxy the URL. The elements URL will be replaced with the proxy URL, and the original URL will be encapsulated under the query string using the parameter name specified.
			 *
			 *	Parameters:
			 *
			 *	this - See <this parameter>.
			 *
			 *	url - The proxy URL.
			 *
			 *	parameter - The name of the query string parameter to encapsulate the original URL in.
			 *
			 *	Returns:
			 *
			 *	Array of modified elements for chaining purposes.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Proxy all URLs in anchor tags to www.example.com
			 *	// URL becomes "http://www.example.com/?url=<original URL>"
			 *	$("a").jurlp("proxy", "http://www.example.com", "url");
			 *
			 *	(end code)
			 *
			 **/

			"proxy" : function ( url, parameter )
			{
				var elementUrl = getHref.apply ( this );
				var query = { };

				setHref.apply ( this, [ objectToUrl ( getUrlObject ( url ) ) ] );

				query [ parameter ] = elementUrl;

				helpers.setQuery.apply ( this, [ query ] );
			},

			/**
			 *
			 *	function: watch
			 *
			 *	Automatically apply all modifications to new elements added to the DOM that match the selector for the supplied elements. This allows URL filters/modifications that have been applied to existing elements to be propogated to new elements if the page content is being modified (i.e. inserting new anchor tags via AJAX).
			 *
			 *	Overview:
			 *
			 *	Watch will monitor the selector of the supplied elements via a DOM node listener to detect when new elements are inserted. For each new element that is inserted, any prior filters or modifications made to URLs with the same selector will be applied, and the watcher will be alerted via a callback.
			 *
			 *	Note! It is not possible to call watch more than once for the same selector. To do this, try naming the selector differently, i.e. instead of "a", use "a:not(uniqueid)", where "uniqueid" is a nice lengthy descriptive name!
			 *
			 *	To stop watching for updates on a selecter, use <unwatch>.
			 *
			 *	Parameters:
			 *
			 *	this - Array of elements to obtain the selector from. See <this parameter>.
			 *
			 *	callback - Function to call when elements are found, which is supplied two arguments, the new element that was inserted into the DOM, and the selector that triggered the watch.
			 *
			 *	Returns:
			 *
			 *	Array of unmodified elements for chaining purposes.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Add a watch on the first anchor element, and if the host name is 
			 *	// "www.example.com", set the URL query string to "found=example".
			 *	// The "filter" and "query" calls will also be applied to all new elements that 
			 *	// watch discovers!..
			 *	$("a:eq(0)").jurlp("watch", function(element, selector){
			 *		// If we get here, the first anchor element has changed to a URL containing 
			 *		// "www.example.com" and now contains "found=example" in the query string.
			 *		// Dump the URL object to prove it!
			 *		console.log($(element).jurlp("url"));
			 *	}).jurlp("filter", "host", "=", "www.example.com")
			 *	  .jurlp("query",{"found":"example"});
			 *
			 *	//	Prepend a new anchor tag to the page. This will trigger the watch on the 
			 *	//	"a:eq(0)" selector, which will apply all prior calls to this selector, 
			 *	//	so in this instance:
			 *	//	- First perform the filter host, to ensure the host name is "www.example.com".
			 *	//	- If the host name matches, update the URL query string with "found=example").
			 *	// If the host name does not match, then the query string will not be set.
			 *
			 *	$("body").prepend ( "<a href='http://www.example.com/'></a>" );
			 *
			 *	// Stop watching for updates on the "a:eq(0)" selector. 
			 *	// The "a:eq(0)" selector can now be watched on again.
			 *	$("a:eq(0)").jurlp("unwatch");
			 *
			 *	(end code)
			 *
			 *	- Watching the "same selector":
			 *
			 *	(start code)
			 *
			 *	// As an arbitrary example, we want to modify the query string on all existing 
			 *	// facebook/twitter URLs, and then watch the "a" selector for all new 
			 *	// facebook/twitter URLs that appear, and apply the new query string to those too:
			 *
			 *	// THIS WILL NOT WORK!: 
			 *	$("a").jurlp("watch").
			 *	      .jurlp("filter", "host", "=", "www.facebook.com").
			 *	      .jurlp("query",{"found":"facebook"});
			 *
			 *	// This call will fail, as the "a" selector is now watched.
			 *	$("a").jurlp("watch").
			 *	      .jurlp("filter", "host", "=", "www.twitter.com")
			 *	      .jurlp("query",{"found":"twitter"});
			 *
			 *	// THIS WILL WORK!: 
			 *	$("a:not(facebook)").jurlp("watch").
			 *	                    .jurlp("filter", "host", "=", "www.facebook.com")
			 *	                    .jurlp("query",{"found":"facebook"});
			 *
			 *	$("a:not(twitter)").jurlp("watch")
			 *	                   .jurlp("filter", "host", "=", "www.twitter.com")
			 *	                   .jurlp("query",{"found":"twitter"});
			 *
			 *	(end code)
			 *
			 **/

			"watch" : function ( callback )
			{
				/* Get the current selector */ 

				var selector = this.selector;

				/* Has this selector been initialised? */ 

				if ( selectorCallStack [ currentSelector ] == null )
				{
					/* Initialise the selector callstack */ 

					selectorCallStack [ currentSelector ] = [ ];

					/* Monitor the DOM for new nodes being inserted */ 

					$( document ).bind
					(
						"DOMNodeInserted",
						function DOMListener ( event )
						{
							/* Has the selector been unwatched? */ 

							if ( selectorCallStack [ selector ] == null )
							{
								/* Remove the DOM listener for the specific selector */ 

								$( document ).unbind ( "DOMNodeInserted", DOMListener );

								return;
							}

							/* Does this element belong to the current selector? */ 

							var target = $( event.target ).filter ( selector );

							if ( target.get ( 0 ) == null )
							{
								/* Or is it a child */ 

								target = $( event.target ).find ( selector );
							}

							/* Ensure we have a target to modify, and that we are allowed to watch it (the ".jurlp-no-watch" class is present on elements created in initialiseElementText()). */ 

							if ( target.length > 0 && target.is ( ".jurlp-no-watch" ) == false )
							{
								var filtered = false;

								/* Mark the element as being watched */ 

								target.data ( "is-watched", true );

								/* Apply the selector callstack for this element */ 

								for ( var i = 0, l = selectorCallStack [ selector ].length; i < l; i++ )
								{
									/* Run the selector callback to update the element */ 

									var output = selectorCallStack [ selector ] [ i ] [ 0 ].apply ( target, selectorCallStack [ selector ] [ i ] [ 1 ] );

									/* Has the element been filtered out? */ 

									if ( output != null && output.length == 0 )
									{
										/* This element has been filtered, perform no further modifications */

										filtered = true;

										break;
									}
								}

								/* Was the element not filtered out, and a user callback specified? */ 

								if ( filtered == false && typeof callback == "function" )
								{
									/* Call the user callback for each element found in the watch */ 

									target.each ( function ( ){ callback ( $(this), selector ) } );
								}
							}
						}
					);
				}

				return this;
			},

			/**
			 *
			 *	Function: unwatch
			 *
			 *	Removes a watch previously created with <watch>, and prevents modifications being made to new elemenets of the same selector. This will also clear the list of modifications for the selector, and the selector is free to use in a sebsequent call to <watch>.
			 *
			 *	Parameters:
			 *
			 *	this - Array of elements to obtain the selector from.
			 *
			 *	Returns:
			 *
			 *	Array of unmodified elements for chaining purposes.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Create a watch on the "a" selector
			 *	$("a").jurlp("watch");
			 *
			 *	// Remove the watch on the "a" selector
			 *	$("a").jurlp("unwatch");
			 *
			 *	(end code)
			 *
			 **/

			"unwatch" : function ( )
			{
				selectorCallStack [ this.selector ] = null;
			},

			/**
			 *
			 *	Function: filter
			 *
			 *	Filters elements by URL or URL segment.
			 *
			 *	Parameters:
			 *
			 *	this - Array of elements to filter. See <this parameter>.
			 *
			 *	segment - The URL segment to filter on (either "scheme", "host", "port", "path", "query" or "fragment"), or "url" to filter on the full URL. See <URL overview> for more information.
			 *
			 *	operator - The type of filtering to apply (either "!=", "$=", "*=", "<", "<=", "=", ">", ">=" or "^="). See <Operators> for more information.
			 *
			 *	value - The value of the item to filter on.
			 *
			 *	Returns:
			 *
			 *	Filtered element array for chaining purposes.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Get the URL object for all anchors that match
			 *	// the document URLs host name.
			 *	$("a").jurlp("filter", "host", "=", $(document).jurlp("host"))
			 *	      .jurlp("url");
			 *
			 *	// Get the URL object for all anchors that match 
			 *	// the document URLs host, and has a path ending in ".php".
			 *	$("a").jurlp("filter", "host", "=", $(document).jurlp("host"))
			 *	      .jurlp("filter", "path", "$=", ".php")
			 *	      .jurlp("url");
			 *
			 *	// Get the URL object for all anchors whose query 
			 *	// string matches the regular expression
			 *	$("a").jurlp("filter", "query", "regex", /(\?)/).jurlp("url");
			 *
			 *	(end code)
			 *
			 **/ 

			"filter" : function ( segment, operator, value )
			{
				/* Get an arbitrary URL object */ 

				var url = uri.parse ( getHref.apply ( this ) );

				/* Ensure operator is valid */

				if ( operator == "==" )
				{
					operator = "=";
				}

				/* Ensure that the segment is valid, and that a filter method exists */ 

				if ( ( segment == "url" || url [ segment ] != null ) && helpers.filters [ operator ] != null )
				{
					/* Add the filter to the selectors callstack if watched */ 

					addSelectorCallback ( this, methods.filter, [ segment, operator, value ] );

					/* Filter each element */ 

					return this.filter
					(
						function ( )
						{
							/* Get the current elements href */

							var url = getHref.apply ( $( this ) );

							var actualValue = "";

							/* Get the segment value */ 

							if ( segment != "url" )
							{
								/* Use a segment of the URL */ 

								actualValue = uri.parse ( url ) [ segment ];
							}
							else
							{
								/* Use the full URL */ 

								actualValue = url;
							}

							/* If we are testing port numbers, then convert the actual and user port string to an integer */ 

							if ( segment == "port" )
							{
								actualValue = parseInt ( actualValue, 10 );

								value = parseInt ( value, 10 );
							}
							/* Perform the filter check */ 

							return helpers.filters [ operator ].apply ( $( this ), [ actualValue, value ] );
						}
					);
				}

				return this;
			},

			/**
			 *
			 *	Function: interface
			 *
			 *	Get the available methods for the parser interface.
			 *
			 *	Returns: 
			 *
			 *	Array of interface methods.
			 *
			 *	Examples:
			 *
			 *	(start code)
			 *
			 *	// Return all methods exposed by the URL parser interface.
			 *	$.fn.jurlp ( "interface" );
			 *
			 *	(end code)
			 *
			 **/ 

			"interface" : function ( )
			{
				return methods;
			}
		};

		/**
		 *
		 *	Section: JQuery plugin interface.
		 *
		 *	Function: $.fn.jurlp
		 *
		 *	Public interface/method dispatcher for the JQuery URL parser.
		 *
		 *	See <Public interface> for more information on the available methods.
		 *
		 *	See <initialise> for more specific information on how elements are initialised by the parser.
		 *
		 *	Parameters:
		 *
		 *	this - Element(s) to process. See <this parameter>.
		 *
		 *	method - See <Public interface> for an overview of available methods and arguments.
		 *
		 *	arguments - Method arguments.
		 *
		 *	Returns:
		 *
		 *	Either an array of elements for chaining purposes, or array of specific values, depending on the method called.
		 *
		 **/ 

		$.fn.jurlp = function ( method )
		{
			/* If the current selector isn't part of a filter... */ 

			if ( this.selector.indexOf ( ".filter" ) == -1 )
			{
				/* Set the global current selector */ 

				currentSelector = this.selector;
			}

			/* Ensure all elements are initialised with a "data-href". */ 

			returnEachElement.apply ( this, [ initialiseElement ] );

			/* Dispatch to the relevant method */ 

			return methodDispatcher.apply ( this, arguments );
		};

		/**
		 *
		 *
		 *	Function: $.jurlp
		 *
		 *	Returns an interface for directly parsing, manipulating and monitoring the supplied URL.
		 *
		 *	Parameters:
		 *
		 *	url - The URL string to provide a URL parser interface for. Defaults to document.location.href if no URL is supplied.
		 *
		 *	Returns:
		 *
		 *	The URL parser interface for the given URL.
		 *
		 *	Members:
		 *
		 *	href - The URL string.
		 *
		 *	Methods:
		 *
		 *	url - See <url>.
		 *
		 *	scheme - See <scheme>.
		 *
		 *	user - See <user>.
		 *
		 *	password - See <password>.
		 *
		 *	host - See <host>.
		 *
		 *	port - See <port>.
		 *
		 *	path - See <path>.
		 *
		 *	query - See <query>.
		 *
		 *	fragment - See <fragment>.
		 *
		 *	proxy - See <proxy>.
		 *
		 *	goto - See <goto>.
		 *
		 *	watch - Sets a watch for all "href" and "src" attributes containing the URLs hostname (selector is "[href*="host"],[src*="host"]" where host is this.host()), and returns all elements of the same selector for chaining purposes. See <watch> for more information.
		 *
		 *	unwatch - Removes a watch created for the current URLs hostname. See <unwatch>.
		 *
		 *	Examples:
		 *
		 *	See <Parsing URL strings directly>.
		 *
		 **/

		$.jurlp = function ( url )
		{
			/* Create an object for manipulating the url, or document.location.href if null. */ 

			return {
				href : url || document.location.href,
				url : methods.url,
				scheme : methods.scheme,
				user : methods.user,
				password : methods.password,
				host : methods.host,
				port : methods.port,
				path : methods.path,
				query : methods.query,
				fragment : methods.fragment,
				proxy : methods.proxy,
				"goto" : methods [ "goto" ],
				watch : function ( callback )
				{
					/* Get the current host name */ 

					var host = this.host ( );

					/* Set a watch on the href or src selectors */ 

					return $( "[href*=\"" + host + "\"],[src*=\"" + host + "\"]" ).jurlp ( "watch", callback );
				},
				unwatch : function ( )
				{
					/* Get the current host name */ 

					var host = this.host ( );

					/* Set a watch on the href or src selectors */ 

					return $( "[href*=\"" + host + "\"],[src*=\"" + host + "\"]" ).jurlp ( "unwatch" );
				}
			};
		};
	}
) ( jQuery );
