`mtran` copies huge directory and verifies files integrity.

# Usage
    
    ./mtran copy SRC_DIR DEST_DIR


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

# Reading
## Why is tar|tar so much faster than cp?

http://superuser.com/a/985080

   >cp does open-read-close-open-write-close in a loop over all files. 
    So reading from one place and writing to another occur fully interleaved. 
    Tar|tar does reading and writing in separate processes, and in addition tar uses multiple threads to read (and write) 
    several files 'at once', effectively allowing the disk controller to fetch, buffer and store many blocks of data at 
    once. All in all, tar allows each component to work efficiently, while cp breaks down the problem in disparate, 
    inefficiently small chunks.
    
## Buffer up data to accommodate read and write fluctuations speed
  
http://unix.stackexchange.com/a/66660

   >pv will buffer up to 500M of data so can better accommodate fluctuations in reading and writing speeds on the 
    two file systems (though in reality, you'll probably have a disk slower that the other and the OS' write back
     mechanism will do that buffering as well so it will probably not make much difference).
 

## File copy method that is twice as fast as "cp -a"
 
 https://lists.debian.org/debian-user/2001/06/msg00288.html
 
 >The situation between the "find | cpio" case and the "tar c | buffer
  | tar x" case seems analagous to what we do in that if you just point
  out the bugs, it takes longer for them to get fixed than if you
  submit a patch.  Can you see what I mean by that?  In "find | cpio",
  "find" is just walking the filesystem handing file names off to
  "cpio" who must then stat and read each file itself, and then also
  write it back out to the new location.  In the "tar c | buffer | tar
  x" case though, the "tar c" is making its own list of files, then
  packing them up and piping the whole bundle off to the buffer (our
  BTS?), where it is then ready to be unpacked by the "tar x".  Hmmm. 
  "cpio" doesn't know how to find, it just knows how to archive or copy
  through...