#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include <uthread.h>
#include <fs.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

#define test_fs_error(fmt, ...) \
	fprintf(stderr, "%s: "fmt"\n", __func__, ##__VA_ARGS__)

#define die(...)			\
do {					\
	test_fs_error(__VA_ARGS__);	\
	exit(1);			\
} while (0)

#define die_perror(msg)	\
do {			\
	perror(msg);	\
	exit(1);	\
} while (0)


struct thread_arg {
	int argc;
	char **argv;
};

void thread_fs_stat(void *arg)
{
	struct thread_arg *t_arg = arg;
	char *diskname, *filename;
	int fs_fd;
	size_t stat;

	if (t_arg->argc < 2)
		die("need <diskname> <filename>");

	diskname = t_arg->argv[0];
	filename = t_arg->argv[1];

	if (fs_mount(diskname))
		die("Cannot mount diskname");

	fs_fd = fs_open(filename);
	if (fs_fd < 0) {
		fs_umount();
		die("Cannot open file");
	}

	stat = fs_stat(fs_fd);
	if (stat < 0) {
		fs_umount();
		die("Cannot stat file");
	}
	if (!stat) {
		/* Nothing to read, file is empty */
		printf("Empty file\n");
		return;
	}

	if (fs_close(fs_fd)) {
		fs_umount();
		die("Cannot close file");
	}

	if (fs_umount())
		die("cannot unmount diskname");

	printf("Size of file '%s' is %zu bytes\n", filename, stat);
}

void thread_fs_cat(void *arg)
{
	struct thread_arg *t_arg = arg;
	char *diskname, *filename, *buf;
	int fs_fd;
	size_t stat, read;

	if (t_arg->argc < 2)
		die("need <diskname> <filename>");

	diskname = t_arg->argv[0];
	filename = t_arg->argv[1];

	if (fs_mount(diskname))
		die("Cannot mount diskname");

	fs_fd = fs_open(filename);
	if (fs_fd < 0) {
		fs_umount();
		die("Cannot open file");
	}

	stat = fs_stat(fs_fd);
	if (stat < 0) {
		fs_umount();
		die("Cannot stat file");
	}
	if (!stat) {
		/* Nothing to read, file is empty */
		printf("Empty file\n");
		return;
	}
	buf = malloc(stat);
	if (!buf) {
		perror("malloc");
		fs_umount();
		die("Cannot malloc");
	}

	read = fs_read(fs_fd, buf, stat);

	if (fs_close(fs_fd)) {
		fs_umount();
		die("Cannot close file");
	}

	if (fs_umount())
		die("cannot unmount diskname");

	printf("Read file '%s' (%zu/%zu bytes)\n", filename, read, stat);
	printf("Content of the file:\n%s", buf);

	free(buf);
}

void thread_fs_rm(void *arg)
{
	struct thread_arg *t_arg = arg;
	char *diskname, *filename;

	if (t_arg->argc < 2)
		die("need <diskname> <filename>");

	diskname = t_arg->argv[0];
	filename = t_arg->argv[1];

	if (fs_mount(diskname))
		die("Cannot mount diskname");

	if (fs_delete(filename)) {
		fs_umount();
		die("Cannot delete file");
	}

	if (fs_umount())
		die("Cannot unmount diskname");

	printf("Removed file '%s'\n", filename);
}

void thread_fs_type(void *arg)
{
	struct thread_arg *t_arg = arg;
	char *diskname, *filename, *buf;
	int fs_fd;
  size_t written=0;

	if (t_arg->argc < 2)
		die("Usage: <diskname> <fs filename>");

	diskname = t_arg->argv[0];
  filename = t_arg->argv[1];

	/* Now, deal with our filesystem:
	 * - mount, create a new file, copy content of host file into this new
	 *   file, close the new file, and umount
	 */
	if (fs_mount(diskname))
		die("Cannot mount diskname");

	if (fs_create(filename)) {
		//fs_umount();
		//die("Cannot create file");
		
	}

	fs_fd = fs_open(filename);
	if (fs_fd < 0) {
		fs_umount();
		die("Cannot open file");
	}

  char buff[1024];
  while(fgets(buff, 1024, stdin)){
    buf = buff;
    size_t strlength = strlen(buff);
    int written_bytes=0;
    while(strlength){
      written_bytes = fs_write(fs_fd, buf, strlength);
	  if(written_bytes < 0){
				printf("error\n");
				return;
			}
      strlength -= written_bytes;
      buf+=written_bytes;
    }
    written += written_bytes;
  }

	if (fs_close(fs_fd)) {
		fs_umount();
		die("Cannot close file");
	}

	if (fs_umount())
		die("Cannot unmount diskname");

	printf("Wrote file '%s' (%zu bytes)\n", filename, written);
}
void thread_fs_add(void *arg)
{
	struct thread_arg *t_arg = arg;
	char *diskname, *filename, *buf;
	int fd, fs_fd;
	struct stat st;
	size_t written;

	if (t_arg->argc < 2)
		die("Usage: <diskname> <host filename>");

	diskname = t_arg->argv[0];
	filename = t_arg->argv[1];

	/* Open file on host computer */
	fd = open(filename, O_RDONLY);
	if (fd < 0)
		die_perror("open");
	if (fstat(fd, &st))
		die_perror("fstat");
	if (!S_ISREG(st.st_mode))
		die("Not a regular file: %s\n", filename);

	/* Map file into buffer */
	buf = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
	if (!buf)
		die_perror("mmap");

	/* Now, deal with our filesystem:
	 * - mount, create a new file, copy content of host file into this new
	 *   file, close the new file, and umount
	 */
	if (fs_mount(diskname))
		die("Cannot mount diskname");

	if (fs_create(filename)) {
		fs_umount();
		die("Cannot create file");
	}

	fs_fd = fs_open(filename);
	if (fs_fd < 0) {
		fs_umount();
		die("Cannot open file");
	}

	written = fs_write(fs_fd, buf, st.st_size);

	if (fs_close(fs_fd)) {
		fs_umount();
		die("Cannot close file");
	}

	if (fs_umount())
		die("Cannot unmount diskname");

	printf("Wrote file '%s' (%zu/%zu bytes)\n", filename, written,
	       st.st_size);

	munmap(buf, st.st_size);
	close(fd);
}

void thread_fs_ls(void *arg)
{
	struct thread_arg *t_arg = arg;
	char *diskname;

	if (t_arg->argc < 1)
		die("Usage: <diskname> <filename>");

	diskname = t_arg->argv[0];

	if (fs_mount(diskname))
		die("Cannot mount diskname");

	fs_ls();

	if (fs_umount())
		die("Cannot unmount diskname");
}

void thread_fs_info(void *arg)
{
	struct thread_arg *t_arg = arg;
	char *diskname;

	if (t_arg->argc < 1)
		die("Usage: <diskname>");

	diskname = t_arg->argv[0];

	if (fs_mount(diskname))
		die("Cannot mount diskname");

	fs_info();

	if (fs_umount())
		die("Cannot unmount diskname");
}

static struct {
	const char *name;
	uthread_func_t func;
} commands[] = {
	{ "info",	thread_fs_info },
	{ "ls",		thread_fs_ls },
	{ "add",	thread_fs_add },
	{ "rm",		thread_fs_rm },
	{ "cat",	thread_fs_cat },
	{ "stat",	thread_fs_stat },
	{ "type",	thread_fs_type },
};

void usage(void)
{
	int i;
	fprintf(stderr, "Usage: test-fs <command> [<arg>]\n");
	fprintf(stderr, "Possible commands are:\n");
	for (i = 0; i < ARRAY_SIZE(commands); i++)
		fprintf(stderr, "\t%s\n", commands[i].name);
	exit(1);
}

int main(int argc, char **argv)
{
	int i;
	char *cmd;
	struct thread_arg arg;

	/* Skip argv[0] */
	argc--;
	argv++;

	if (!argc)
		usage();

	cmd = argv[0];
	arg.argc = --argc;
	arg.argv = &argv[1];

	for (i = 0; i < ARRAY_SIZE(commands); i++) {
		if (!strcmp(cmd, commands[i].name)) {
			uthread_start(commands[i].func, &arg);
			break;
		}
	}
	if (i == ARRAY_SIZE(commands)) {
		test_fs_error("invalid command '%s'", cmd);
		usage();
	}

	return 0;
}
