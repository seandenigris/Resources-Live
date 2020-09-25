# ResourcesLive

### Motivation
What is a file? A file is data, which often represents something in a user's domain e.g. a photo. Files that matter to users have a label e.g. /Users/me/image_1.jpg. This label consists of a name and a location. Typically the location is thought of as a concrete place. The filesystem is like an organized closet, where the closet is subdivided into shelves, and then the shelves are subdivided into plastic bins, etc.

But what does any of the above have to do with what matters? If we take a photo, and that photo happens to be stored digitally, why can't we deal with it abstractly so that we don't have to know or care what its label is or where its bits are stored?

One problem with the filesystem paradigm is that files need to be in one place, and can be linked to other places. This creates tension. The first pain point is balancing navigability and maintenance. If I have one giant folder, it can be hard to find any given thing, but if I have a folder tree 6 levels deep, it can be a maintenance headache, as well as requiring effort to drill down through all those levels.

The next pain point is where real-life categories aren't cleanly separated. Let's say I work for a company, and also belong to an employee union. I am interviewed about an issue on which the company and the union are aligned. Where do I put the video of the interview? In the company folder? In the union folder? Yes, I could symlink from one to the other, but the point is that it really belongs to both domains equally and filesystems don't support that concept.

So we're mixing two concepts. What a digital thing is, and what it represents in the real world. ResourcesLive is an attempt to disentangle these two. It's mission is to handle the first - the digital entity, the file - magically for the user, although the user should be able to customize if they really care. It then models the second concept - what the digital thing represents in the real world - on it's own terms. So an image file might have #edit and #view capabilities, a sound can be #play-ed, etc.

## Installation
The target platform where it's most likely to work well is latest Pharo/GToolkit.

```smalltalk
EpMonitor current disable.
Metacello new
	baseline: 'ResourcesLive';
	repository: 'github://seandenigris/ResourcesLive';
	load.
EpMonitor current enable
```

### Usage
A typical use case is to have a resource library particular to your project. E.g. a library of mp3 files for a music app. We'll take that example, and assume you're using SimplePersistence to store your data.

1. Set File Library location (Otherwise, the default will use a system-wide location. Be careful with this because there is no conflict management if you have multiple images/apps using the same library)

    ```
    MyProjectDb class>>initialize
    	"Add the following line *before* you send #restoreLastBackup"
    	ResourcesLiveDB backupDirectoryParent: self backupDirectoryParent.
    ```
2. Set up serialization

    ```
    MyProjectDb class>>repositories
    	^ { MyProject repo1. MyProject repo2. ResourcesLiveDB repositories }.
    ```
3. Set Up materialization

    ```
    MyProjectDb class>>restoreRepositories: someRepositories
    	"..."
    	ResourcesLiveDB restoreRepositories: someRepositories last
    ```
