`mtran` copies huge directory and verifies files integrity.

# Goal
* Copy huge directory and verifies files integrity. We are dealing with terabytes of data and hundred thousands of files.
* Re-copy files if integrity test failed.
* Resilient to interruptions. It should pick up where it left off.

# Tools looked
* `rsync --checksum` only uses hashes to see if a file needs to be updated. It doesn't perform a hash comparison afterward. It is not resilient to interruptions.
* `quickhash`

# Design
* Reuse existing tools. Candidates? :  `cp`, `rsync`, `tar`, `pax`, `pv`, `crccp`, `mcp`, `hashdeep`


* `cpio` unfortunately has an 8GB upper limit for files. http://serverfault.com/a/425671