# ResourcesLive

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
