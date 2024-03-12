#include "matrix_correction.hpp"

MatrixCorrection::MatrixCorrection(std::initializer_list<std::initializer_list<float>> matrix) : Matrix(matrix)
{}

MatrixCorrection::MatrixCorrection(int lines, int colums) : Matrix(lines, colums)
{}

MatrixCorrection::MatrixCorrection(const Matrix& m) : Matrix(m._lines, m._colums)
{
    for (int i = 0; i < _lines; i++) {
        for (int j = 0; j < _colums; j++) {
            _elements[i][j] = m._elements[i][j];
        }
    }
}

Matrix MatrixCorrection::operator*(const Matrix& other) const
{
    if (_colums != other._lines) {
        notMultiplicatableError(other._lines);
    }

    Matrix newMatrix(_lines, other._colums);

    for (int i = 0; i < _lines; ++i) {
        for (int j = 0; j < other._colums; ++j) {
            newMatrix._elements[i][j] = 0;
            for (int k = 0; k < _colums; ++k) {
                newMatrix._elements[i][j] += _elements[i][k] * other._elements[k][j];
            }
        }
    }

    return newMatrix;
}

float MatrixCorrection::determinant() const
{
    if (_lines != SIZE_OF_MATRIX || _colums != SIZE_OF_MATRIX) {
        throw std::invalid_argument("Matrix must be 2x2.");
    }

    return _elements[0][0] * _elements[1][1] - _elements[0][1] * _elements[1][0];
}

Matrix MatrixCorrection::inverted() const
{
    double det = determinant();
    if (det == 0) throw std::invalid_argument("Matrix determinant must be different thant 0.");
    double inv_det = 1.0 / det;
    Matrix inverse(SIZE_OF_MATRIX, SIZE_OF_MATRIX);

    inverse._elements[0][0] =  _elements[1][1] * inv_det;
    inverse._elements[0][1] = -_elements[0][1] * inv_det;
    inverse._elements[1][0] = -_elements[1][0] * inv_det;
    inverse._elements[1][1] =  _elements[0][0] * inv_det;

    return inverse;
}

Matrix MatrixCorrection::generateRandomMatrix(int lines, int colums)
{
    Matrix randomMatrix(lines, colums);

    for (int i = 0; i < lines; i++) {
        for (int j = 0; j < colums; j++) {
            randomMatrix._elements[i][j] = getRandomFloat();
        }
    }

    return randomMatrix;
}

Matrix MatrixCorrection::operator*(float scalar) const
{
    Matrix newMatrix(_lines, _colums);

    for (int i = 0; i < _lines; ++i) {
        for (int j = 0; j < _colums; ++j) {
            newMatrix._elements[i][j] = _elements[i][j] * scalar;
        }
    }

    return newMatrix;
}

float MatrixCorrection::getRandomFloat() {
    unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
    std::default_random_engine generator(seed);
    std::uniform_real_distribution<float> distribution(MIN_FLOAT, MAX_FLOAT);
    return distribution(generator);
}
