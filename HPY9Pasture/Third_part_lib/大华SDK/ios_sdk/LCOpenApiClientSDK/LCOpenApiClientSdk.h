/************************************************************************/
/*                                                                      */
/*        ����΢Ѷ�ͻ���SDK                dahuatech, 2014              */
/*                                                                      */
/************************************************************************/
#ifndef _LC_OPENAPI_CLIENT_SDK_H_
#define _LC_OPENAPI_CLIENT_SDK_H_

#include "basedef.h"
#include "FreeBuffer.h"
#include "ConstString.h"

// HTTP״̬��
#define HTTP_OK						200
#define HTTP_BAD_REQUEST			400
#define HTTP_UNAUTHORIZED			401
#define HTTP_FORBIDDEN				403
#define HTTP_NOT_FOUND				404
#define HTTP_PRECONDITION_FAILED	412

// API���ش����
#define APICODE_SUCCESS		1000

// ����ṹ�����
typedef struct LCOpenApiRequest
{
	CSTR apiname;
	CSTR fullname;
	CSTR method;
	CSTR uri;
	CSTR content_type;
	CSTR body;

	CSTR params;
	CSTR messageId;
	CSTR time;
	CSTR nonce;
	CSTR signMd5;
	int (*build)(struct LCOpenApiRequest *p);
	int (*sign)(struct LCOpenApiRequest *p, const char *appId, const char *appSecret, const char *time);
	void (*destroy)(struct LCOpenApiRequest *p);
} LCOpenApiRequest;

// ��Ӧ�ṹ�����
typedef struct LCOpenApiResponse
{
	CSTR headers;
	int code;
	CSTR desc;
	int content_length;
	CSTR content;

	CSTR id;
	CSTR ret_code;
	CSTR ret_msg;
	
	int (*parse)(struct LCOpenApiResponse *p);
	void (*copy)(struct LCOpenApiResponse *p, struct LCOpenApiResponse *src);
	void (*destroy)(struct LCOpenApiResponse *p);
} LCOpenApiResponse;

// ��ȫ�֡����ÿͻ�������
C_API void lcopenapi_client_set_client(const char *type, const char *mac);
C_API void lcopenapi_client_set_os_version(const char *version);
C_API void lcopenapi_client_set_sdk_version(const char *version);
C_API void lcopenapi_client_set_safe_code(const char *bundleId);
C_API void lcopenapi_client_set_ca_path(const char *caPath);

C_API void lcopenapi_client_set_uri_prefix(const char *prefix); //ע��: prefix��'/'����, ��/x/api/
C_API void lcopenapi_client_set_appId(const char *appId);
C_API void lcopenapi_client_set_appSecret(const char *appSecret);

C_API CSTR lcopenapi_client_get_client_type();
C_API CSTR lcopenapi_client_get_client_mac();
C_API CSTR lcopenapi_client_get_os_version();
C_API CSTR lcopenapi_client_get_sdk_version();
C_API CSTR lcopenapi_client_get_safe_code();
C_API CSTR lcopenapi_client_get_ca_path();

C_API CSTR lcopenapi_client_get_version();
C_API CSTR lcopenapi_client_get_uri_prefix();
C_API CSTR lcopenapi_client_get_appId();
C_API CSTR lcopenapi_client_get_appSecret();

C_API unsigned int lcopenapi_client_get_serialNo();
// ��־����ȼ�
enum
{
	LOG_ERROR = 0,
	LOG_WARN,
	LOG_INFO,
	LOG_DEBUG,
	LOG_VERBOSE
};
// ��־�������ԭ��
typedef void (*LCOpenApiClientLogger)(int level, const char *str);
// ��ȫ�֡������Զ������־�������
C_API void lcopenapi_client_set_logger(LCOpenApiClientLogger logger);

// �ͻ��˾��
typedef void *LCOpenApiClient;

// ����
C_API LCOpenApiClient lcopenapi_client_create(const char *host, int port);

// ����
C_API void lcopenapi_client_destroy(LCOpenApiClient hc);



//C_API void lcopenapi_client_set_domain_auth(LCOpenApiClient hc, const char *domain, const char *account, const char *key);

// �������󣬵õ���Ӧ��timeout��ʱʱ�䣬��λ��
// �ɹ�����0��ʧ�ܷ���-1
C_API int lcopenapi_client_request(LCOpenApiClient hc, LCOpenApiRequest *req, LCOpenApiResponse *resp, int timeout);

// ����ʹ�����к�
#define LCOPENAPI_INIT(name)		lcopenapi_api_init_##name()
#define LCOPENAPI_COPY(dst, src)	(dst)->base.copy(&(dst)->base, &(src)->base)
#define LCOPENAPI_DESTROY(ptr)		(ptr)->base.destroy(&(ptr)->base)

#define LCOPENAPI_REQUEST(hc, req, resp, timeout)	lcopenapi_client_request(hc, (LCOpenApiRequest *)req, (LCOpenApiResponse *)resp, timeout)

#endif
