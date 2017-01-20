#ifndef _LCOPENAPI_CLIENT_OAUTH2CLIENT_H_
#define _LCOPENAPI_CLIENT_OAUTH2CLIENT_H_

#include "basedef.h"

// ������
enum
{
	OAC_ERROR_PARAMS = - 1,		// ��������
	OAC_ERROR_CURL = - 2,		// curl����ʧ��
	OAC_ERROR_HTTP = - 3,		// HTTP����ʧ��
	OAC_ERROR_JSON = - 4,		// JSON��������
};

// OAuth2��ʼ��Ϣ
typedef struct
{
	char host[256];				// �����ַ
	char client_id[64];			// �ͻ���ID
	char client_secret[64];		// �ͻ�����Կ
	long timeout;				// ����ʱʱ�䣨�룩
} OAuth2Initial;

// AccessToken��Ϣ
typedef struct
{
	char access_token[64];		// AccessToken
	char token_type[64];		// AccessToken����
	int expires_in;				// AccessToken��Чʱ�䣨�룩
} AccessTokenInfo;

// ʹ��OAuth2�е�password��Ȩģʽ��ȡaccessToken
// ��Σ�
//   initial��OAuth2��������
//   username���˺��û���
//   password���˺����룬��ժҪ�㷨����md5)֮�������
// ���Σ�
//   akinfo�����������ص�AccessToken��Ϣ
// �ɹ�����0��ʧ�ܷ��ش�����
C_API int oauth2_client_get_access_token_by_password(const OAuth2Initial *initial, 
													 const char *username, const char *password, 
													 AccessTokenInfo *akinfo);

// ��ȡ��һ�εľ���������������̰߳�ȫ��
C_API const char *oauth2_client_get_error_info();

#endif
