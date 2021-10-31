Compile add-year with error handling

```
clang read-record.s write-record.s add-year.s error-exit.s count-chars.s write-newline.s -o add-year.out
```

Use The Concepts: Add a recovery mechanism for add-year.s that allows it to read from STDIN if it cannot open the standard file.

```
clang read-record.s write-record.s add-year-recovery.s error-exit.s count-chars.s write-newline.s -o add-year-recovery.out
```
