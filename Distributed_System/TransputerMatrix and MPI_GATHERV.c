/*************************************************************
     В транспьютерной матрице размером 4*4, в каждом узле которой находится один процесс, 
    необходимо выполнить операцию сбора данных от всех процессов для одного (MPI_GATHERV). 
    Каждый i-ый процесс имеет массив из i чисел (длинной 4 байта), которые необходимо отправить процессу с координатами (0,0).
    Реализовать программу, моделирующую выполнение операции MPI_GATHERV на транспьютерной матрице при помощи пересылок MPI типа точка-точка.
    Получить временную оценку работы алгоритма. Оценить сколько времени потребуется для выполнения операции MPI_GATHERV, 
    если все процессы выдали ее одновременно. Время старта равно 100, время передачи байта равно 1 (Ts=100,Tb=1). 
    Процессорные операции, включая чтение из памяти и запись в память, считаются бесконечно быстрыми
 
 **********************************************************************/


#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

#define N 4 // Размер транспьютерной матрицы

int main(int argc, char *argv[]) {
    MPI_Init(&argc, &argv);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size != N * N) {
        if (rank == 0) {
            printf("Number of processes must be equal to %d.\n", N * N);
        }
        MPI_Finalize();
        return 0;
    }

    int row = rank / N;
    int col = rank % N;
    int root_rank = 0;

    /************* Each process creates an array with a size equal to its rank ************/
    int *data = (int *)malloc(rank * sizeof(int));
    for (int i = 0; i < rank; i++) {
        data[i] = rank;
    }

    /************* Define the lengths of arrays and their displacements for MPI_Gatherv ************/
    int *recvcounts = NULL;
    int *displs = NULL;
    if (rank == root_rank) {
        recvcounts = (int *)malloc(size * sizeof(int));
        displs = (int *)malloc(size * sizeof(int));
        int offset = 0;
        for (int i = 0; i < size; i++) {
            recvcounts[i] = i; // Number of elements to receive from process i
            displs[i] = offset; // Offset in the receive buffer
            offset += i;
        }
    }

    /************* Allocate memory for the receive buffer on process 0 ************/
    int total_data_size = (size * (size - 1)) / 2; // Total elements to gather (sum of 0 to size-1)
    int *recvbuf = NULL;
    if (rank == root_rank) {
        recvbuf = (int *)malloc(total_data_size * sizeof(int));
    }

    /************* Perform MPI_Gatherv-like operation using point-to-point communication ************/
    if (rank == root_rank) {
        int offset = 0;
        for (int i = 0; i < size; i++) {
            if (i == root_rank) {
                /************* Copy its own data into the receive buffer ************/
                for (int j = 0; j < recvcounts[i]; j++) {
                    recvbuf[displs[i] + j] = data[j];
                }
            } else {
                /************* Receive data from other processes ************/
                MPI_Recv(&recvbuf[displs[i]], recvcounts[i], MPI_INT, i, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            }
        }
    } else {
        /************* Send data to process 0 ************/
        MPI_Send(data, rank, MPI_INT, root_rank, 0, MPI_COMM_WORLD);
    }

    /************* Print the gathered result on process 0 ************/
    if (rank == root_rank) {
        printf("Resulting buffer on process %d: ", rank);
        for (int i = 0; i < total_data_size; i++) {
            printf("%d ", recvbuf[i]);
        }
        printf("\n");
    }

    /************* Free allocated memory to prevent memory leaks ************/
    free(data);
    if (rank == root_rank) {
        free(recvcounts);
        free(displs);
        free(recvbuf);
    }

    MPI_Finalize();
    return 0;
}
