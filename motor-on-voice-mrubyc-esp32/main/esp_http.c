#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "esp_log.h"
#include "mrubyc.h"
#include "esp_http.h"
#include "esp_http_client.h"


#define MAX_HTTP_RECV_BUFFER 512
static const char *TAG = "HTTP_CLIENT";
static char response[100];
esp_http_client_handle_t client;

extern const char howsmyssl_com_root_cert_pem_start[] asm("_binary_howsmyssl_com_root_cert_pem_start");
extern const char howsmyssl_com_root_cert_pem_end[]   asm("_binary_howsmyssl_com_root_cert_pem_end");

esp_err_t _http_event_handler(esp_http_client_event_t *evt)
{
    switch(evt->event_id) {
        case HTTP_EVENT_ERROR:
            ESP_LOGD(TAG, "HTTP_EVENT_ERROR");
            break;
        case HTTP_EVENT_ON_CONNECTED:
            ESP_LOGD(TAG, "HTTP_EVENT_ON_CONNECTED");
            break;
        case HTTP_EVENT_HEADER_SENT:
            ESP_LOGD(TAG, "HTTP_EVENT_HEADER_SENT");
            break;
        case HTTP_EVENT_ON_HEADER:
            ESP_LOGD(TAG, "HTTP_EVENT_ON_HEADER, key=%s, value=%s", evt->header_key, evt->header_value);
            break;
        case HTTP_EVENT_ON_DATA:
            ESP_LOGD(TAG, "HTTP_EVENT_ON_DATA, len=%d", evt->data_len);
            if (!esp_http_client_is_chunked_response(evt->client)) {
                // Write out data
                // printf("%.*s", evt->data_len, (char*)evt->data);
                strncpy(response, evt->data, evt->data_len);
            }

            break;
        case HTTP_EVENT_ON_FINISH:
            ESP_LOGD(TAG, "HTTP_EVENT_ON_FINISH");
            break;
        case HTTP_EVENT_DISCONNECTED:
            ESP_LOGD(TAG, "HTTP_EVENT_DISCONNECTED");
            break;
    }
    return ESP_OK;
}

void c_http_client_init(mrb_vm *vm, mrb_value *v, int argc){
  unsigned char *input_url = GET_STRING_ARG(1);
    esp_http_client_config_t config = {
        .url = (char *)input_url,
        .event_handler = _http_event_handler,
    };
    client = esp_http_client_init(&config);
}

void c_http_request(mrb_vm *vm, mrb_value *v, int argc){
  esp_err_t err = esp_http_client_perform(client);
  mrb_value result;
    if (err != ESP_OK) {
      result = mrbc_string_new(vm, esp_err_to_name(err), strlen(esp_err_to_name(err)));
      SET_RETURN(result);
      // ESP_LOGE(TAG, "HTTP GET request failed: %s", esp_err_to_name(err));
    }else{
      result = mrbc_string_new(vm, response, strlen(response));
      SET_RETURN(result);
    }
}

void c_http_client_cleanup(mrb_vm *vm, mrb_value *v, int argc){
  esp_http_client_cleanup(client);
}
