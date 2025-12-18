// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

void  schedNewEvent (struct dummyq_struct * I1476, EBLK  * I1471, U  I628);
void  schedNewEvent (struct dummyq_struct * I1476, EBLK  * I1471, U  I628)
{
    U  I1766;
    U  I1767;
    U  I1768;
    struct futq * I1769;
    struct dummyq_struct * pQ = I1476;
    I1766 = ((U )vcs_clocks) + I628;
    I1768 = I1766 & ((1 << fHashTableSize) - 1);
    I1471->I674 = (EBLK  *)(-1);
    I1471->I675 = I1766;
    if (0 && rmaProfEvtProp) {
        vcs_simpSetEBlkEvtID(I1471);
    }
    if (I1766 < (U )vcs_clocks) {
        I1767 = ((U  *)&vcs_clocks)[1];
        sched_millenium(pQ, I1471, I1767 + 1, I1766);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I628 == 1)) {
        I1471->I677 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I674 = I1471;
        peblkFutQ1Tail = I1471;
    }
    else if ((I1769 = pQ->I1377[I1768].I697)) {
        I1471->I677 = (struct eblk *)I1769->I695;
        I1769->I695->I674 = (RP )I1471;
        I1769->I695 = (RmaEblk  *)I1471;
    }
    else {
        sched_hsopt(pQ, I1471, I1766);
    }
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
