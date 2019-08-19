#include "mrubyc.h"

void c_http_client_init(mrb_vm *vm, mrb_value *v, int argc);
void c_http_request(mrb_vm *vm, mrb_value *v, int argc);
void c_http_client_cleanup(mrb_vm *vm, mrb_value *v, int argc);
