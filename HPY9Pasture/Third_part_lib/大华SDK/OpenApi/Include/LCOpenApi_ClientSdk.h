
#ifndef _LCOPENAPI_CLIENT_SDK_H_
#define _LCOPENAPI_CLIENT_SDK_H_

#include "LCOpenApi_ConstString.h"

namespace LCOpenApi{
    
#define HTTP_OK						200
#define HTTP_BAD_REQUEST			400
#define HTTP_UNAUTHORIZED			401
#define HTTP_FORBIDDEN				403
#define HTTP_NOT_FOUND				404
#define HTTP_PRECONDITION_FAILED	412
typedef int BOOL;

// ����ṹ�����
typedef struct LCOpenApi_LCOpenApiRequest
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
	int (*build)(struct LCOpenApi_LCOpenApiRequest *p);
	int (*sign)(struct LCOpenApi_LCOpenApiRequest *p, const char *appId, const char *appSecret, const char *time);
	void (*destroy)(struct LCOpenApi_LCOpenApiRequest *p);
} LCOpenApi_LCOpenApiRequest;

// ��Ӧ�ṹ�����
typedef struct LCOpenApi_LCOpenApiResponse
{
	CSTR headers;
	int code;
	CSTR desc;
	int content_length;
	CSTR content;

	CSTR id;
	CSTR ret_code;
	CSTR ret_msg;
	
	int (*parse)(struct LCOpenApi_LCOpenApiResponse *p);
	void (*copy)(struct LCOpenApi_LCOpenApiResponse *p, struct LCOpenApi_LCOpenApiResponse *src);
	void (*destroy)(struct LCOpenApi_LCOpenApiResponse *p);
} LCOpenApi_LCOpenApiResponse;

// �ͻ��˾��
typedef void *LCOpenApi_LCOpenApiClient;

// ����
LCOpenApi_LCOpenApiClient LCOpenApi_lcopenapi_client_create(const char *host, int port);

// ����
void LCOpenApi_lcopenapi_client_destroy(LCOpenApi_LCOpenApiClient hc);

// �������󣬵õ���Ӧ��timeout��ʱʱ�䣬��λ��
// �ɹ�����0��ʧ�ܷ���-1
int LCOpenApi_lcopenapi_client_request(LCOpenApi_LCOpenApiClient hc, LCOpenApi_LCOpenApiRequest *req, LCOpenApi_LCOpenApiResponse *resp, int timeout);

void LCOpenApi_lcopenapi_client_set_appId(const char *appId);
void LCOpenApi_lcopenapi_client_set_appSecret(const char *appSecret);
unsigned int LCOpenApi_lcopenapi_client_get_serialNo();

CSTR LCOpenApi_lcopenapi_client_get_version();
CSTR LCOpenApi_lcopenapi_client_get_appId();
CSTR LCOpenApi_lcopenapi_client_get_appSecret();
// ����ʹ�����к�
#define LCOpenApi_LCOPENAPI_INIT(name)		lcopenapi_api_init_##name()
#define LCOpenApi_LCOPENAPI_COPY(dst, src)	(dst)->base.copy(&(dst)->base, &(src)->base)
#define LCOpenApi_LCOPENAPI_DESTROY(ptr)		(ptr)->base.destroy(&(ptr)->base)

#define LCOpenApi_LCOPENAPI_REQUEST(hc, req, resp, timeout)	LCOpenApi_lcopenapi_client_request(hc, (LCOpenApi_LCOpenApiRequest *)req, (LCOpenApi_LCOpenApiResponse *)resp, timeout)


}
#endif
