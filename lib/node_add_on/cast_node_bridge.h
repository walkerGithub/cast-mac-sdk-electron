#pragma once
#include <string.h>
#include <napi.h>
#import <Cocoa/Cocoa.h>

@interface HPOfficeCastDelegate : NSObject

@end

class SimpleAsyncWorker : public Napi::AsyncWorker {
    
    public:
        SimpleAsyncWorker(Napi::Function& callback);
        virtual ~SimpleAsyncWorker() {};

        void SetTypeParam(std::string type,bool success,int errType,std::string param);
        void Execute();
        void OnOK();
    private:
        std::string m_sType;
        bool m_sSuccess;
        int m_sErrType;
        std::string m_sParam;
};

class CHPCastNodeBridge : public Napi::ObjectWrap<CHPCastNodeBridge>
{
public:
    static Napi::Object Init(Napi::Env env, Napi::Object exports);
    CHPCastNodeBridge(const Napi::CallbackInfo& info);
    ~CHPCastNodeBridge();

    Napi::Value Open(const Napi::CallbackInfo& info);
    Napi::Value Close(const Napi::CallbackInfo& info);
    Napi::Value Start(const Napi::CallbackInfo& info);
    Napi::Value Stop(const Napi::CallbackInfo& info);
    Napi::Value GetIsSupportCastSystemSound(const Napi::CallbackInfo& info);
    Napi::Value InstallAudioDriver(const Napi::CallbackInfo& info);
    Napi::Value UninstallAudioDriver(const Napi::CallbackInfo& info);
    Napi::Value GetProperty(const Napi::CallbackInfo& info);
    Napi::Value SetProperty(const Napi::CallbackInfo& info);
    Napi::Value SystemAuthorize(const Napi::CallbackInfo& info);
    Napi::Value SetCallback(const Napi::CallbackInfo& info);

    int CallBack(std::string type,bool success,int errType,std::string param);

protected:
    int InitCast();
    int DeInitCast();
    int StartCast(std::string sPinCode);
    int StopCast();

private:
    static Napi::FunctionReference constructor;
    SimpleAsyncWorker* asyncWorker;

    std::string m_sAppID;
    std::string m_sUserID;
    std::string m_sUserDepartment;
    std::string m_sServerIp;
    unsigned short m_usServerPort;
    bool m_bServerHttps;
    bool m_bLogEnable;
    std::string m_sPincode;
};
