#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define BUFFER_SIZE 1024

int main() {
    int clientSocket;
    struct sockaddr_in serverAddr;
    char buffer[BUFFER_SIZE];
    int parity;

    // Create socket
    clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (clientSocket < 0) {
        perror("Error in socket creation");
        exit(1);
    }

    // Set server address
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(12345);
    serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");

    // Connect to the server
    if (connect(clientSocket, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) < 0) {
        perror("Error in connecting to server");
        exit(1);
    }

    printf("Connected to server\n");

    // Get binary number from the user
    printf("Enter a binary number: ");
    fgets(buffer, BUFFER_SIZE, stdin);
    buffer[strcspn(buffer, "\n")] = '\0';

    // Send binary number to the server
    if (write(clientSocket, buffer, strlen(buffer)) < 0) {
        perror("Error in writing to server");
        exit(1);
    }

    // Receive the result from the server
    if (read(clientSocket, &parity, sizeof(parity)) < 0) {
        perror("Error in reading from server");
        exit(1);
    }

    // Check the result
    if (parity == 0) {
        printf("Parity check passed.\n");
    } else {
        printf("Parity check failed.\n");
    }

    // Close the client socket
    close(clientSocket);

    return 0;
}

