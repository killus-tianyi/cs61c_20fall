#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    node *tortoise = head, *hare = head;
    do
    {
        if (hare != NULL && hare->next != NULL)
        {
            hare = hare->next->next;
        }
        else
        {
            return 0;
        }
        tortoise = tortoise->next;
    } while (hare != tortoise);
    return 1;
}