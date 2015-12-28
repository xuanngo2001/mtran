`mtran` copies and verifies integrity of files.

# Goal
* Mass copy and verify integrity of files. We are dealing with terabytes of data and hundred thousands of files.
* Re-copy file if integrity test failed.
* Resilient to interruptions. It should pick up where it left.

# Tools looked
* `rsync --checksum` only uses hashes to see if a file needs to be updated. It doesn't perform a hash comparison afterward. It is not resilient to interruptions.
* `quickhash`