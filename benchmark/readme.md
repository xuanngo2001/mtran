# Performance results of copy commands
## cp vs tar vs rsync

The copy commands were executed using [mtran.sh](https://github.com/limelime/mtran/blob/master/mtran.sh) script:

* **cp**: copy using the plain `cp` command.
* **tar**: copy using `tar` and pipe, `tar|tar`.
* **tarbuffer**: copy using `tar` and add `buffer` to handle the buffering between the pipes, `tar|buffer|tar`.
* **tarpvbuffer**: copy using `tar` and add `pv` to handle the buffering between the pipes, `tar|pv|tar`.
* **rsync**: copy using the plain `rsync` command.

For details, see [Commands code section](#commands-code).

# Results
![alt text](https://raw.githubusercontent.com/limelime/mtran/master/benchmark/benchmark-results.png "Copy commands performance results")

# Conclusion
* `rsync` is always slower than `cp` and `tar`. It is safe to say that `rsync` is almost 2 times slower than the other commands.
* `tar` is a little big faster than `cp` and doesn't suffer big copy speed fluctuation like `cp`.
* Adding buffer to `tar` doesn't significantly improve copying speed of `tar` itself. They have virtually the same speed. That being said, `tar|pv|tar` is relatively better than `tar` and `tar|buffer|tar`. 

In general, use `tar|pv|tar`.

# Commands code
```bash
  case "${ACTION}" in

    # cp: plain copy.
    cp)
      cp -au "${SRC_DIR}" "${DEST_DIR}"
      ;;
    
    # tar: use tar to copy.
    tar)
      tar -C "${SRC_BASE_DIR}" -cf - "${SRC_DIR_NAME}" | tar -C "${DEST_DIR}" -xpSf -
      ;;

    # tar & buffer: use tar and buffer to copy when 1 of the device is slower than the other 1.
    tarpvbuffer)
      tar -C "${SRC_BASE_DIR}" -cf - "${SRC_DIR_NAME}" | pv -q -B 1024M | tar -C "${DEST_DIR}" -xpSf -
      ;;

    # tar & buffer: use tar and buffer to copy when 1 of the device is slower than the other 1.
    tarbuffer)
      tar -C "${SRC_BASE_DIR}" -cf - "${SRC_DIR_NAME}" | buffer -m 8M | tar -C "${DEST_DIR}" -xpSf -
      ;;

    # rsync: Don't use sparse with rsync: http://stackoverflow.com/a/13266131
    rsync)
      rsync -a -W "${SRC_DIR}" "${DEST_DIR}"
      ;;
    
    diff)
      diff -r "${SRC_DIR}" "${DEST_DIR}/${SRC_DIR_NAME}"
      ;;
            
    *)
      echo "ERROR: Unknown action=>${ACTION}"
      exit 1
      ;;
  esac
```
