# Resources Live

TLDR: Free users to communicate with *objects* instead of managing *files*. Files conflate *what* a thing is with *where* it is. We take can of the boring location part for you. So you can "play an mp3" instead of "opening an mp3 file in a player app". Nicer, no?
	
# Overview
	
NB. This section is an export of the class comment of `BaselineOfResourcesLive`. When viewed from inside the system, it is live, dynamic and beautiful. "Just the markdown" only gives you a taste. We suggest you dive in and view the documentation as it was intended as quickly as possible - it will be more enjoyable and productive!

## Motivation
What is a file? A file is data, which often represents something in a user's domain e.g. a photo. Files that matter to users have a label e.g. `/Users/me/image_1.jpg`. This label consists of a name and a location - although with the advent of universal search (e.g. Mac Spotlight) one could debate how useful/interesting the location is in many cases. Typically the location is thought of as a concrete place. The filesystem is like an organized closet, where the closet is subdivided into shelves, and then the shelves are subdivided into plastic bins, etc.

But what does any of the above have to do with what matters? If we take a photo, and that photo happens to be stored digitally, why can't we deal with it abstractly so that we don't have to know or care what its label is or where its bits are stored?

One problem with the filesystem paradigm is that files need to be in one place, and can be linked to other places. This creates tension. The first pain point is balancing navigability and maintenance. If I have one giant folder, it can be hard to find any given thing, but if I have a folder tree 6 levels deep, it can be a maintenance headache, as well as requiring effort to drill down through all those levels.

The next pain point is where real-life categories aren't cleanly separated. Let's say I work for a company, and also belong to an employee union. I am interviewed about an issue on which the company and the union are aligned. Where do I put the video of the interview? In the company folder? In the union folder? Yes, I could symlink from one to the other, but the point is that it really belongs to both domains equally and filesystems don't support that concept. Also, linking doesn't work for all use cases e.g. syncing services like Dropbox and Google Sync can't properly handle them.

So we're mixing two concepts. What a digital thing is, and what it represents in the real world. ResourcesLive is an attempt to disentangle these two. It's mission is to handle the first - the digital entity, the file - magically for the user, although the user should be able to customize if they really care. It then models the second concept - what the digital thing represents in the real world - on its own terms. So an image file might have #edit and #view capabilities, a sound can be #play-ed, etc.

## Usage
A typical use case is to have a resource library particular to your project. E.g. a library of mp3 files for a music app. We'll take that example, and assume you're using SimplePersistence to store your data.

1. Set File Library location. Otherwise, the default will use a system-wide location. NB Be careful with this because there is no conflict management if you have multiple images/apps using the same library. ResourcesLive uses its backup directory to determine the library location, so:
```smalltalk
    MyProjectDB class>>initialize
    	"Add the following line *before* you send #restoreLastBackup"
    	ResourcesLiveDB backupDirectoryParent: self backupDirectoryParent.
```
 
2. Set up serialization
```smalltalk
    MyProjectDB class>>schema
    	^ { MyProject. MyProject. ResourcesLiveDB }.
   ```
	
# Installation
In GToolkit (preferably) or Pharo (v. 9 best supported at time of writing), do the following:

```smalltalk
[
EpMonitor current disable.
[ Metacello new
	baseline: 'ResourcesLive';
	repository: 'github://seandenigris/ResourcesLive';
	"onConflict: [ :ex | ex allow ];"
	load ] ensure: [ EpMonitor current enable ].

] fork.

```
N.B. you only have to do the outer fork if on GT and you want the UI to stay responsive during the load.

# Disclaimer

This project is part of a ~20 year (as of 2021) exploration of the [Dynabook](https://github.com/seandenigris/Dynabook) idea (a la Alan Kay). It's intensely personal and opinionated and I've open sourced it due to repeated requests. Use at your own risk. Any part may change at any time. I'm happy to give support when I have time in the form of explanations, but do not expect me to implement any particular feature, or even accept PRs if they don't feel right. That said, I'm happy to have anyone along on the journey :)
# License Explanation
The license is MIT. However, my original intent was to release my Dynabook libraries under a copy far left license (free use for cooperatives, but negotiated licenses for those utilizing paid labor for profit). I love sharing any work I do, but am disgusted by the propect that (especially multi-billion-dollar) corporations will exploit my work for free, especially toward ends with which I don't philosophically agree. However, after many discussions with colleagues, it appears that at this moment there is just no way to protect one's work from parasites without effectively keeping it from everyone. Even GPL, which doesn't even come close to "solving" the problem stated above, seems enough to put off most people. In closing, now that my intentions are clear, I request the following from any entity utilizing wage labor or selling for profit who uses my work:
1. Attribution
2. Pay for what you use, or don't use it

While there may be no legal means for me to enforce the above given that this code is released under MIT, my intentions should be clear; violate the above at risk to your own conscience.
