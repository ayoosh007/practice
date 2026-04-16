#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define BUFFER_SIZE 1024

int parityCheck(char *binary) {
    int count = 0;
    for (int i = 0; binary[i] != '\0'; i++) {
        if (binary[i] == '1') {
            count++;
        }
    }
    return (count % 2 == 0) ? 0 : 1;
}

int main() {
    int serverSocket, clientSocket;
    struct sockaddr_in serverAddr, clientAddr;
    socklen_t addrSize;
    char buffer[BUFFER_SIZE];

    // Create socket
    serverSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (serverSocket < 0) {
        perror("Error in socket creation");
        exit(1);
    }
    int opt = 1;
    setsockopt(serverSocket, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    // Set server address
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(12345);
    serverAddr.sin_addr.s_addr = INADDR_ANY;

    // Bind the socket to the server address
    if (bind(serverSocket, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) < 0) {
        perror("Error in binding");
        exit(1);
    }

    // Listen for incoming connections
    if (listen(serverSocket, 10) < 0) {
        perror("Error in listening");
        exit(1);
    }

    printf("Server listening on port 12345...\n");

    while (1) {
        // Accept a client connection
        addrSize = sizeof(clientAddr);
        clientSocket = accept(serverSocket, (struct sockaddr*)&clientAddr, &addrSize);
        if (clientSocket < 0) {
            perror("Error in accepting client connection");
            exit(1);
        }

        printf("Client connected\n");

        // Receive binary number from the client
        memset(buffer, 0, BUFFER_SIZE);
        if (read(clientSocket, buffer, BUFFER_SIZE) < 0) {
            perror("Error in reading from client");
            exit(1);
        }

        // Perform parity check
        int parity = parityCheck(buffer);

        // Send the result back to the client
        if (write(clientSocket, &parity, sizeof(parity)) < 0) {
            perror("Error in writing to client");
            exit(1);
        }

        printf("Result sent to the client\n");

        // Close the client socket
        close(clientSocket);
    }

    // Close the server socket
    close(serverSocket);

    return 0;
}

