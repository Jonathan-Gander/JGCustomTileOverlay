# JGCustomTileOverlay
A custom tile overlay implementation for MKMapKit that uses a local cache to store downloaded tiles. It is used into my app GPX viewer ([link to the App Store](https://apps.apple.com/ch/app/gpx-viewer/id1511582047?l=fr)).

## App and classes description

The app is an example of `JGCustomTileOverlay` usage. It displays a map that use this overlay to load tiles. You can access options from top right button, as clearing cache.

Classes : 

- `ViewController` contains UI : map and options button. Check here how I initialize `JGCustomTileOverlay` and add it to `mapView`.


- `CacheDirectoryManager` Singleton class used to manage cache directory where tiles are stored. It provides methods to help using cache directory. If you want to change where tiles are stored, just change it in this class.


- `JGCustomTileOverlay` contains method to load each tile from cache (if it exists already) or load it from URL (and save it into cache).

## Discussion about cache

Cache is stored into `Application Support` directory so it is managed by user. In GPX viewer, I need that downloaded tiles are not randomly deleted by iOS because user needs them for hiking. However, if you don't need to keep downloaded tiles, you can simply change cache directory.


## Don't forget to ...

- Add `Allow Arbitrary Loads` to `YES` into `App Transport Security Settings` in your `Info.plist` to allow your custom URL template to be loaded.

- Import `invalidTile.png` in your project. It is displayed when URL template is invalid.


## Any suggestions?

As this class is used into my production app GPX viewer, be free to contact me if you have any suggestions how to improve it.