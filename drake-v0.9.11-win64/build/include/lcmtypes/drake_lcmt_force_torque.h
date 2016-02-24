/** THIS IS AN AUTOMATICALLY GENERATED FILE.  DO NOT MODIFY
 * BY HAND!!
 *
 * Generated by lcm-gen
 **/

#include <stdint.h>
#include <stdlib.h>
#include <lcm/lcm_coretypes.h>
#include <lcm/lcm.h>

#ifndef _drake_lcmt_force_torque_h
#define _drake_lcmt_force_torque_h

#ifdef __cplusplus
extern "C" {
#endif

typedef struct _drake_lcmt_force_torque drake_lcmt_force_torque;
struct _drake_lcmt_force_torque
{
    int64_t    timestamp;
    double     fx;
    double     fy;
    double     fz;
    double     tx;
    double     ty;
    double     tz;
};

drake_lcmt_force_torque   *drake_lcmt_force_torque_copy(const drake_lcmt_force_torque *p);
void drake_lcmt_force_torque_destroy(drake_lcmt_force_torque *p);

typedef struct _drake_lcmt_force_torque_subscription_t drake_lcmt_force_torque_subscription_t;
typedef void(*drake_lcmt_force_torque_handler_t)(const lcm_recv_buf_t *rbuf,
             const char *channel, const drake_lcmt_force_torque *msg, void *user);

int drake_lcmt_force_torque_publish(lcm_t *lcm, const char *channel, const drake_lcmt_force_torque *p);
drake_lcmt_force_torque_subscription_t* drake_lcmt_force_torque_subscribe(lcm_t *lcm, const char *channel, drake_lcmt_force_torque_handler_t f, void *userdata);
int drake_lcmt_force_torque_unsubscribe(lcm_t *lcm, drake_lcmt_force_torque_subscription_t* hid);
int drake_lcmt_force_torque_subscription_set_queue_capacity(drake_lcmt_force_torque_subscription_t* subs,
                              int num_messages);


int  drake_lcmt_force_torque_encode(void *buf, int offset, int maxlen, const drake_lcmt_force_torque *p);
int  drake_lcmt_force_torque_decode(const void *buf, int offset, int maxlen, drake_lcmt_force_torque *p);
int  drake_lcmt_force_torque_decode_cleanup(drake_lcmt_force_torque *p);
int  drake_lcmt_force_torque_encoded_size(const drake_lcmt_force_torque *p);

// LCM support functions. Users should not call these
int64_t __drake_lcmt_force_torque_get_hash(void);
int64_t __drake_lcmt_force_torque_hash_recursive(const __lcm_hash_ptr *p);
int     __drake_lcmt_force_torque_encode_array(void *buf, int offset, int maxlen, const drake_lcmt_force_torque *p, int elements);
int     __drake_lcmt_force_torque_decode_array(const void *buf, int offset, int maxlen, drake_lcmt_force_torque *p, int elements);
int     __drake_lcmt_force_torque_decode_array_cleanup(drake_lcmt_force_torque *p, int elements);
int     __drake_lcmt_force_torque_encoded_array_size(const drake_lcmt_force_torque *p, int elements);
int     __drake_lcmt_force_torque_clone_array(const drake_lcmt_force_torque *p, drake_lcmt_force_torque *q, int elements);

#ifdef __cplusplus
}
#endif

#endif
