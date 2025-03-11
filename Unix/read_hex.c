//
// Created by Sophie Haack on 15.12.24.
//
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>

#define BYTE_COUNT 16

/**
 * 
 * @param argc Amount of cli args
 * @param argv array of cli argument strings
 * @return exit status
 */

int main(const int argc, char *argv[]) {

    /*
     * check if (one) file path is provided
     * src: https://www.c-howto.de/tutorial/funktionen-teil-2/hauptfunktion/
     */
    if (argc != 2) {
        printf("Please input a filepath to the file you would like bytes from (only).\n");
        return 1;
    }

    /*
     * Using the open() to open the file specified
     * argv[1] contains the file path
     * the flag O_RDONLY opens the file in read-only mode
     * It creates a file descriptor of the file from which data is to be read
     * src:
     * https://www.codequoi.com/en/handling-a-file-by-its-descriptor-in-c/
     * https://www.geeksforgeeks.org/input-output-system-calls-c-create-open-close-read-write/
     */
    const int fd = open(argv[1], O_RDONLY);
    if (fd < 0) {
        perror("Error opening file");
        return 1;
    }


    /*
     * Creating a buffer with exact 8-bit elements to store bytes read from the file
     * src:
     * https://www.reddit.com/r/C_Programming/comments/u50krp/when_to_use_uint8_t_and_what_are_the_benefits_of/
     * https://stackoverflow.com/questions/19224655/using-ssize-t-vs-int
     */
    uint8_t buf[BYTE_COUNT];

    /*
     * Reading up to BYTE_COUNT bytes from the file into the buffer using read()
     * ssize_t is used to handle the count of bytes read and error indications
     * src:
     * https://manpages.ubuntu.com/manpages/lunar/man3/size_t.3type.html#:~:text=ssize_t%20Used%20for%20a%20count,%5B%2D1%2C%20SSIZE_MAX%5D.
     * https://stackoverflow.com/questions/53282274/difference-between-uint8-t-and-unsigned-char
     * https://man7.org/linux/man-pages/man2/read.2.html
     * https://www.geeksforgeeks.org/input-output-system-calls-c-create-open-close-read-write/
     */
    const ssize_t bytes_read = read(fd, buf, BYTE_COUNT);
    if (bytes_read < 0) {
        perror("Error reading file");
        close(fd);
        return 1;
    }


    /*Loop through all the bytes read*/
    for (ssize_t i = 0; i < bytes_read; i++) {
        /*
         * Print the current byte in hexadecimal with at least two chars
         * src:
         * https://stackoverflow.com/questions/18438946/format-specifier-02x
         * https://stackoverflow.com/questions/10599068/how-do-i-print-bytes-as-hexadecimal#1# */
        printf("%02x", buf[i]);
        if (i < bytes_read - 1) {
            /*Add white space if not last byte*/
            printf(" ");
        }
    }
    printf("\n");


    //Close Syscall
    if (close(fd) < 0) {
        perror("Error closing file");
        return 1;
    }

    return 0;
}
