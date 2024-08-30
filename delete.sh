#include <stdio.h>

void PrintError(int is_first);

int IsHexDigit(char a);

int HexToDecimal(char a);

void PrintHex(char a);

void Decode();

void Encode();

int main(int argc, char** argv) {
  if (argc != 2) {
    PrintError(1);
  } else if (argv[1][0] == '0') {
    Encode();
  } else if (argv[1][0] == '1') {
    Decode();
  } else {
    PrintError(1);
  }
  
  return 0;
}

void PrintError(int is_first) {
  if (is_first == 0) {
    printf(" ");
  }
  printf("n/a");
}

int IsHexDigit(char a) {
  return ('0' <= a && a <= '9') || ('A' <= a && a <= 'F');
}

int HexToDecimal(char a) {
  char decoded = 0;

  if ('0' <= a && a <= '9') {
    decoded = (a - '0');
  } else {
    decoded = (a - 'A') + 10;
  }

  return decoded;
}

void PrintHex(char a) {
  int first = 0, second = 0;

  first = (int)a / 16;
  second = (int)a % 16;

  if (first < 10) {
    first = first + '0';
  } else {
    first = first + 'A' - 10;
  }
  if (second < 10) {
    second = second + '0';
  } else {
    second = second + 'A' - 10;
  }

  printf("%c%c", (char)first, (char)second);
}

void Decode() {
  char ch1, ch2, ch3, decoded = 0;
  int has_error = 0, finished = 0;
  int is_first = 1;

  while (finished == 0) {
    ch1 = getchar();
    if (IsHexDigit(ch1) != 1) {
      finished = 1;
      has_error = 1;
      continue;
    }
    ch2 = getchar();
    if (IsHexDigit(ch2) != 1) {
      finished = 1;
      has_error = 1;
      continue;
    }
    ch3 = getchar();
    if (ch3 != ' ') {
      finished = 1;
      if (ch3 != EOF && ch3 != '\n') {
        has_error = 1; 
        continue;
      }
    }

    decoded = (char)(HexToDecimal(ch1) * 16 + HexToDecimal(ch2));
    if (decoded & 0x80) {
      has_error = 1;
      finished = 1;
      continue;
    }
    
    if (is_first == 1) {
      is_first = 0;
    } else {
      printf(" ");
    }
    printf("%c", decoded);
  }

  if (has_error) {
    if (is_first == 1) {
      is_first = 0;
    } else {
      printf(" ");
    }
    printf("n/a");
  }
}

void Encode() {
  char ch1, ch2;
  int finished = 0, has_error = 0;
  int is_first = 1;
  
  while (finished == 0) {
    ch1 = getchar();
    ch2 = getchar();
    if (ch2 != ' ') {
      finished = 1;
      if (ch2 != EOF && ch2 != '\n') {
        has_error = 1; 
        continue;
      }
    }

    if (is_first == 1) {
      is_first = 0;
    } else {
      printf(" ");
    }

    PrintHex(ch1); 
  }

  if (has_error) {
    if (is_first == 1) {
      is_first = 0;
    } else {
      printf(" ");
    }
    printf("n/a");
  }
}

