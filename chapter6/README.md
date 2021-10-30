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

Read Ages - prints Name and Age

```
clang read-record.s read-ages.s -o read-ages.out
```

Use the concepts: Write a record 30 times using a loop

```
clang write-thirty-times.s write-record.s -o write-thirty-times.out
```

