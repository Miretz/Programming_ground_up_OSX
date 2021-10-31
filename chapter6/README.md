### How to compile with Clang

Write Records

```
clang write-record.s write-records.s -o write-records.out
```

Read Records

```
clang read-record.s count-chars.s write-newline.s read-records.s -o read-records.out
```

Add Year

```
clang read-record.s write-record.s add-year.s -o add-year.out
```

Custom: Read Ages - prints Name and Age

```
clang read-record.s read-ages.s -o read-ages.out
./read-ages.out <filename>
```

Use the concepts: Write a record 30 times using a loop

```
clang write-thirty-times.s write-record.s -o write-thirty-times.out
```

Use the concepts: Largest and smallest age

```
clang read-record.s find-largest-age.s -o find-largest-age.out
./find-largest-age.out
echo ?$

clang read-record.s find-smallest-age.s -o find-smallest-age.out
./find-smallest-age.out
echo ?$
```

Going Further: Use command-line arguments to specify the filesnames

```
clang write-record.s write-records-to-file.s -o write-records-to-file.out
clang read-record.s count-chars.s write-newline.s read-records-from-file.s -o read-records-from-file.out
./write-records-to-file.out <filename>
./read-records-from-file.out <filename>
```

Going Further: Rewrite the add-year to write back to the same file

```
clang read-record.s write-record.s add-year-overwrite.s -o add-year-overwrite.out
```

Going Further: Add record

```
clang write-record.s add-record.s -o add-record.out
```


