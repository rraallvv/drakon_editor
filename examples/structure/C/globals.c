/* Autogenerated with DRAKON Editor 1.23 */
#include "globals.h"

#include <stdio.h>
#include <memory.h>




static type_info_t person_t = {
    OBJECT_SIGNATURE,
   "person",
    (destructor_fun)person_destroy
};
person* person_create(void) {
    person* self = allocate_memory(sizeof(person));
    self->base.type = &person_t;
    self->age = 30;
    self->first_name = string8_create();
    self->friends = obj_list_create(0);
    return self;
}
void person_destroy(
    person* self // takes ownership, can be null
) {
    if (!self) return;
    ENSURE(self->base.type == &person_t)
    string8_destroy(self->first_name);
    obj_list_destroy(self->friends);
    free_memory(self, sizeof(person));
}
static int g_module_initialised = 0;
int mega_int = 10;
string8* buffer = 0;
obj_list* list = 0;
void globals_init(void) {
    if (g_module_initialised) return;
    g_module_initialised = 1;
    buffer = string8_create();
    list = obj_list_create(1);
}
int main(
    int argc,
    char** argv
) {
    // item 22
    int i, count;
    string8* s;
    person* p = person_create(); // own
    /* item 26 */
    string8_add(p->first_name, 'J');
    string8_add(p->first_name, 'a');
    string8_add(p->first_name, 'n');
    /* item 21 */
    globals_init();
    /* item 230001 */
    i = 0;
    
    item_230002 :
    if (i < 3) {
        /* item 25 */
        obj_list_add(
          list, 
          string8_from_cstr("hello", 100)
        );
        /* item 230003 */
        i++;
        goto item_230002;
    } else {
        /* item 28 */
        count = obj_list_length(list);
        /* item 290001 */
        i = 0;
    }
    
    item_290002 :
    if (i < count) {
        /* item 31 */
        s = obj_list_get(list, i);
        string8_print(s);
        /* item 290003 */
        i++;
        goto item_290002;
    } else {
        /* item 27 */
        string8_print(p->first_name);
        /* item 20 */
        person_destroy(p);
        
        return 0;
    }
    
}



