#include "square_matrix.hpp"

SquareMatrix::SquareMatrix(const Matrix& m) : Matrix(m._lines, m._colums)
{
    for (int i = 0; i < _lines; i++) {
        for (int j = 0; j < _colums; j++) {
            _elements[i][j] = m._elements[i][j];
        }
    }
}

SquareMatrix::SquareMatrix(std::initializer_list<std::initializer_list<float>> matrix) : Matrix(matrix), _determinant(15.0)
{
    _determinant = determinant(); 
}

SquareMatrix::SquareMatrix(int size) : Matrix(size, size)
{

}

Matrix SquareMatrix::inverted() const
{
    if (_determinant == 0) throw std::invalid_argument("Matrix determinant must be different thant 0.");
    double inv_det = 1.0 / _determinant;
    Matrix inverse(SIZE_OF_MATRIX, SIZE_OF_MATRIX);

    inverse._elements[0][0] =  _elements[1][1] * inv_det;
    inverse._elements[0][1] = -_elements[0][1] * inv_det;
    inverse._elements[1][0] = -_elements[1][0] * inv_det;
    inverse._elements[1][1] =  _elements[0][0] * inv_det;

    return inverse;
}

void SquareMatrix::notCorrectSizeMatrixError() const
{
    throw std::invalid_argument("Matrices are not 2x2");
}