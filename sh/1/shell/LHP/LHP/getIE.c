#include <stdio.h>
#include "version.h"

int main()
{
	FILE *fp;
	fp = fopen("IEID.txt","w");
	if (NULL == fp)
	{
		printf("open file error!!!");
		return -1;
	}
	int ieid = IE_CUSTOM;
	fprintf(fp, "IEID=%d", ieid);
	fclose(fp);
	return 0;
}


