

### Summary: Include screen shots or a video of your app highlighting its features

Screen recordings of the project can be found in the following Google Drive folder:

<a target="_blank" rel="noopener noreferrer" href="https://drive.google.com/drive/folders/1xTCFCwM9uK5GnkRcyOUkFPPZcrgwPhHE">https://drive.google.com/drive/folders/1xTCFCwM9uK5GnkRcyOUkFPPZcrgwPhHE</a>

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

My top priorities were practicing SOLID principles and clean architecture. Over the past few months, I’ve been practicing implementing SOLID principles wherever possible. The modular code has allowed me to build a library of core functionality that can be shared between projects. This allows for:
- Quick architecture changes if a client decides they want a feature to work differently;
- The ability to easily swap services and research the performance benefits one approach has over an other;
- focus to shift to learning new technologies instead of rewriting the same functionality for different clients.

The caching requirement extends a feature I recently built for a client project which persisted data locally in SwiftData based on data in Firebase Firestore. The service ensures data is only downloaded when there are unfetched changes in the remote. In the future I’ll combine the SwiftData/Firestore functionality with the cache services in this `RecipeApp` project to allow me to control storage location via an enum: memory, disk, persisted, or remote.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

Instead of prioritizing how quickly I could finish this, I took the opportunity to practice clean architecture and to demonstrate my ability to learn and implement new concepts on the fly. It took ~14 hours. There were a few factors and personal goals that impacted development time:
- Swift 6 instead of Swift 5
    - I stuck with Swift 6 even though I am not as comfortable with it compared to Swift 5.
- SwiftTesting
    - First time learning and using the SwiftTesting framework instead of XCTest.
- GitHub mock production environment.
    - Utilized proper version control workflow. Pushed 19 relatively small commits to the ‘development’ branch before merging the feature into the `main` branch.
- SOLID Architecture
    - With a goal of designing a clean architecture and data flow, I reiterated & refactored the code several times as I identified oversights I made earlier in development.

Most of my time was allocated to the proper cache implementation, clean architecture, and tests. Specifically I spent the most time working on the disk caching functionality and doing a deep dive into the SwiftTesting framework.

While I enjoy UI work, I'm confident in my ability to design and develop Views (see [Invex](https://apps.apple.com/us/app/invex-inventory-management/id6499252957) for reference) so it was not a high priority for this project. It took ~1.5-2hrs which included mimicking the carousel found on the homepage of the Fetch Rewards iOS app and displaying custom alerts.


### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

- I originally wanted to use the ID included in the `Recipe` image URLs as the key for the cache values. I considered the edge case of throwing an index out of range error in the future if images were to be moved into their parent directory on the server. I decided to make the key the hash value of the URL string, in turn losing reference to the ID and whether the image is large or small.
    - While writing this I realized I should have just used the `Recipe` model’s ID and the last component of the image url (large.jpg or small.jpg). This would’ve provided clean file structure where there is a directory for each recipe ID containing the small and large images.
- Both of the caching services are singletons which restricts how they can be used and what data they can store safely in the future.


### Weakest Part of the Project: What do you think is the weakest part of your project?

- Unit tests
    - While I don’t frequently use Test Driven Development in my personal projects, this project made me realize how powerful it can be. I spent significant time debugging an issue where I could not get a file from FileManager immediately after adding the file. Through TTD of the `DiskCacheService`, I realized that my existing workflow combined with the slashes (‘/‘) in the URL placed the files into unexpected folders.
- Default cache dumping
    - Right now both memory and disk caching services are using default system behavior. To further customize them, the `MemoryCacheService` could set its cache’s `.countLimit` and `.totalCostLimit` and `DiskCacheService` could clear the caches directory based on some type of TTL metric. I think it would be a good idea to handle these depending on the user’s device.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

Being that ’No using AI’ was a requirement, I gave myself a goal to be as transparent as possible:
- I screen recorded the entire process, including all planning & typing TODOs, learning and development;
- All learning was done using Apple Developer Documentation and Stack Overflow;
- The large majority of the app was written without copy & paste unless it were code local to the project.

All feedback is appreciated!
