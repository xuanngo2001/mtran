`mtran` copies huge directory and verifies files integrity.

# Usage
    
    mtran.sh <ACTION>    <SOURCE_DIR> <DEST_DIR>
    mtran.sh cp          SOURCE_DIR/ DEST_DIR/
    mtran.sh tar         SOURCE_DIR/ DEST_DIR/
    mtran.sh tarbuffer   SOURCE_DIR/ DEST_DIR/
    mtran.sh tarpvbuffer SOURCE_DIR/ DEST_DIR/
    mtran.sh rsync       SOURCE_DIR/ DEST_DIR/
    mtran.sh diff        SOURCE_DIR/ DEST_DIR/



# Goal
* Copy huge directory and verifies files integrity. It implies terabytes of data and hundred thousands of files.
* Re-copy files if integrity test failed.
* Resilient to interruptions. It should pick up where it left off.

# Test cases
* Copy within the same devices: internal hard drive, usb key, external hard drive through usb.
* Copy from one device to another device of equal speed: internal hard drive to internal hard drive.
* Copy from fast device to slow device: internal hard drive to external usb hard drive.
* Copy from slow device to faster device: external usb hard drive to internal hard drive.

```
    # Should not copy.
    ./mtran.sh cp test/ ./test/
    
    # Should not copy even if * expands to 2 parameters.
    ./mtran.sh cp * *
```

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
  
  
# To read

* http://blog.mudy.info/2010/07/linux-file-copy-benchmark-cp-vs-cpio-vs-tar-vs-rsync/
* https://gist.github.com/zachharkey/7198898 -> http://snipplr.com/view/26670/

