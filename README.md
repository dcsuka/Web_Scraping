# Miscellaneous Web Scrapers

Here are some of the web scraping scripts which I have developed for various data extraction tasks.

## Amazon 
<img align="right" width=200 src="img/amazon.png">
<br clear="left"/>
Obtains product name and price for the first page of results of any search term.

Small modifications would allow for also extracting ratings and results, even on subsequent pages as well.

## Google
<img align="right" width=200 src="img/google.jpeg">
<br clear="left"/>
Extracts title and subtext for search results of a custom query. 

It may be necessary to perform an HTTR consent request beforehand depending on user locale.

## Power BI

<img align="right" width=200 src="img/powerbi.png">
<br clear="left"/>
Scrapes all of the tables from Power BI analytics dashboards, scrolling down and moving across pages as necessary. The HTML structure of the tables appears to have changed since the initial design of this script, so the XPaths require updating.
