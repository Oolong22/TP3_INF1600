#include "matrix.hpp"

Matrix::Matrix(std::initializer_list<std::initializer_list<float>> matrix)
{
    _lines = matrix.size();
    _colums = _lines ? matrix.begin()->size() : 0;

    _elements = new float*[_lines];
    auto rowIt = matrix.begin();
    for (int i = 0; i < _lines; ++i, ++rowIt) {
        _elements[i] = new float[_colums];
        auto colIt = rowIt->begin();
        for (int j = 0; j < _colums; ++j, ++colIt) {
            *(*(_elements + i) + j) = *colIt; // equivalent to _elements[i][j] = *colIt;
        }
    }
}

Matrix::Matrix(int lines, int colums)
{
    _lines = lines;
    _colums = colums;
    _elements = new float*[_lines];
    for (int i = _lines - 1; i >= 0; --i) {
        _elements[i] = new float[_colums];
    }

}

void Matrix::notMultiplicatableError(int lines_m2) const
{
    std::stringstream ss;
    ss << "Matrices are not compatible for multiplication. Columns Matrix 1 are different than Lines Matrix 2. " << 
    _colums << " != " << lines_m2 << "." << std::endl;
    throw std::invalid_argument(ss.str());
}

void Matrix::notAdditiveError(int lines_m2, int columns_m2) const
{
    std::stringstream ss;
    ss << "Matrices are not compatible for addition.";
    if (_lines != lines_m2) ss << " Lines are differents: " << _lines << " != " << lines_m2 << ".";
    if (_colums != columns_m2) ss << " Columns are differents: " << _colums << " != " << columns_m2 << ".";
    ss << std::endl;
    throw std::invalid_argument(ss.str());
}

Matrix::~Matrix()
{
    for (int i = 0; i < _lines; ++i) {
        delete[] _elements[i];
    }
    delete[] _elements;
}

void Matrix::print() const {
    std::cout << *this << std::endl;
}

float Matrix::determinant() const
{
    throw std::logic_error("Function not implemented yet");
}

Matrix Matrix::inverted() const
{
    throw std::logic_error("Function not implemented yet");
}

bool Matrix::operator==(const Matrix& m) const
{
    if (_lines != m._lines or _colums != m._colums) {
        return false;
    }

    for (int i = 0; i < _lines; i++) {
        for (int j = 0; j < _colums; j++) {
            if ((int)_elements[i][j] != (int)m._elements[i][j]) {
                std::cout << _elements[i][j] << " " << m._elements[i][j] << " i " << i << " j " << j << std::endl;
                return false;
            }

        }
    }

    return true;
}

Matrix Matrix::getIdentity(int size)
{
    Matrix identity(size, size);

    for (int i = 0; i < size; ++i) {
        for (int j = 0; j < size; ++j) {
            identity._elements[i][j] = (i == j) ? 1 : 0;
        }
    }
    return identity;
}

Matrix operator*(float constant, const Matrix& other)
{
    return other * constant;
}

std::ostream& operator<<(std::ostream& os, const Matrix& m) 
{
    if (!m._elements || m._lines <= 0 || m._colums <= 0) return os;

    int max_width = 0;
    for (int i = 0; i < m._lines; ++i) {
        for (int j = 0; j < m._colums; ++j) {
            std::string elemStr = std::to_string(m._elements[i][j]);
            size_t dotPos = elemStr.find('.');
            if (dotPos != std::string::npos) {
                elemStr = elemStr.substr(0, dotPos + 3); // include point and 2 decimals after
            }
            max_width = std::max(max_width, static_cast<int>(elemStr.length()));
        }
    }

    os << "Matrix: " << m._lines << "x" << m._colums << std::endl;

    for (int i = 0; i < m._lines; ++i) {
        for (int j = 0; j < m._colums; ++j) {
            os << std::setw(max_width + 2) << std::fixed << std::setprecision(2) << m._elements[i][j];
        }
        os << std::endl;
    }
    return os;
}