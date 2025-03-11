#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/_types/_pid_t.h>
#include <time.h>

int main() {
    /*Resources:
     * Creating Pipes in C, https://tldp.org/LDP/lpg/node11.html
     * C Program to Demonstrate fork() and pipe(): https://www.geeksforgeeks.org/c-program-demonstrate-fork-and-pipe/
     * Creating a pipe: https://www.gnu.org/software/libc/manual/html_node/Creating-a-Pipe.html
     */

    /*
     * Declaring Array with two ints
     * Element 0 is used for reading -> takes input from Element 1
     * Element 1 is used for writing -> writes into Element 0
     */
    int fd[2];

    // Establish pipeline
    if (pipe(fd) == -1) {
        perror( "pipe failed");
        exit(1);
    }

    // Fork child process
    const pid_t pid = fork();
    if (pid == -1) {
        perror("fork");
        exit(1);
    }

    if (pid == 0) {
        // Close the write end of the pipe as the child only reads
        close(fd[1]);
        //printf("Child process: PID = %d, PPID = %d\n", getpid(), getppid());

        char buffer[1024];
        long count = 0;
        ssize_t bytesRead;

        while ((bytesRead = read(fd[0], buffer, 1024)) > 0) {
            count += bytesRead;
        }

        // Close the read end of the pipe after reading is complete
        close(fd[0]);
        printf("Child process exited, read Bytes: %ld\n", count);
        exit(0);
    } else {
        // Close the read end of the pipe as the parent only writes
        close(fd[0]);
        //printf("Parent process: PID = %d, Child PID = %d\n", getpid(), pid);

        srand(time(NULL));

        // Resource:
        // https://www.tutorialspoint.com/c_standard_library/c_function_srand.htm
        // https://stackoverflow.com/questions/18726102/what-difference-between-rand-and-random-functions
        // https://www.geeksforgeeks.org/c-rand-function/
        // https://www.tenouk.com/cpluscodesnippet/anotherandomnumbergenerate.html
        const long random_num = 100 + rand() % (1000 - 100 + 1);
        printf("Random Number: %ld\n", random_num);

        for (long i = 0; i < random_num; i++) {
            // writ n spaces into pipe
            if (write(fd[1], " ", 1) == -1) {
                perror("write");
                close(fd[1]);
                exit(1);
            }
        }

        close(fd[1]);

        // Wait for child
        // Resource: https://stackoverflow.com/questions/19461744/how-to-make-parent-wait-for-all-child-processes-to-finish

        int return_status;
        if (waitpid(pid, &return_status, 0) == -1) {
            perror("waitpid");
        }

        if (WIFEXITED(return_status)) {
            printf("Child exited with status: %d\n", WEXITSTATUS(return_status));
        }
    }

    return 0;
}
