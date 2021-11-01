On Mac OSX use this instead of ldd:

```
otool -L <executable>
```

Use the Concepts: factorial as a shared library

```
clang -shared libfactorial.s -o libfactorial.so
clang factorial.s -o factorial.out libfactorial.so
```
