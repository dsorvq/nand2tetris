#include <stdio.h>

int IsHexDigit(char a);

int HexToDecimal(char a);

void Decode();

void Encode();

int main() {
  Decode();
  
  return 0;
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

void Decode() {
  char ch1, ch2, ch3;
  int has_error = 0;
  int finished = 0;
  char decoded = 0;
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
