#include "gaianet.h"
#include <google/protobuf/stubs/common.h>

namespace gaianet {
    void shutdown() {
        google::protobuf::ShutdownProtobufLibrary();
    }
} // namespace gaianet