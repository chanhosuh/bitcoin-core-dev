Docker setup for Bitcoin Core development

To use:
- `git clone` the bitcoin repo and this one into adjacent directories
- from the directory containing this repo, `make up` will build an image with all the
  code from the bitcoin repo compiled
- `make bash` will drop you in a bash shell inside the container, where you can run the
  tests, etc.

Notes:
- Building takes a while the first time not just because of C++ compilation, but we take
  extra care to download the exact patch version of the oldest supported Python
