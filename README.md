# swift-io
Swift IO libraries to support classes developers are used to from Java. Based on [swift.org](http://swift.org) opensource toolchain.

Please report any issues [here](https://github.com/swifties/swift-io/issues).

Looking for contributors, see the [TODO list](TODO.md)!


<hr>
## release 0.1.0
* What is done: string Readers and Writers, including Buffered reader to read streams line by line
* [API documentation](docs/)
* Test coverage 100%
* Linux status: on macos, you can run opensource toolchain 'swift build' and 'swift test' commands from commandline with success. Linux swift implementation is obviously behind the changes made to Swift and currently throws several compilation errors like
  * 'streamError' with type 'Error?' cannot override a property with type 'NSError?'
  * error: use of unresolved identifier 'URL'
