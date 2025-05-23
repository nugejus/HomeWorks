/****************************
 
 Разработка параллельной версии программы для сортировки данных (любой метод).

 *****************************/

#include <stdio.h>

#include <stdlib.h>

#include <time.h>

#include <mpi.h>

#include <mpi-ext.h>

#include <stdbool.h>

#include <string.h>

#include <signal.h>

void merge(int * , int * , int, int, int);
void mergeSort(int * , int * , int, int);
void read_array_from_file(int * , int,
  const char * );
void save_state(int * , int, int, int);
bool load_state(int * , int, int * , int * );
void error_handler(MPI_Comm * pcomm, int * error_code, ...);

const char * checkpoint_file = "checkpoint.dat";
MPI_Comm main_comm;
MPI_Errhandler errh;
int rank, size;
int N;

int main(int argc, char ** argv) {

  int step = 0; // Control step tracking

  /********** Initialize MPI **********/
  int world_rank;
  int world_size;
  main_comm = MPI_COMM_WORLD;

  MPI_Init( & argc, & argv);
  MPI_Comm_rank(main_comm, & world_rank);
  MPI_Comm_size(main_comm, & world_size);

  MPI_Comm_create_errhandler(error_handler, & errh);
  MPI_Comm_set_errhandler(main_comm, errh);

  /********** Read array size and file name **********/
  if (argc < 3) {
    if (world_rank == 0)
      fprintf(stderr, "Usage: %s <array_size> <file_name> <kill rank:optional>\n", argv[0]);
    MPI_Finalize();
    return -1;
  }

  /********** Flush checkpoint file for next iteration **********/
  FILE * fd = fopen(checkpoint_file,"w+");
  fflush(fd);
  fclose(fd);

  N = atoi(argv[1]);
  const char * file_name = argv[2];

  /********** Simulate abortion by SIGKILL **********/
  int kill_rank = 0;

  if (argc >= 4) {
    kill_rank = atoi(argv[3]);
  }

  if (kill_rank && world_rank == kill_rank) {
    printf("Process %d will now be killed using SIGKILL.\n", world_rank);
    raise(SIGKILL);
  }

  int * original_array = NULL;
  if (world_rank == 0) {
    original_array = (int * ) malloc(N * sizeof(int));
    read_array_from_file(original_array, N, file_name);
  }
  step = 1;


  /********** Divide the array in equal-sized chunks **********/
  int size = N / world_size;
  int * sub_array = (int * ) malloc(size * sizeof(int));

  /********** Send each subarray to each process **********/
  MPI_Scatter(original_array, size, MPI_INT, sub_array, size, MPI_INT, 0, main_comm);
  if (world_rank == 0) {
    save_state(original_array, N, 1, world_rank); // Step 1: Scatter completed
  }
  MPI_Barrier(main_comm);
  step = 2;

  /********** Perform the mergesort on each process **********/
  int * tmp_array = (int * ) malloc(size * sizeof(int));
  mergeSort(sub_array, tmp_array, 0, (size - 1));
  if (world_rank == 0) {
    save_state(original_array, N, 1, world_rank); // Step 2:Sort Complete
  }
  MPI_Barrier(main_comm);
  step = 3;

  /********** Gather the sorted subarrays into one **********/
  int * sorted = NULL;
  if (world_rank == 0) {
    sorted = (int * ) malloc(N * sizeof(int));
  }
  MPI_Gather(sub_array, size, MPI_INT, sorted, size, MPI_INT, 0, main_comm);

  if (world_rank == 0) {
    save_state(sorted, N, 3, world_rank); // Step 3: Gather completed
  }
  MPI_Barrier(main_comm);
  step = 4;

  /********** Make the final mergeSort call **********/
  if (world_rank == 0) {
    int * other_array = (int * ) malloc(N * sizeof(int));
    mergeSort(sorted, other_array, 0, (N - 1));
  }
  if (world_rank == 0) {
    save_state(sorted, N, 4, world_rank); // Step 4: Final merge sort completed
  }
  MPI_Barrier(main_comm);

  /********** Write the sorted data to a file **********/
  MPI_File output_file;
  MPI_File_open(main_comm, "result.out", MPI_MODE_CREATE | MPI_MODE_WRONLY, MPI_INFO_NULL, & output_file);

  MPI_Offset write_offset = world_rank * size * sizeof(int);
  if (world_rank == 0) {
    MPI_File_write_at(output_file, 0, sorted, N, MPI_INT, MPI_STATUS_IGNORE);
  } else {
    MPI_File_write_at(output_file, write_offset, sub_array, size, MPI_INT, MPI_STATUS_IGNORE);
  }

  if(world_rank == 0 && N < 100){
    for(int i = 0; i < N; i ++)
      printf("%d ", sorted[i]);
  }
  printf("\n");
  MPI_Barrier(main_comm);

  /********** Safe Memory Freeing **********/
  if (sub_array != NULL) {
    free(sub_array);
    sub_array = NULL;
  }
  if (tmp_array != NULL) {
    free(tmp_array);
    tmp_array = NULL;
  }
  if (world_rank == 0 && sorted != NULL) {
    free(sorted);
    sorted = NULL;
  }

  /********** Finalize MPI **********/
  MPI_Barrier(main_comm);
  MPI_Finalize();
}

/********** Merge Function **********/
void merge(int * a, int * b, int l, int m, int r) {
  int h, i, j, k;
  h = l;
  i = l;
  j = m + 1;

  while ((h <= m) && (j <= r)) {
    if (a[h] <= a[j]) {
      b[i] = a[h];
      h++;
    } else {
      b[i] = a[j];
      j++;
    }
    i++;
  }

  if (m < h) {
    for (k = j; k <= r; k++) {
      b[i] = a[k];
      i++;
    }
  } else {
    for (k = h; k <= m; k++) {
      b[i] = a[k];
      i++;
    }
  }

  for (k = l; k <= r; k++) {
    a[k] = b[k];
  }
}

/********** Recursive Merge Function **********/
void mergeSort(int * a, int * b, int l, int r) {
  if (l < r) {
    int m = (l + r) / 2;
    mergeSort(a, b, l, m);
    mergeSort(a, b, m + 1, r);
    merge(a, b, l, m, r);
  }
}

/********** Read Array From File **********/
void read_array_from_file(int * array, int n,
  const char * file_name) {
  FILE * file = fopen(file_name, "r");
  if (file == NULL) {
    perror("Error opening file");
    MPI_Finalize();
    exit(EXIT_FAILURE);
  }

  for (int i = 0; i < n; i++) {
    if (fscanf(file, "%d", & array[i]) != 1) {
      fprintf(stderr, "Error reading array element %d\n", i);
      fclose(file);
      exit(EXIT_FAILURE);
    }
  }
  fclose(file);
}

/********** Save State Function **********/
void save_state(int * data, int size, int step, int rank) {
  FILE * file = fopen(checkpoint_file, "wb");
  if (file == NULL) {
    perror("Error creating checkpoint file");
    MPI_Abort(MPI_COMM_WORLD, EXIT_FAILURE);
  }
  fwrite( & step, sizeof(int), 1, file);
  fwrite( & rank, sizeof(int), 1, file);
  fwrite(data, sizeof(int), size, file);
  fclose(file);
}

/********** Load State Function **********/
bool load_state(int * data, int size, int * step, int * rank) {
  FILE * file = fopen(checkpoint_file, "rb");
  if (file == NULL) return false; // No checkpoint file
  fread(step, sizeof(int), 1, file);
  fread(rank, sizeof(int), 1, file);
  fread(data, sizeof(int), size, file);
  fclose(file);

  return true;
}

void error_handler(MPI_Comm * pcomm, int * error_code, ...) {
  int len;
  char error_string[MPI_MAX_ERROR_STRING];

  MPIX_Comm_shrink( * pcomm, & main_comm);

  MPI_Comm_set_errhandler(main_comm, errh);

  MPI_Comm_rank(main_comm, & rank);
  MPI_Comm_size(main_comm, & size);

  MPI_Error_string( * error_code, error_string, & len);
  printf("Rank %d / %d: Notified of error %s\n", rank, size, error_string);

  int step;
  int * original_array = (int * ) malloc(N * sizeof(int));
  if (rank == 0) {
    if (load_state(original_array, N, & step, & rank)) {
      printf("Checkpoint loaded. Resuming from step %d.\n", step);
    }
  }
}