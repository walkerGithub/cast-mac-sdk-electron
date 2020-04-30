#include <napi.h>
#include "cast_node_bridge.h"

Napi::Object InitAll(Napi::Env env, Napi::Object exports) {
  return CHPCastNodeBridge::Init(env, exports);
}

NODE_API_MODULE(cast_node_bridge, InitAll)
