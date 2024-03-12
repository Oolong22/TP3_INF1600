#include <cassert>
#include <cmath>
#include "matrix_correction.hpp"
#include "matrix.hpp"
#include "square_matrix.hpp"

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_GREEN   "\x1b[32m"
#define ANSI_COLOR_YELLOW  "\x1b[33m"
#define ANSI_COLOR_BLUE    "\x1b[34m"
#define ANSI_COLOR_MAGENTA "\x1b[35m"
#define ANSI_COLOR_CYAN    "\x1b[36m"
#define ANSI_COLOR_RESET   "\x1b[0m"

void multiplicationTest()
{
    std::cout << ANSI_COLOR_RED << "Multiplication test (2 Matrixes)" << std::endl;
    Matrix m1 = MatrixCorrection::generateRandomMatrix(2, 3);
    Matrix m2 = MatrixCorrection::generateRandomMatrix(3, 4);
    MatrixCorrection m1Copy = m1;
    MatrixCorrection m2Copy = m2;
    std::cout << ANSI_COLOR_YELLOW << m1 << m2 << std::endl;
    Matrix m3 = m1 * m2;
    assert(m3 == (m1Copy * m2Copy));
    std::cout << ANSI_COLOR_GREEN <<  "OK! Test passed!" << std::endl << "Resultant Matrix:" << std::endl;
    std::cout << std::endl << m3 << ANSI_COLOR_RESET << std::endl;
}

void multiplicationScalarTest()
{
    std::cout << ANSI_COLOR_RED << "Multiplication test (Matrixe with float)" << std::endl;
    Matrix m1 = MatrixCorrection::generateRandomMatrix(4, 5);
    MatrixCorrection m1Copy = m1;
    float randomFloat = MatrixCorrection::getRandomFloat();
    std::cout << ANSI_COLOR_YELLOW << m1 << std::endl << "Float: " << randomFloat << std::endl << std::endl;

    Matrix m3 = m1 * randomFloat;
    assert(m3 == (m1Copy * randomFloat));
    std::cout << ANSI_COLOR_GREEN << "OK! Test passed!" << std::endl << "Resultant Matrix:" << std::endl;
    std::cout << std::endl << m3 << ANSI_COLOR_RESET << std::endl;
}

void determinantTest()
{
    std::cout << ANSI_COLOR_RED << "Determinant test" << std::endl;
    SquareMatrix m1 = MatrixCorrection::generateRandomMatrix(2, 2);
    MatrixCorrection m1Copy = m1;
    std::cout << ANSI_COLOR_YELLOW << m1 << std::endl;
    assert(fabs(m1.determinant() - m1Copy.determinant()) < 0.001);
    std::cout << ANSI_COLOR_GREEN << "OK! Test passed!" << std::endl << "Inverted Matrix:" << std::endl;
    std::cout << std::endl << m1.inverted() << ANSI_COLOR_RESET << std::endl;
}

int main() {
    multiplicationScalarTest();
    multiplicationTest();
    determinantTest();
}