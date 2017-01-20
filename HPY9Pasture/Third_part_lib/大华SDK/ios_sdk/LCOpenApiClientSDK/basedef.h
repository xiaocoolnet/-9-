#ifndef _LCOPENAPI_CLIENT_BASEDEF_H_
#define _LCOPENAPI_CLIENT_BASEDEF_H_

#include <stdio.h>

#ifdef LCOPENAPICLIENT_EXPORTS
    #ifdef __cplusplus
    #define C_API extern "C" _declspec(dllexport)
    #else
    #define C_API _declspec(dllexport)
    #endif
#else
    #ifdef __cplusplus
    #define C_API extern "C"
    #else
    #define C_API
    #endif
#endif

#ifdef WIN32
typedef long long int64;
#else
#include <inttypes.h>
typedef int64_t int64;
#endif


// ������ BOOL
/*
	IOS_DH:				��ʶ�����.a��ΪIOS�汾,��Ҫ����BOOLΪsigned char(��IOSϵͳ����һ��)
	TARGET_OS_IPHONE��	��ʶĿǰ�ı��뻷��ΪIOS����ʵ����,��˲�Ҫ�ض���BOOL,�����ͻ
	����			��	linux or win,��Ҫ����BOOL����
*/
#ifdef IOS_DH
typedef signed char BOOL;
#elif TARGET_OS_IPHONE

#else
typedef int BOOL;
#endif

#endif
