/**
*@module
*@version 1.0.0
*/
const CastSDK = (() => {
  let instance;
  /**
   * mode: Cast SDK JS Module Loader
   * @param {Function} apicallretcb api call ret callback
   * @param {Boolean} threadsafemode
   * @return {CastSDK}
   */
  function init(opts) {
    // Private methods and variables
    let node_path = opts || {};
    let addon_path = node_path || ('./../sdk/mac/castsdk.node');
   
    console.log('addon_path', addon_path);
    // 导入node插件
    let addon = require(addon_path);
    // 创建对象
    var obj = new addon.CHPCastNodeBridge();


    console.log('addon obj load:',addon,obj);

    return {
        InitSDK: function (appkey,userid,department,pinserver,pinserverport,httpsbool,logbool) {

              //输入参数分别为：appkey(乐播提供的key)/userid（用户id）/userid（用户部门）/pinserver（pin码服务器）/pinserverport（pin码服务器端口）/https开关（服务器是否https）/logbool日志开关
          var rtn = obj.Open(appkey,userid,department,pinserver,pinserverport,httpsbool,logbool);
          
          console.log("Open rtn:"+rtn);
            
          return rtn
        },
        StartCast: function (pincode) {
          
          var rtn = obj.Start(pincode);
        
          console.log("Start rtn:"+rtn);
            
          return rtn
        },
        StopCast: function () {
          
          var rtn = obj.Stop();
        
          console.log("Stop rtn:"+rtn);
            
          return rtn
        },
        GetIsSupportCastSystemSound: function () {
          
          var rtn = obj.GetIsSupportCastSystemSound();
        
          console.log("GetIsSupportCastSystemSound rtn:"+rtn);
            
          return rtn
        },
        InstallAudioDriver: function () {
          
          var rtn = obj.InstallAudioDriver();
        
          console.log("InstallAudioDriver rtn:"+rtn);
            
          return rtn
        },
        UninstallAudioDriver: function () {
          
          var rtn = obj.UninstallAudioDriver();
        
          console.log("UninstallAudioDriver rtn:"+rtn);
            
          return rtn
        },
        GetProperty: function (property) {
          
          var rtn = obj.GetProperty(property);
        
          console.log("GetProperty ",property," rtn:"+rtn);
            
          return rtn
        },
        SetProperty: function (property,value) {
          
          var rtn = obj.SetProperty(property,value);
        
          console.log("SetProperty ",property,value,"rtn:"+rtn);
            
          return rtn
        },
        SystemAuthorize: function (selector) {
          
          var rtn = obj.SystemAuthorize(selector);
        
          console.log("SystemAuthorize ",selector,"rtn:"+rtn);
            
          return rtn
        },
        SetCallback: function (callback) {
          
          var rtn = obj.SetCallback(callback);
        
          console.log("SetCallback ",callback,"rtn:"+rtn);
            
          return rtn
        },
    }
  };
  
  return {
    /**
     * Get Cast SDK Module
     * @return {CastSDK}
    */
    getInstance: (opts) => {
      if (!instance) {
        instance = init(opts);
      }
      return instance;
    }
  };
})();

module.exports = {
  CastSDK: CastSDK
}
