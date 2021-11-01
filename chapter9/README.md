To compile

```
clang -shared alloc.s -o alloc.so
clang read-record.s read-records.s -o read-records.out alloc.so
./read-records.out <filename>
```
