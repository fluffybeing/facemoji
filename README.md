Facemoji
======

Facemoji is an OSX app which displays emoji's according to the user face emotion. It is an OSX version of [MIT Media Lab Mood Meter](http://moodmeter.media.mit.edu/).

![Snapshot of Running App](/resource/img.png?raw=true "Facemoji Screeshot")


### How to run the project

1. You will need to clone the project or download the zip.

```bash
$ git clone https://github.com/rahulrrixe/Facemoji.git
```

2. Install CocoaPod if you don't have because the Facemoji app uses [AffdexSDK SDK](http://developer.affectiva.com/){:target="_blank"} for emotion detection.

```bash
$ gem install Cocoapod

```

Add below lines to your `Podfile`, if your creating new one unless you can use the same file which comes with the project.

```ruby
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!

target 'Moodie' do
    pod 'AffdexSDK-OSX'
end

```
Then type this command inside the project root directory where your Podfile is there

```bash
$ pod install

```

Finally open `.xcworkspace` file in the Xcode and click the play button

### Contribute:
The code is licensed under MIT LICENCE and so you are free to use it for own purpose.


