{
  
  'variables':{
    'module_name': "castsdk",
    'module_mac': "./../sdk/mac",
  },

  "targets": [
    {
      'target_name':"<(module_name)",

     'conditions':[
       [
          'OS=="mac"',
          {

            "sources": [
            "./lib/node_add_on/cast_node_addon.cc",
            "./lib/node_add_on/cast_node_bridge.mm",
            ],
            'mac_framework_dirs':[
             './../sdk/mac/CastSDK',
            ],
            'link_settings':{
            'libraries':[
              # "-Wl,-rpath,@loader_path/../../../opencv-build/opencv/build/lib"
              "HPOfficeCastWork.framework",
            ],
            },
            "xcode_settings":{
                    "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                    "BUILD_DIR":"<(module_mac)",
                    "OTHER_CPLUSPLUSFLAGS" : [ '-ObjC++', "-std=c++11", "-stdlib=libc++",  '-fvisibility=hidden','-frtti'],
                    "OTHER_LDFLAGS": [ "-stdlib=libc++"],
                    "DEPLOYMENT_POSTPROCESSING": "YES",
            },
            "include_dirs": [
              "<!@(node -p \"require('./demo/node_modules/node-addon-api').include\")",
            ],
            'defines': [ 'NAPI_DISABLE_CPP_EXCEPTIONS' ],
            "cflags!": ["-fno-exceptions"],
            "cflags_cc!": ["-fno-exceptions"],
          }
        ]
      ]
    }
  ]
}
