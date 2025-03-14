```bash
mkdir build
cd build
cmake ..
make
export DYLD_LIBRARY_PATH=/usr/local/lib:$DYLD_LIBRARY_PATH
./bin/channel_bench --type=mem
```