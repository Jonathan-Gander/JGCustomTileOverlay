# JGCustomTileOverlay
A custom tile overlay implementation for MKMapKit that use a local cache to store downloaded tiles. It is used into my app GPX viewer ([available on the App Store](https://apps.apple.com/ch/app/gpx-viewer/id1511582047?l=fr)).

## Discussion about cache
Cache is stored into `Application Support` directory so it is managed by user. In GPX viewer, I need that downloaded tiles are not randomly deleted by iOS because user needs it for hiking. However, if you don't need to keep downloaded tiles, you can simply change cache directory.


## Don't forget to ...

- Add `Allow Arbitrary Loads` to `YES` into `App Transport Security Settings` in your `Info.plist` to allow your custom URL template to be loaded.
- Import `invalidTile.png` in your project. It is displayed when URL template is invalid.