# Performance results of copy commands: cp, tar|tar, tar|buffer|tar and rsync

The copy commands were executed through [mtran.sh](https://github.com/limelime/mtran/blob/master/mtran.sh) script.

# Results
![alt text](https://raw.githubusercontent.com/limelime/mtran/master/benchmark/benchmark-results.png "Copy commands performance results")

# Conclusion
* `rsync` is always slower than `cp` and `tar`.
* `tar` is a little big faster than `cp` and doesn't suffer big copy speed fluctuation like `cp`.
* Adding buffer to `tar` doesn't significantly improve copying speed. There are virtually the same. That being said, `tar|pv|tar` is relatively better than `tar` and `tar|buffer|tar`. 

In general, use `tar|pv|tar`.