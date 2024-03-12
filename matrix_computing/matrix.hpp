#pragma once
#include <iostream>
#include <iomanip>
#include <vector>
#include <initializer_list>
#include <stdexcept>
#include <sstream>

class MatrixCorrection;
class SquareMatrix;

class Matrix {
public:
    Matrix(std::initializer_list<std::initializer_list<float>> matrix);
    
    virtual ~Matrix();
    virtual float determinant() const;
    virtual Matrix inverted() const;
    virtual Matrix operator*(float) const;
    virtual Matrix operator*(const Matrix& m) const; 
    virtual Matrix operator+(const Matrix& m) const;
    bool operator==(const Matrix&) const;
    void print() const;
    static Matrix getIdentity(int size);
    friend std::ostream& operator<<(std::ostream& os, const Matrix&);
    friend MatrixCorrection;
    friend SquareMatrix;
protected:
    Matrix(int lines, int colums);
    void notMultiplicatableError(int lines_m2) const;
    void notAdditiveError(int lines_m2, int columns_m2) const;
    int _lines;
    int _colums;
    float** _elements;
};

Matrix operator*(float constant, const Matrix& other);
